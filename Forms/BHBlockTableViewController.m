//
//  BHBlockTableViewController.m
//  DistractMe
//
//  Created by Ashemah Harrison on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BHBlockTableViewController.h"
#import "BHNIBTools.h"

@interface BHBlockTableViewController ()

@end

@implementation BHBlockTableViewController

@synthesize heightForRow;
@synthesize configureCellForRow;
@synthesize didTapRow;
@synthesize didSwipeToDeleteRow;
@synthesize defaultRowHeight;
@synthesize isEmpty     = _isEmpty;
@synthesize emptyCellClass;
@synthesize emptyCell;
@synthesize currentCell;
@synthesize dummyCell;

@synthesize currentRow;
@synthesize currentRowIsFirstRow;
@synthesize currentRowIsLastRow;

@synthesize currentSectionIsLastSection;
@synthesize currentSectionIsFirstSection;
@synthesize currentRowIsSingleRow;

@synthesize currentObject;
@synthesize currentIndexPath;
@synthesize numberOfSectionsInTable;
@synthesize numberOfRowsInSection;
@synthesize frc = _frc;
@synthesize viewForHeaderInSection;
@synthesize heightForHeaderInSection;
@synthesize tableView;
@synthesize cellClass;

@synthesize selectedPaths;
@synthesize lastTappedPath;

@synthesize forceFullRefreshOnFRCChange;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedPaths = [NSMutableSet set];
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [self.currentSection isEditable];
//}

- (id)currentObject {
    
    if (self.frc) {
        return [self.frc objectAtIndexPath:_currentPath];
    }
    
    NSAssert(NO, @"Cannot use current object without a FRC");
    return nil;
}

- (id)currentCell {
    return _cell;
}

- (NSIndexPath*)currentIndexPath {
    return _currentPath;
}

- (BOOL)currentRowIsLastRow {
    return (_currentRow == _cachedNumberOfRowsInCurrentSection-1);
}

- (BOOL)currentRowIsFirstRow {
    return (_currentRow == 0);
}

- (BOOL)currentRowIsSingleRow {
    return (_cachedNumberOfRowsInCurrentSection == 1);
}

- (BOOL)currentSectionIsLastSection {
    return (_currentSection == _cachedNumberOfSections-1);
}

- (BOOL)currentSectionIsFirstSection {
    return (_currentSection == 0);
}

- (UITableViewCell*)cachedCell:(NSString*)class isNewCell:(BOOL*)isNewCell {
    
    UITableViewCell *cell = [BHNIBTools cachedTableCellWithClass:class tableView:self.tableView isNewCell:isNewCell];        
    return cell;
}

- (UITableViewCell*)cachedCell:(NSString*)class {
    
    UITableViewCell *cell = [BHNIBTools cachedTableCellWithClass:class tableView:self.tableView isNewCell:nil];        
    return cell;
}

- (void)tableView:(UITableView *)tableView1 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {        
        
        if (self.didSwipeToDeleteRow) {
            
            //
            _currentPath    = indexPath;
            _currentRow     = indexPath.row;
            _currentSection = indexPath.section;
            
            self.didSwipeToDeleteRow(self, _currentSection, _currentRow);
            self.forceFullRefresh = YES;
        }
    }     
}

- (int)sectionCount {
    
    if (self.frc) {
        _cachedNumberOfSections = [[self.frc sections] count];
        return _cachedNumberOfSections;
    }
    else if (self.numberOfSectionsInTable) {
        _cachedNumberOfSections = self.numberOfSectionsInTable(self);
        return _cachedNumberOfSections;
    }

    NSAssert(NO, @"Number of sections not specified");
    return 0;
}

- (int)numberOfSectionsInTableView:(UITableView *)theTableView {
    return [self sectionCount];
}

- (int)rowCountForSection:(NSInteger)section {
    
    if (self.frc) {
        id <NSFetchedResultsSectionInfo> sectInfo = [[self.frc sections] objectAtIndex:section];
        return [sectInfo numberOfObjects];
    }
    else if (self.numberOfRowsInSection) {
        return self.numberOfRowsInSection(self, section);
    }
    
    return 0;
}

- (int)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    
    return [self rowCountForSection:section];
    NSAssert(NO, @"Number of rows in section not specified");
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    //
    _currentPath    = indexPath;
    _currentSection = indexPath.section;
    _currentRow     = indexPath.row;
    _cachedNumberOfRowsInCurrentSection = [self tableView:self.tableView numberOfRowsInSection:_currentSection];
    _cell           = [self cachedCell:self.cellClass];
    
    if (self.heightForRow) {
        
        return self.heightForRow(self, indexPath.section, indexPath.row);
    }
    
    return _cell.frame.size.height;
}

- (UITableViewCell*)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
      
    //
    _currentPath    = indexPath;
    _currentSection = indexPath.section;
    _currentRow     = indexPath.row;
    _cachedNumberOfRowsInCurrentSection = [self tableView:self.tableView numberOfRowsInSection:_currentSection];
    _cell           = [self cachedCell:self.cellClass];
    
    //
    if (self.configureCellForRow) {
                
        self.configureCellForRow(self, indexPath.section, indexPath.row);
    }    
    
    return _cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.viewForHeaderInSection) {
        return self.viewForHeaderInSection(self, section);
    }
        
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.viewForHeaderInSection && self.heightForHeaderInSection) {
        return self.heightForHeaderInSection(self, section);
    }

    return 0;
}

- (void)setFrc:(NSFetchedResultsController *)frc1 {
    
    if (_frc != frc1) {
        _frc = frc1;
        _frc.delegate = self;
    }
    
    if (self.frc && self.tableRowCount) {
        self.tableRowCount(self, [[self.frc fetchedObjects] count]);
    }    
}

- (void)addSelectedPath:(NSIndexPath*)path {
    if (path) {
        [self.selectedPaths addObject:path];
    }
}

- (void)removeSelectedPath:(NSIndexPath*)path {
    if (path) {
        [self.selectedPaths removeObject:path];
    }
}

- (BOOL)isSelectedPath:(NSIndexPath*)path {
    if (!path) {
        return NO;
    }
    
    return [self.selectedPaths member:path] != nil;
}

#pragma mark -
#pragma mark Table View Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 50;
    
    if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	[theTableView deselectRowAtIndexPath:indexPath animated:YES];	
    
    //
    _currentPath    = indexPath;
    _currentSection = indexPath.section;
    _currentRow     = indexPath.row;
    _cachedNumberOfRowsInCurrentSection = [self tableView:self.tableView numberOfRowsInSection:_currentSection];
    _cell           = [self cachedCell:self.cellClass];
    
    if (self.didTapRow) {
        self.didTapRow(self, indexPath.section, indexPath.row);
    }    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if (!self.forceFullRefreshOnFRCChange) {
        // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
        [self.tableView beginUpdates];
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
            
    if (!self.forceFullRefreshOnFRCChange) {
    
        
        switch(type) {
                
            case NSFetchedResultsChangeInsert:
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                //[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
                break;
                
            case NSFetchedResultsChangeMove:
                [tableView deleteRowsAtIndexPaths:[NSArray
                                                   arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView insertRowsAtIndexPaths:[NSArray
                                                   arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
//        
//        switch(type) {
//                
//            case NSFetchedResultsChangeInsert:
//                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//                break;
//                
//            case NSFetchedResultsChangeDelete:
//                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
////                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
//                break;
//                
//            case NSFetchedResultsChangeUpdate:
//                if (newIndexPath) {
//                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//                }
//                break;
//                
//            case NSFetchedResultsChangeMove: {
//                
//                NSMutableIndexSet *foo = [NSMutableIndexSet indexSetWithIndex:indexPath.section];
//                // Reloading the section inserts a new row and ensures that titles are updated appropriately.
//                if (newIndexPath) {
//                    [foo addIndex:newIndexPath.section];
//                }
//
//                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
//        }
//                break;
//        }
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
        
    if (!self.forceFullRefreshOnFRCChange) {
    
        switch(type) {
                
            case NSFetchedResultsChangeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
        
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    if (self.forceFullRefreshOnFRCChange) {
        [self.tableView reloadData];
    }
    else {
        [self.tableView endUpdates];        
    }
    
    self.forceFullRefresh = NO;
    
    if (self.frc && self.tableRowCount) {
        self.tableRowCount(self, [[self.frc fetchedObjects] count]);
    }
    
    if (self.didCompleteDataRefresh && !self.ignoreDataChanges) {
        self.didCompleteDataRefresh(self);
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    NSInteger sectionRows = [self.tableView numberOfRowsInSection:[sourceIndexPath section]];
    
    UITableViewCell *sourceCell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
    UITableViewCell *destCell = [self.tableView cellForRowAtIndexPath:proposedDestinationIndexPath];
    
    if(sourceIndexPath.row == 0 && proposedDestinationIndexPath.row == 1) {
//        ((UIImageView *)destCell.backgroundView).image = [UIImage imageNamed:@"table_row_top_bkg.png"];
//        
//        if(proposedDestinationIndexPath.row == sectionRows - 1)
//            ((UIImageView *)sourceCell.backgroundView).image = [UIImage imageNamed:@"table_bottom_row_bkg.png"];
//        else
//            ((UIImageView *)sourceCell.backgroundView).image = [UIImage imageNamed:@"table_row_bkg.png"];
    }
    else if(sourceIndexPath.row == sectionRows - 1 && proposedDestinationIndexPath.row == sectionRows - 2) {
//        ((UIImageView *)destCell.backgroundView).image = [UIImage imageNamed:@"table_bottom_row_bkg.png"];
//        
//        if(proposedDestinationIndexPath.row == 0)
//            ((UIImageView *)sourceCell.backgroundView).image = [UIImage imageNamed:@"table_row_top_bkg.png"];
//        else
//            ((UIImageView *)sourceCell.backgroundView).image = [UIImage imageNamed:@"table_row_bkg.png"];
    }
    else if(proposedDestinationIndexPath.row == 0) {
//        ((UIImageView *)sourceCell.backgroundView).image = [UIImage imageNamed:@"table_row_top_bkg.png"];
//        
//        destCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:proposedDestinationIndexPath.section]];
//        if(sectionRows == 2)
//            ((UIImageView *)destCell.backgroundView).image = [UIImage imageNamed:@"table_bottom_row_bkg.png"];
//        else
//            ((UIImageView *)destCell.backgroundView).image = [UIImage imageNamed:@"table_row_bkg.png"];
    }
    else if(proposedDestinationIndexPath.row == sectionRows - 1) {
//        ((UIImageView *)sourceCell.backgroundView).image = [UIImage imageNamed:@"table_bottom_row_bkg.png"];
//        
//        destCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sectionRows - 1 inSection:proposedDestinationIndexPath.section]];
//        if(sectionRows == 2)
//            ((UIImageView *)destCell.backgroundView).image = [UIImage imageNamed:@"table_row_top_bkg.png"];
//        else
//            ((UIImageView *)destCell.backgroundView).image = [UIImage imageNamed:@"table_row_bkg.png"];
    }
    
    return proposedDestinationIndexPath;
}

@end

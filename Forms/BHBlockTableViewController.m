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
            
            _currentPath= indexPath;
            _currentRow = indexPath.row;
            
            self.didSwipeToDeleteRow(self, indexPath.section, indexPath.row);
        }
    }     
}

- (int)numberOfSectionsInTableView:(UITableView *)theTableView {
    
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

- (int)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.frc) {
        id <NSFetchedResultsSectionInfo> sectInfo = [[self.frc sections] objectAtIndex:section];
        return [sectInfo numberOfObjects];
    }
    else if (self.numberOfRowsInSection) {
        return self.numberOfRowsInSection(self, section);
    }

    NSAssert(NO, @"Number of rows in section not specified");
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    //
    _currentPath    = indexPath;
    _currentSection = indexPath.section;
    _currentRow     = indexPath.row;
    _cachedNumberOfRowsInCurrentSection = [self tableView:self.tableView numberOfRowsInSection:_currentSection];
    
    _cell       = [self cachedCell:self.cellClass];
    
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

    _cell       = [self cachedCell:self.cellClass];
    
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
    
    if (self.heightForHeaderInSection) {
        return self.heightForHeaderInSection(self, section);
    }

    return 0;
}

- (void)setFrc:(NSFetchedResultsController *)frc1 {
    
    if (_frc != frc1) {
        _frc = frc1;
        _frc.delegate = self;
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

    _cell       = [self cachedCell:self.cellClass];
    
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
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                if (newIndexPath) {
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                break;
                
            case NSFetchedResultsChangeMove:
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                // Reloading the section inserts a new row and ensures that titles are updated appropriately.
                if (newIndexPath) {
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                }
                break;
        }
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
}    

@end

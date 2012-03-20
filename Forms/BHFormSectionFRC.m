//
//  BHFetchedResultsControllerFormSection.m
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/16/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import "BHFormSectionFRC.h"
#import "BHNIBTools.h"

@implementation BHFormSectionFRC

@synthesize frc;
@synthesize widgetClass;
@synthesize heightForRowBlock;
@synthesize configureCellForRowBlock;
@synthesize didTapCellInSectionBlock;
@synthesize didSwipeDeleteCellInSectionBlock;
@synthesize currentObject;

+ (BHFormSectionFRC*)formSectionForFormVC:(BHBlockTableViewController*)vc widgetClass:(NSString*)widgetClass1 frc:(NSFetchedResultsController*)frc1 {
    return [[[BHFormSectionFRC alloc] initWithFormVC:vc widgetClass:widgetClass1 frc:frc1] autorelease];
}

- (id)initWithFormVC:(BHBlockTableViewController*)formVC1 widgetClass:(NSString*)widgetClass1 frc:(NSFetchedResultsController*)frc1 {
    
    if ((self = [super initWithFormVC:formVC1])) {
        self.widgetClass = widgetClass1;
        self.frc = frc1;
    }
    
    return self;
}

- (NSInteger)rowCount {

    id <NSFetchedResultsSectionInfo> sectInfo = [[self.frc sections] objectAtIndex:0];
    NSInteger num = [sectInfo numberOfObjects];
    return num;
}

- (CGFloat)internalHeightForRow:(NSInteger)row {
    
    if (self.defaultRowHeight > 0) {
        return self.defaultRowHeight;
    }
    
    self.dummyCell      = [self.formVC cachedCell:self.widgetClass];
    
    if (self.heightForRowBlock) {
        self.currentObject  = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];        
        self.currentRow     = row;

        self.isFirstRow = row == 0;
        self.isLastRow  = row == [self rowCount]-1;
        
        return self.heightForRowBlock();
    }
    
    return ((UIView*)self.dummyCell).frame.size.height;
}

- (id)internalCellForRow:(NSInteger)row {
    
    self.currentCell = [BHNIBTools cachedTableCellWithClass:self.widgetClass tableView:self.formVC.tableView];
    
    if (self.configureCellForRowBlock) {
        
        self.currentObject  = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        self.currentRow     = row;

        self.isFirstRow = row == 0;
        self.isLastRow  = row == [self rowCount]-1;
        
        self.configureCellForRowBlock();
    }
    
    return self.currentCell;
}

- (void)didTapRow:(NSInteger)row {
        
    if (self.didTapCellInSectionBlock) {
        
        self.currentCell    = [self.formVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:self.sectionIndex]];
        self.currentObject  = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        self.currentRow     = row;

        self.isFirstRow = row == 0;
        self.isLastRow  = row == [self rowCount]-1;
        
        self.didTapCellInSectionBlock();
    }
}

- (void)didSwipeDeleteRow:(NSInteger)row {
        
    if (self.didSwipeDeleteCellInSectionBlock) {
        
        self.currentCell    = [self.formVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:self.sectionIndex]];
        self.currentObject  = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        self.currentRow     = row;
        
        self.isFirstRow = row == 0;
        self.isLastRow  = row == [self rowCount]-1;
        
        self.didSwipeDeleteCellInSectionBlock();
        
        [self.frc performFetch:nil];
        [self.formVC.tableView reloadData];        
    }        
}

- (BOOL)isEditable {
    return (self.didSwipeDeleteCellInSectionBlock != nil);
}

/*
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.formVC.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView1 = self.formVC.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView1 insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView1 deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //            [self configureCell:[tableView1 cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView1 deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            // Reloading the section inserts a new row and ensures that titles are updated appropriately.
            [tableView1 reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.formVC.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.formVC.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.formVC.tableView endUpdates];
}
*/

@end
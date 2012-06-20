//
//  BHFormViewController.m
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/13/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import "BHBlockTableViewController.h"
#import "BHFormSection.h"
#import "BHNIBTools.h"

@implementation BHFormField
@synthesize widgetClass;

- (id)fieldWithWidgetClass:(NSString*)widgetClass1 {
    
    if ((self = [super init])) {
        self.widgetClass = widgetClass1;
    }
    
    return self;
}

@end

//-----------------------------------------------------------------------------------------------

@implementation BHBlockTableViewController

@synthesize tableView;
@synthesize sections;
@synthesize cacheDict;
@synthesize activeSections;
@synthesize currentSection;
@synthesize tableCache;

- (id)cachedObjectForKey:(NSString*)key {
    return [self.tableCache objectForKey:key];
}

- (void)cacheObject:(id)object forKey:(NSString*)key {
    [self.tableCache setObject:object forKey:key];
}

- (void)addSection:(BHFormSection*)section {
    [self.sections addObject:section];
    [self updateActiveSections];
}

- (void)dealloc {
    [super dealloc];
}

- (void)refreshForm {
    [self.tableView reloadData];
}

+ (UIView*)loadWidgetFromNIB:(NSString*)nibName {    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    return [nib objectAtIndex:0];
}

- (void)updateSection:(BHFormSection*) section {
    NSInteger index = [self.activeSections indexOfObject:section];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)updateActiveSections {
    
    NSInteger sectionIndex = 0;
    NSMutableArray *array = [NSMutableArray array];
    
    for (BHFormSection *section in self.sections) {
        
        if (!section.isHidden) {            
            section.sectionIndex = sectionIndex;
            sectionIndex++;
            
            [array addObject:section];
        }
    }
    
    self.activeSections = array;
}

- (void)openSectionAtIndex:(NSInteger)index {
    BHFormSection *sectionInfo = [self.activeSections objectAtIndex:index];
    sectionInfo.isOpen = YES;
}

- (void)closeSectionAtIndex:(NSInteger)index {
    BHFormSection *sectionInfo = [self.activeSections objectAtIndex:index];
    sectionInfo.isOpen = YES;
}

- (void)toggleSectionAtIndex:(NSInteger)index {
    BHFormSection *sectionInfo = [self.activeSections objectAtIndex:index];
    sectionInfo.isOpen = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAssert(self.tableView, @"TableView is nil");
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.sections = [NSMutableArray array];
    self.tableCache = [NSMutableDictionary dictionary];
}

- (UITableViewCell*)cachedCell:(NSString*)cellClassName {
    
    UITableViewCell *cell = [self.cacheDict objectForKey:cellClassName];
    
    if (!cell) {
        cell = (UITableViewCell*)[BHNIBTools loadFirstFromNIB:cellClassName];
        [self.cacheDict setObject:cell forKey:cellClassName];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentSection = [self.activeSections objectAtIndex:indexPath.section];
    return [self.currentSection isEditable];
}

- (void)tableView:(UITableView *)tableView1 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentSection = [self.activeSections objectAtIndex:indexPath.section];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {        
        [self.currentSection didSwipeDeleteRow:indexPath.row];                
    }     
}

- (int)numberOfSectionsInTableView:(UITableView *)theTableView {
    return [self.activeSections count];
}

- (int)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    self.currentSection = [self.activeSections objectAtIndex:section];
    return [self.currentSection rowCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    self.currentSection = [self.activeSections objectAtIndex:section];    
    return [self.currentSection heightForRow:row];   
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    self.currentSection = [self.activeSections objectAtIndex:section];    
    return [self.currentSection cellForRow:row];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    self.currentSection = [self.activeSections objectAtIndex:section];
    if (self.currentSection.headerView && self.currentSection.showHeader) {
        if ([self.currentSection isEmpty] && self.currentSection.hideHeaderWhenEmpty) {
            return nil;
        }
        else {
            return self.currentSection.headerView;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    self.currentSection = [self.activeSections objectAtIndex:section];
    if (self.currentSection.headerView && self.currentSection.showHeader) {
        if ([self.currentSection isEmpty] && self.currentSection.hideHeaderWhenEmpty) {
            return 0;
        }
        else {
            return self.currentSection.headerView.frame.size.height;
        }
    }
    return 0;
}

- (id)currentCell {
    return [self.currentSection currentCell];
}

- (id)dummyCell {
    return [self.currentSection dummyCell];
}

- (int)currentRow {    
    return [self.currentSection currentRow];
}

- (id)currentObject {    
    return [self.currentSection currentObject];
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
    
    self.currentSection = [self.activeSections objectAtIndex:indexPath.section];
    [self.currentSection didTapRow:indexPath.row];
}

#pragma mark -
#pragma mark Delegates

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView1 = self.tableView;
    
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
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.sections = nil;
    self.activeSections = nil;
    self.tableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

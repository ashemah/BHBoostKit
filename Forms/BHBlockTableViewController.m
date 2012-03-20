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
    BHFormSection *sectionInfo = [self.activeSections objectAtIndex:indexPath.section];
    return [sectionInfo isEditable];
}

- (void)tableView:(UITableView *)tableView1 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    BHFormSection *sectionInfo = [self.activeSections objectAtIndex:indexPath.section];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {        
        [sectionInfo didSwipeDeleteRow:indexPath.row];                
    }     
}

- (int)numberOfSectionsInTableView:(UITableView *)theTableView {
    return [self.activeSections count];
}

- (int)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    BHFormSection *sectionInfo = [self.activeSections objectAtIndex:section];
    return [sectionInfo rowCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    BHFormSection *sectionInfo = [self.activeSections objectAtIndex:section];
    
    return [sectionInfo heightForRow:row];   
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    BHFormSection *sectionInfo = [self.activeSections objectAtIndex:section];
    
    return [sectionInfo cellForRow:row];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    BHFormSection *sectionInfo = [self.activeSections objectAtIndex:section];
    return sectionInfo.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    BHFormSection *sectionInfo = [self.activeSections objectAtIndex:section];
    if (sectionInfo.headerView) {
        return sectionInfo.headerView.frame.size.height;
    }
    return 0;
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	[theTableView deselectRowAtIndexPath:indexPath animated:YES];	
    
    BHFormSection *sectionInfo = [self.activeSections objectAtIndex:indexPath.section];
    [sectionInfo didTapRow:indexPath.row];
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

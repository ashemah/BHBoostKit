//
//  BHFormViewController.m
//  TradieOffice
//
//  Created by Ashemah Harrison on 2/13/12.
//  Copyright (c) 2012 Boosted Human. All rights reserved.
//

#import "BHCompositeTableViewController.h"
#import "BHCompositeTableSection.h"
#import "BHNIBTools.h"

//-----------------------------------------------------------------------------------------------

@implementation BHCompositeTableViewController

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

- (void)addSection:(BHCompositeTableSection*)section {
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

- (void)updateSection:(BHCompositeTableSection*) section {
    NSInteger index = [self.activeSections indexOfObject:section];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)updateActiveSections {
    
    NSInteger sectionIndex = 0;
    NSMutableArray *array = [NSMutableArray array];
    
    for (BHCompositeTableSection *section in self.sections) {
        
        if (!section.isHidden) {            
            section.sectionIndex = sectionIndex;
            sectionIndex++;
            
            [array addObject:section];
        }
    }
    
    self.activeSections = array;
}

- (void)openSectionAtIndex:(NSInteger)index {
    BHCompositeTableSection *sectionInfo = [self.activeSections objectAtIndex:index];
    sectionInfo.isOpen = YES;
}

- (void)closeSectionAtIndex:(NSInteger)index {
    BHCompositeTableSection *sectionInfo = [self.activeSections objectAtIndex:index];
    sectionInfo.isOpen = YES;
}

- (void)toggleSectionAtIndex:(NSInteger)index {
    BHCompositeTableSection *sectionInfo = [self.activeSections objectAtIndex:index];
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
    
    NSInteger rowCount = [self.currentSection rowCount];

    return rowCount;
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
    
    NSInteger rowCount = [self.currentSection rowCount];
    
    if (self.currentSection.headerView && self.currentSection.showHeader) {
        if (rowCount == 0) {
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
    
    NSInteger rowCount = [self.currentSection rowCount];
    
    if (self.currentSection.headerView && self.currentSection.showHeader) {
        if (rowCount == 0) {
            return 0;
        }
        else {
            return self.currentSection.headerView.frame.size.height;
        }
    }
    return 0;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

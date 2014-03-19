//
//  PopoverContentViewController.m
//  iOSTools
//
//  Created by Alex Kurochkin on 8/21/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

#import "PopoverContentViewController.h"
#import <objc/runtime.h>

static char UI_COMPLETION_BLOCK;
static char UI_SELECTED_ITEMS_BLOCK;

@interface PopoverContentViewController ()

@property (nonatomic, retain, readwrite) NSArray *contentItems;

@end

@implementation PopoverContentViewController

#pragma mark - properties

@synthesize contentItems;
@synthesize choosenItems;
@dynamic choosenItemBlock;
@dynamic selectedIndexesBlock;

- (void)setChoosenItemBlock:(PopoverChosenItemBlock)choosenItemBlock {
	objc_setAssociatedObject(self,&UI_COMPLETION_BLOCK,choosenItemBlock,OBJC_ASSOCIATION_COPY);
}

- (PopoverChosenItemBlock)choosenItemBlock {
	return objc_getAssociatedObject(self, &UI_COMPLETION_BLOCK);
}

- (void)setSelectedIndexesBlock:(SelectedItemsBlock)selectedIndexesBlock {
	objc_setAssociatedObject(self,&UI_SELECTED_ITEMS_BLOCK,selectedIndexesBlock,OBJC_ASSOCIATION_COPY);
}

- (SelectedItemsBlock)selectedIndexesBlock {
	return objc_getAssociatedObject(self, &UI_SELECTED_ITEMS_BLOCK);
}

#pragma mark - initializations

- (id)initWithItems:(NSArray *)items choosenItemBlock:(PopoverChosenItemBlock)block {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.contentItems = items;
        self.choosenItemBlock = block;
    }
    return self;
}

- (id)initWithItems:(NSArray *)items choosenItems:(NSArray *)chossedItems choosenItemBlock:(PopoverChosenItemBlock)block {
    self = [self initWithItems:items choosenItemBlock:block];
    if (self != nil) {
        self.choosenItems = chossedItems;
    }
    return self;
}

- (id)initWithItems:(NSArray *)items choosenItems:(NSArray *)chossedItems selectedItemBlock:(SelectedItemsBlock)block {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.contentItems = items;
        self.choosenItems = chossedItems;
        self.selectedIndexesBlock = block;
    }
    return self;
}

- (void)dealloc {
    self.choosenItemBlock = nil;
    self.selectedIndexesBlock = nil;
    [self clean];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self clean];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.choosenItemBlock) {
        self.choosenItemBlock(indexPath.row);
    }
    
    if (self.selectedIndexesBlock) {
        self.selectedIndexesBlock ([tableView indexPathsForSelectedRows]);
    }
}

@end

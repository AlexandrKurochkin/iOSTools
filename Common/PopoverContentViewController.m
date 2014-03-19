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

@interface PopoverContentViewController ()

@property (nonatomic, retain, readwrite) NSArray *contentItems;

@end

@implementation PopoverContentViewController

@synthesize contentItems;
@synthesize choosenItems;
@dynamic choosenOfferBlock;

- (void)setChoosenOfferBlock:(ChosenOfferBlock)scanningCompletionBlock {
	objc_setAssociatedObject(self,&UI_COMPLETION_BLOCK,scanningCompletionBlock,OBJC_ASSOCIATION_COPY);
}

- (ChosenOfferBlock)choosenOfferBlock {
	return objc_getAssociatedObject(self, &UI_COMPLETION_BLOCK);
}

- (id)initWithItems:(NSArray *)items choosenItemBlock:(ChosenOfferBlock)block {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.contentItems = items;
        self.choosenOfferBlock = block;
    }
    return self;
}

- (id)initWithItems:(NSArray *)items choosenItems:(NSArray *)chossedItems choosenItemBlock:(ChosenOfferBlock)block {
    self = [self initWithItems:items choosenItemBlock:block];
    if (self != nil) {
        self.choosenItems = chossedItems;
    }
    return self;
}

- (void)dealloc {
    self.choosenOfferBlock = nil;
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
    self.choosenOfferBlock(indexPath.row);
}

@end

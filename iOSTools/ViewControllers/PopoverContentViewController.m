//
//  PopoverContentViewController.m
//  https://github.com/AlexandrKurochkin/iOSTools
//  Licensed under the terms of the BSD License, as specified below.
//
/*
 Copyright (c) 2014, Alexandr Kurochkin
 
 All rights reserved.
 
 * Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice,
 this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the iOSTools nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "PopoverContentViewController.h"
#import <objc/runtime.h>
#import "iOSTools.h"

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

- (id)initWithItems:(NSArray *)items {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.contentItems = items;
    }
    return self;
    
}

- (id)initWithItems:(NSArray *)items choosenItemBlock:(PopoverChosenItemBlock)block {
    self = [self initWithItems:items];
    if (self) {
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

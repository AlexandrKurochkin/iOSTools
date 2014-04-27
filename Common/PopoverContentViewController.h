//
//  PopoverContentViewController.h
//  iOSTools
//
//  Created by Alex Kurochkin on 8/21/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^PopoverChosenItemBlock)(NSInteger index);
typedef void(^SelectedItemsBlock)(NSArray *indexesOfselectedItems);

@interface PopoverContentViewController : UITableViewController

@property (nonatomic, retain, readonly) NSArray *contentItems;
@property (nonatomic, strong, readwrite) NSArray *choosenItems;
@property (nonatomic, assign, readwrite) PopoverChosenItemBlock choosenItemBlock;
@property (nonatomic, assign, readwrite) SelectedItemsBlock selectedIndexesBlock;


- (id)initWithItems:(NSArray *)items;
- (id)initWithItems:(NSArray *)items choosenItemBlock:(PopoverChosenItemBlock)block;
- (id)initWithItems:(NSArray *)items choosenItems:(NSArray *)chossedItems choosenItemBlock:(PopoverChosenItemBlock)block;

- (id)initWithItems:(NSArray *)items choosenItems:(NSArray *)chossedItems selectedItemBlock:(SelectedItemsBlock)block;

@end

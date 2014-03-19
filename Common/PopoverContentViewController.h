//
//  PopoverContentViewController.h
//  iOSTools
//
//  Created by Alex Kurochkin on 8/21/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ChosenOfferBlock)(NSInteger index);

@interface PopoverContentViewController : UITableViewController

@property (nonatomic, retain, readonly) NSArray *contentItems;
@property (nonatomic, strong, readwrite) NSArray *choosenItems;
@property (nonatomic, assign, readwrite) ChosenOfferBlock choosenOfferBlock;

- (id)initWithItems:(NSArray *)items choosenItemBlock:(ChosenOfferBlock)block;
- (id)initWithItems:(NSArray *)items choosenItems:(NSArray *)chossedItems choosenItemBlock:(ChosenOfferBlock)block;

@end

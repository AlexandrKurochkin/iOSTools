//
//  DatePickerViewController.m
//  iOSTools
//
//  Created by Alex Kurochkin on 3/2/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import "DatePickerViewController.h"
#import <objc/runtime.h>

static char UI_COMPLETION_BLOCK;

@interface DatePickerViewController ()

@property (nonatomic, strong, readwrite) NSDate *startDate;
@property (nonatomic, assign, readwrite) ChosenDateBlock choosenDateBlock;

@end

@implementation DatePickerViewController

@synthesize datePicker, startDate;

- (void)setChoosenDateBlock:(ChosenDateBlock)scanningCompletionBlock {
	objc_setAssociatedObject(self,&UI_COMPLETION_BLOCK,scanningCompletionBlock,OBJC_ASSOCIATION_COPY);
}

- (ChosenDateBlock)choosenDateBlock {
	return objc_getAssociatedObject(self, &UI_COMPLETION_BLOCK);
}


- (id)initWithStartDate:(NSDate *)date choosenDateBlock:(ChosenDateBlock)aChoosenDateBlock {
    self = [super initWithNibName:@"DatePickerViewController" bundle:nil];
    if (self) {
        self.startDate = date;
        self.choosenDateBlock = aChoosenDateBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datePicker.date = self.startDate;
}

ARC_DEALLOC

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self clean];
}

- (IBAction)valueChanged:(UIDatePicker *)sender {
    self.choosenDateBlock(sender);
}

@end

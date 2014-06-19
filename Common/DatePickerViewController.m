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

@interface DatePickerViewController () {
    UIDatePickerMode _datePickerMode;
}

@property (nonatomic, strong, readwrite) NSDate *startDate;
@property (nonatomic, assign, readwrite) ChosenDateBlock choosenDateBlock;
@property (nonatomic, assign, readwrite) UIDatePickerMode datePickerMode;

@end

@implementation DatePickerViewController

@synthesize datePicker, startDate;
@synthesize datePickerMode = _datePickerMode;

- (void)setChoosenDateBlock:(ChosenDateBlock)scanningCompletionBlock {
	objc_setAssociatedObject(self,&UI_COMPLETION_BLOCK,scanningCompletionBlock,OBJC_ASSOCIATION_COPY);
}

- (ChosenDateBlock)choosenDateBlock {
	return objc_getAssociatedObject(self, &UI_COMPLETION_BLOCK);
}


- (id)initWithDatePickerMode:(UIDatePickerMode)datePickerMode startDate:(NSDate *)date choosenDateBlock:(ChosenDateBlock)aChoosenDateBlock {
    self = [super initWithNibName:@"DatePickerViewController" bundle:nil];
    if (self) {
        self.startDate = date;
        self.datePickerMode = datePickerMode;
        self.choosenDateBlock = aChoosenDateBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datePicker.date = self.startDate;
    self.datePicker.datePickerMode = self.datePickerMode;
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

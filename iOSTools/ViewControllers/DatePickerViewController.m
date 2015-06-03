//
//  DatePickerViewController.m
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

#import "DatePickerViewController.h"
#import <objc/runtime.h>
#import "iOSTools.h"

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
@synthesize minuteInterval;

- (void)setChoosenDateBlock:(ChosenDateBlock)scanningCompletionBlock {
	objc_setAssociatedObject(self,&UI_COMPLETION_BLOCK,scanningCompletionBlock,OBJC_ASSOCIATION_COPY);
}

- (ChosenDateBlock)choosenDateBlock {
	return objc_getAssociatedObject(self, &UI_COMPLETION_BLOCK);
}

- (id)initWithDatePickerMode:(UIDatePickerMode)datePickerMode startDate:(NSDate *)date choosenDateBlock:(ChosenDateBlock)aChoosenDateBlock {
    return [self initWithDatePickerMode:datePickerMode minuteInterval:0 startDate:date choosenDateBlock:aChoosenDateBlock];
}


- (id)initWithDatePickerMode:(UIDatePickerMode)datePickerMode minuteInterval:(NSInteger)aMinuteInterval startDate:(NSDate *)date choosenDateBlock:(ChosenDateBlock)aChoosenDateBlock {
    self = [super initWithNibName:@"DatePickerViewController" bundle:nil];
    if (self) {
        self.startDate = date;
        self.datePickerMode = datePickerMode;
        self.choosenDateBlock = aChoosenDateBlock;
        self.minuteInterval = (aMinuteInterval == 0) ? 5 : aMinuteInterval;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datePicker.date = self.startDate;
    self.datePicker.datePickerMode = self.datePickerMode;
    self.datePicker.minuteInterval = self.minuteInterval;
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

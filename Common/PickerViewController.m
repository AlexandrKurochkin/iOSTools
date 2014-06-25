//
//  PickerViewController.m
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

#import "PickerViewController.h"
#import <objc/runtime.h>


static char UI_COMPLETION_BLOCK;

@implementation NSDictionary (DatePickerAdditions)

- (void)setValue:(id)value forComponent:(NSUInteger)component andRow:(NSUInteger)row {
    [self setValue:value forKey:[NSString stringWithFormat:@"%lu - %lu", (unsigned long)component, (unsigned long)row]];
}

- (id)valueForComponent:(NSUInteger)component andRow:(NSUInteger)row {
   return [self objectForKey:[NSString stringWithFormat:@"%lu - %lu", (unsigned long)component, (unsigned long)row]];
}

@end


@interface PickerViewController ()

@property (nonatomic, unsafe_unretained, readwrite) NSUInteger components;
@property (nonatomic, unsafe_unretained, readwrite) NSUInteger rowsInComponent;
@property (nonatomic, strong, readwrite) NSDictionary *items;
@property (nonatomic, assign, readwrite) ChosenItemBlock choosenItemBlock;

@end

@implementation PickerViewController

#pragma mark - properties

@synthesize aPickerView;
@synthesize components = _components;
@synthesize rowsInComponent = _rowsInComponent;
@synthesize items = _items;
@dynamic choosenItemBlock;


- (void)setChoosenItemBlock:(ChosenItemBlock)scanningCompletionBlock {
	objc_setAssociatedObject(self,&UI_COMPLETION_BLOCK,scanningCompletionBlock,OBJC_ASSOCIATION_COPY);
}

- (ChosenItemBlock)choosenItemBlock {
	return objc_getAssociatedObject(self, &UI_COMPLETION_BLOCK);
}

#pragma marks - Life cycle

- (id)initWithComponents:(NSUInteger)components rowsInComponent:(NSUInteger)rowsInComponent
                items:(NSDictionary *)items chosenItemBlock:(ChosenItemBlock)chosenItemBlock {
    
    self = [super initWithNibName:@"PickerViewController" bundle:nil];
    if (self) {
        self.components            = (components > 0) ? components : 1;
        self.rowsInComponent    = (rowsInComponent > 0) ? rowsInComponent : 1;
        self.items              = (items) ? items : @{@"0 - 0" : @"No Title" };
        self.choosenItemBlock = chosenItemBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self clean];
}

ARC_DEALLOC

#pragma mark - UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.components;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.rowsInComponent;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *s = [self.items valueForComponent:component andRow:row];
    return s;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.choosenItemBlock(pickerView, row, component);
}

@end

//
//  PickerViewController.m
//  iOSTools
//
//  Created by Alex Kurochkin on 3/2/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import "PickerViewController.h"
#import <objc/runtime.h>


static char UI_COMPLETION_BLOCK;

@implementation NSDictionary (DatePickerAdditions)

- (void)setValue:(id)value forComponent:(NSUInteger)component andRow:(NSUInteger)row {
    [self setValue:value forKey:[NSString stringWithFormat:@"%d - %d", component, row]];
}

- (id)valueForComponent:(NSUInteger)component andRow:(NSUInteger)row {
   return [self objectForKey:[NSString stringWithFormat:@"%d - %d", component, row]];
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

//
//  PickerViewController.h
//  iOSTools
//
//  Created by Alex Kurochkin on 3/2/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChosenItemBlock)(UIPickerView *picker, NSUInteger selectedRow, NSUInteger selectedComponent);


@interface NSDictionary (DatePickerAdditions)

- (void)setValue:(id)value forComponent:(NSUInteger)component andRow:(NSUInteger)row;
- (id)valueForComponent:(NSUInteger)component andRow:(NSUInteger)row;

@end


@interface PickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIPickerViewAccessibilityDelegate>

@property (nonatomic, weak, readwrite) IBOutlet UIPickerView *aPickerView;

- (id)initWithComponents:(NSUInteger)components rowsInComponent:(NSUInteger)rowsInComponent
                   items:(NSDictionary *)items chosenItemBlock:(ChosenItemBlock)chosenItemBlock;
@end

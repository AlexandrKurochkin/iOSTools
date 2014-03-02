//
//  DatePickerViewController.h
//  iOSTools
//
//  Created by Alex Kurochkin on 3/2/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChosenDateBlock)(UIDatePicker *datePicker);


@interface DatePickerViewController : UIViewController

@property (nonatomic, weak, readwrite) IBOutlet UIDatePicker *datePicker;

- (id)initWithStartDate:(NSDate *)date choosenDateBlock:(ChosenDateBlock)aChoosenDateBlock;

- (IBAction)valueChanged:(UIDatePicker *)sender;

@end

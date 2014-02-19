//
//  KeyboardListener.m
//  WheninMerchant_ios
//
//  Created by Alex Kurochkin on 2/19/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import "KeyboardListener.h"

@interface KeyboardListener () {
    BOOL _isVisible;
}

@property (nonatomic, unsafe_unretained, readwrite) BOOL isVisible;

@end

@implementation KeyboardListener

@synthesize isVisible;

+ (instancetype)sharedListener {
    static KeyboardListener *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KeyboardListener alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (id)init {
	self = [super init];
    
	if (self != nil) {
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		[center addObserver:self selector:@selector(noticeShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
		[center addObserver:self selector:@selector(noticeHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
	}
    
	return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self clean];
}

- (void)noticeShowKeyboard:(NSNotification *)inNotification {
	self.isVisible = YES;
}

- (void)noticeHideKeyboard:(NSNotification *)inNotification {
	self.isVisible = NO;
}

@end

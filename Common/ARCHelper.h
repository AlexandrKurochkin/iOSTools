//
//  ARCHelper.h
//  iOSTools
//
//  Created by Alex Kurochkin on 2/7/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

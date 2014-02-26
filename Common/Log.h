//
//  Log.h
//  iOSTools
//  Created by Alexandr Kurochkin on 5/10/12.
//  Copyright (c) 2012 OneClickDev. All rights reserved.
//

#ifndef VisitNordsjaelland_VNLog_h
#define VisitNordsjaelland_VNLog_h


#define MakeLogString(...) [NSString stringWithFormat:@"%s:%d -> %@",__PRETTY_FUNCTION__,__LINE__,[NSString stringWithFormat:__VA_ARGS__]]

#ifdef OCD_USE_LOG_TO_FILE
#import "RCLogger.h"

#if defined(DEBUG) || defined(OCD_USE_FULL_LOGGING)
#define RLog(...)   RCLog(@"%@",MakeLogString(__VA_ARGS__)); NSLog(@"%@",MakeLogString(__VA_ARGS__))  
#define DLog(...)   RLog(__VA_ARGS__) 
#else 
#define RLog(...)   RCLog(@"%@",MakeLogString(__VA_ARGS__))   
#define DLog(...)
#endif
#else
#define RLog(...) NSLog(@"%@",MakeLogString(__VA_ARGS__)) 

#if defined(DEBUG) || defined(OCD_USE_FULL_LOGGING)
#define DLog(...) RLog(__VA_ARGS__)
#else
#define DLog(...)
#endif
#endif

#define  /* TODO: NOT_IMPLEMENTED_YET */TODO_NOT_IMPLEMENTED_YET			DLog(@"TODO! Not implemented yet.");

#endif

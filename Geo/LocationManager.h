//
//  LocationManager.h
//  VisitNordsjaelland
//
//  Created by Alexandr Kurochkin on 6/13/12.
//  Copyright (c) 2012 OneClickDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"


typedef void(^CoordinateResponse)(CLLocationCoordinate2D coordinate);

@interface LocationManager : NSObject  < CLLocationManagerDelegate > {

@private
    CLLocationManager *_locationManager;
    CLLocationCoordinate2D _currentLocationCoordinate;
//    NSTimer *_timer;
    BOOL _isNewCoordinate; 
}

@property (nonatomic, assign, readwrite) CLLocationCoordinate2D currentLocationCoordinate;
@property (nonatomic, assign, readonly) BOOL isNewCoordinate;

+ (id)sharedManager;

- (CLLocationCoordinate2D)currentIphoneLoacationCordinate;
- (void)updateCoordinate;

+ (void)coordinatsFromAddress:(NSString *)address coordinateResponse:(CoordinateResponse)coordinateResponse;

@end

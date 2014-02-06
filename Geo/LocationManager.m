//
//  LocationManager.m
//  VisitNordsjaelland
//
//  Created by Alexandr Kurochkin on 6/13/12.
//  Copyright (c) 2012 OneClickDev. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()

@property (nonatomic, strong, readwrite) CLLocationManager *locationManager;

@property (nonatomic, assign, readwrite) NSTimer *timer;
@property (nonatomic, assign, readwrite) BOOL isNewCoordinate;
@end

@implementation LocationManager

@synthesize locationManager = _locationManager;
@synthesize currentLocationCoordinate = _currentLocationCoordinate;
@synthesize timer = _timer;
@synthesize isNewCoordinate = _isNewCoordinate;

static LocationManager *sharedInstance = nil;

+ (id)sharedManager {
	if (sharedInstance == nil) {
		sharedInstance = [[self alloc] init];
	}
	return sharedInstance;
}

- (id)init {
	self = [super init];
	if (self != nil) {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 100; // 0,1 kilometer
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3f
                                                        target:self 
                                                      selector:@selector(updateCoordinate) 
                                                      userInfo:nil 
                                                       repeats:YES];
        self.isNewCoordinate = NO;
        
	}
	return self;
}

- (void)dealloc {
    self.timer = nil;
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    [super dealloc];
}


- (CLLocationCoordinate2D)currentIphoneLoacationCordinate {
    return self.currentLocationCoordinate;
    //TODO: add for tests
//    return  CLLocationCoordinate2DMake(38.8056564331055, -77.0522766113281);
}

- (void)updateCoordinate {
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    self.currentLocationCoordinate = newLocation.coordinate;
    [manager stopUpdatingLocation];
    self.isNewCoordinate = YES;
    //DLog(@"new current location");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code ==  kCLErrorDenied) {
        DLog(@"");
        [self.timer invalidate];
    }
}

#pragma mark -

/*
- (double)metersToItem:(VNItem *)item {
    
    double lat, lng, returnDistance;
    lat = [item.geoLatitude doubleValue];
    lng = [item.geoLongtitude doubleValue];
    if (lat != 0 && lng != 0) {
        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:self.currentLocationCoordinate.latitude longitude:self.currentLocationCoordinate.longitude];
        
        CLLocation *itemLocation = [[CLLocation alloc] initWithLatitude: lat longitude:lng];
    
        CLLocationDistance distance = [currentLocation distanceFromLocation:itemLocation];

        [currentLocation release];
        [itemLocation release];
        returnDistance = distance / 1000;
    } else {
        returnDistance = 999999999;
    }
        
    return returnDistance;
}

- (NSString *)distanceToItem:(VNItem *)item {
    double distanseKilometrs = [self metersToItem:item] / 1000;
    return [NSString stringWithFormat:@"%.3f km", distanseKilometrs];
}
*/



@end

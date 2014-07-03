//
//  LocationManager.m
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

#import "LocationManager.h"

@interface LocationManager ()

@property (nonatomic, strong, readwrite) CLLocationManager *locationManager;

@property (nonatomic, unsafe_unretained, readwrite) NSTimer *timer;
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
        self.locationManager = [[CLLocationManager alloc] init];
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

+ (void)coordinatsFromAddress:(NSString *)address coordinateResponse:(CoordinateResponse)coordinateResponse; {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error){
        for (CLPlacemark* aPlacemark in placemarks) {
            // Process the placemark.
            CLLocationCoordinate2D coord = aPlacemark.location.coordinate;
            coordinateResponse (coord);
        }
    }];
}

@end

//
//  DrawRoutesManager.h
//  WheniniOS
//
//  Created by Alex Kurochkin on 8/19/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "CoreLocation/CoreLocation.h"

@interface DrawRoutesManager : NSObject

@property (nonatomic, retain, readwrite) UIColor *fillColor;
@property (nonatomic, retain, readwrite) UIColor *strokeColor;
@property (nonatomic, assign, readwrite) CGFloat width;
//@property (nonatomic, assign, readwrite) double distanceAtMeters;
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D destinationPoint;

+ (instancetype)sharedManager;

- (void)drawRoutFromPoint:(CLLocationCoordinate2D)origin to:(CLLocationCoordinate2D)destination onMapView:(MKMapView *)mapView;
- (void)centerMapView:(MKMapView *)mapView;
- (double)metrsOfCurrentDistanceFrom:(CLLocationCoordinate2D)origin to:(CLLocationCoordinate2D)destination;

- (void)centerMap:(MKMapView *)mapView forRoutePoints:(NSArray *)arrRoutePoints;

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
- (MKPolylineRenderer *)routePolylineView;
#else
- (MKPolylineView *)routePolylineView;
#endif


@end

//
//  DrawRoutesManager.m
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

#import "DrawRoutesManager.h"
#import "RegexKitLite.h"

@interface DrawRoutesManager ()

@property (nonatomic, retain, readwrite) MKPolyline *objPolyline;
@property (nonatomic, retain, readwrite) NSArray *arrayPoints;

@end

@implementation DrawRoutesManager

#pragma mark -
#pragma mark - initialization
#pragma mark -

@synthesize objPolyline;
@synthesize fillColor;
@synthesize strokeColor;
@synthesize arrayPoints;
@synthesize width;
//@synthesize distanceAtMeters;
@synthesize destinationPoint;

static DrawRoutesManager *sharedInstance = nil;

+ (instancetype)sharedManager {
    if (sharedInstance == nil) {
		sharedInstance = [[self alloc] init];
	}
	return sharedInstance;

}

- (void)dealloc {
    self.objPolyline = nil;
    self.fillColor = nil;
    self.strokeColor = nil;
    self.arrayPoints = nil;

}


#pragma mark -
#pragma mark - interface
#pragma mark -



#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
- (MKPolylineRenderer *)routePolylineView {
    
    MKPolylineRenderer *view = [[MKPolylineRenderer alloc] initWithPolyline:self.objPolyline];
    view.fillColor = (self.fillColor) ? self.fillColor : [UIColor blueColor];
    view.strokeColor = (self.strokeColor) ? self.strokeColor : [UIColor blueColor];
    view.lineWidth = (width > 0) ? width : 4;
    return view;
}
#else
- (MKPolylineView *)routePolylineView {
    
    MKPolylineView *view = [[MKPolylineView alloc] initWithPolyline:self.objPolyline];
    view.fillColor = (self.fillColor) ? self.fillColor : [UIColor blueColor];
    view.strokeColor = (self.strokeColor) ? self.strokeColor : [UIColor blueColor];
    view.lineWidth = (width > 0) ? width : 4;
    return view;
}
#endif


- (void)drawRoutFromPoint:(CLLocationCoordinate2D)origin to:(CLLocationCoordinate2D)destination onMapView:(MKMapView *)mapView {
    if ([self.arrayPoints count] < 1 ||
        destination.latitude != self.destinationPoint.latitude ||
        destination.longitude != self.destinationPoint.longitude) {
        
        self.arrayPoints = [self getRoutePointFrom:origin to:destination];
        self.destinationPoint = destination;
    }
    [self drawRoute:self.arrayPoints onTheMapView:mapView];
}

- (void)centerMapView:(MKMapView *)mapView {
    [self centerMap:mapView forRoutePoints:self.arrayPoints];
}

#pragma mark -
#pragma mark - Calcultions of the Routes
#pragma mark - 

- (NSArray*)getRoutePointFrom:(CLLocationCoordinate2D)origin to:(CLLocationCoordinate2D)destination {
    
    NSArray *retunrnValue = nil;

//    DLog(@"destination.latitude : %lf, destination.longitude: %lf", destination.latitude, destination.longitude);
    NSString* saddr = [NSString stringWithFormat:@"%f,%f", origin.latitude, origin.longitude];
    NSString* daddr = [NSString stringWithFormat:@"%f,%f", destination.latitude, destination.longitude];
    
    NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
    NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
    
    NSError *error = nil;
//    DLog(@"1");
    NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl encoding:NSUTF8StringEncoding error:&error];
    
    if (error == nil) {
//        DLog(@"2");
        NSString* encodedPoints = [apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
//        DLog(@"3 encodedPoints: %@", encodedPoints);
        //    return [self decodePolyLine:[encodedPoints mutableCopy]];
        if  (encodedPoints.length > 0) {
            NSMutableString *mutString = [NSMutableString stringWithString:encodedPoints];
            retunrnValue = [self decodePolyLine:mutString];
        }
        
    } else {
        [error print];
    }

    return retunrnValue;
}

- (NSMutableArray *)decodePolyLine:(NSMutableString *)encodedString {
    [encodedString replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                      options:NSLiteralSearch
                                        range:NSMakeRange(0, [encodedString length])];
    NSInteger len = [encodedString length];
    NSInteger index = 0;
    NSMutableArray *array = [NSMutableArray array];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encodedString characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encodedString characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:(lat * 1e-5) longitude:(lng * 1e-5)];
        [array addObject:loc];
    }
    return array;
}

- (double)metrsOfCurrentDistanceFrom:(CLLocationCoordinate2D)origin to:(CLLocationCoordinate2D)destination {
    
    if ([self.arrayPoints count] < 1 ||
        destination.latitude != self.destinationPoint.latitude ||
        destination.longitude != self.destinationPoint.longitude) {
        
        self.arrayPoints = [self getRoutePointFrom:origin to:destination];
        self.destinationPoint = destination;
    }

    
    double returnDistance = kWrongValue;
    if (self.arrayPoints.count > 0) {
        for (int i = 0; i < [self.arrayPoints count]-1; i++) {
            CLLocation* first = (self.arrayPoints)[i];
            CLLocation* second = (self.arrayPoints)[(i+1)];
            CLLocationDistance distance = [first distanceFromLocation:second];
            returnDistance += distance;
        }        
    }
    
    
    return returnDistance;
}


#pragma mark -
#pragma mark - Drawing on the map
#pragma mark -

- (void)drawRoute:(NSArray *)arrRoutePoints onTheMapView:(MKMapView *)mapView {
    
    NSUInteger numPoints = [arrRoutePoints count];
    if (numPoints > 1) {
        CLLocationCoordinate2D* coords = malloc(numPoints * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < numPoints; i++) {
            CLLocation* current = arrRoutePoints[i];
            coords[i] = current.coordinate;
        }
        
        self.objPolyline = [MKPolyline polylineWithCoordinates:coords count:numPoints];
        free(coords);
        
        [mapView addOverlay:objPolyline];
        [mapView setNeedsDisplay];
    }
}

- (void)centerMap:(MKMapView *)mapView forRoutePoints:(NSArray *)arrRoutePoints {
    
    if (arrRoutePoints != nil) {
        if (arrRoutePoints.count > 0) {
            MKCoordinateRegion region;
            
            CLLocationDegrees maxLat = -90;
            CLLocationDegrees maxLon = -180;
            CLLocationDegrees minLat = 90;
            CLLocationDegrees minLon = 180;
            
            for(int idx = 0; idx < arrRoutePoints.count; idx++)
            {
                CLLocation* currentLocation = arrRoutePoints[idx];
                
                if(currentLocation.coordinate.latitude > maxLat)    maxLat = currentLocation.coordinate.latitude;
                if(currentLocation.coordinate.latitude < minLat)    minLat = currentLocation.coordinate.latitude;
                if(currentLocation.coordinate.longitude > maxLon)   maxLon = currentLocation.coordinate.longitude;
                if(currentLocation.coordinate.longitude < minLon)   minLon = currentLocation.coordinate.longitude;
            }
            
            region.center.latitude     = (maxLat + minLat) / 2;
            region.center.longitude    = (maxLon + minLon) / 2;
            region.span.latitudeDelta  = maxLat - minLat;
            region.span.longitudeDelta = maxLon - minLon;
            
            
            [mapView setRegion:[mapView regionThatFits:region] animated:YES];
        }
    }

}

@end

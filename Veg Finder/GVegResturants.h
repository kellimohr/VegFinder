//
//  GVegResturants.h
//  Veg Finder
//
//  Created by Kelli Mohr on 5/3/14.
//  Copyright (c) 2014 Kelli Mohr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GVegResturants : MKPinAnnotationView <MKAnnotation>

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end

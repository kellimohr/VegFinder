//
//  GVegResturants.m
//  Veg Finder
//
//  Created by Kelli Mohr on 5/3/14.
//  Copyright (c) 2014 Kelli Mohr. All rights reserved.
//

#import "GVegResturants.h"
#import <AddressBook/AddressBook.h>

@interface GVegResturants ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;

@end

@implementation GVegResturants

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        if ([name isKindOfClass:[NSString class]]) {
            self.name = name;
        } else {
            self.name = @"Unknown";
        }
        self.address = address;
        self.theCoordinate = coordinate;
    }
    
    NSLog(@"Name: %@", name);
    NSLog(@"Address: %@", address);
    NSLog(@"Latitude: %f", coordinate.latitude);
    NSLog(@"Longitude: %f", coordinate.longitude);
    
    return self;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return _address;
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (MKMapItem*)mapItem {
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end

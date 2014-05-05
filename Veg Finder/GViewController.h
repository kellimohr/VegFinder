//
//  GViewController.h
//  Veg Finder
//
//  Created by Kelli Mohr on 5/3/14.
//  Copyright (c) 2014 Kelli Mohr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/Mapkit.h>
#import <CoreLocation/CoreLocation.h>

#define kGOOGLE_API_KEY @"AIzaSyBScwhO87M7lLo65vEZ07Fz2fjcnY2oh04"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface GViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;
    int radius;
}

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
- (IBAction)search:(id)sender;
- (IBAction)changeMapType:(id)sender;

@end

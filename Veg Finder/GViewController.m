//
//  GViewController.m
//  Veg Finder
//
//  Created by Kelli Mohr on 5/3/14.
//  Copyright (c) 2014 Kelli Mohr. All rights reserved.
//

#import "GViewController.h"
#import "GVegResturants.h"

@interface GViewController ()

@end

@implementation GViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mapView.delegate = self;
    

    locationManager = [[CLLocationManager alloc] init];
    
    [locationManager setDelegate:self];
    
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //Check if loaction services are disabled, if so send alert to user.
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted  )
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                          message:@"Locations Services are currently disabled.  Turn on location services in settings."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
    else{
        _mapView.showsUserLocation = YES;
        
        MKUserLocation *userLocation = _mapView.userLocation;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 5000, 5000);
        [_mapView setRegion:region animated:YES];
    }
}

- (IBAction)search:(id)sender {
    
    [self queryGooglePlaces:@"restaurant"];
}

- (IBAction)changeMapType:(id)sender {
    if (_mapView.mapType == MKMapTypeStandard)
        _mapView.mapType = MKMapTypeSatellite;
    else
        _mapView.mapType = MKMapTypeStandard;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate =
    userLocation.location.coordinate;
}


-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //Get the east and west points on the map to calculate the dzoom level of the current map view.
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //Set the current distance instance variable.
    radius = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    //Set the user's current center point on the map instance variable.
    currentCentre = self.mapView.centerCoordinate;
}

#pragma mark - queryGooglePlaces
-(void) queryGooglePlaces: (NSString *) googleType {
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&keyword=vegetarian&sensor=true&key=%@", currentCentre.latitude, currentCentre.longitude, [NSString stringWithFormat:@"%i", radius], googleType, kGOOGLE_API_KEY];
    
    NSURL *googleRequestURL=[NSURL URLWithString:url];

    [NSURLConnection sendAsynchronousRequest: [NSURLRequest requestWithURL: googleRequestURL]
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^( NSURLResponse *response, NSData *data, NSError *error ) {
                               
                               NSDictionary* json = [NSJSONSerialization
                                                     JSONObjectWithData:data
                                                     options:kNilOptions
                                                     error:&error];
                               
                               
                               NSArray* places = [json objectForKey:@"results"];
                               [self plotPositions:places];

                           }];
}

-(void)plotPositions:(NSArray *)data {
    
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        if ([annotation isKindOfClass:[GVegResturants class]]) {
            [_mapView removeAnnotation:annotation];
        }
    }
    
    for (int i=0; i<[data count]; i++) {
        
        NSDictionary* place = [data objectAtIndex:i];
        
        NSDictionary *geo = [place objectForKey:@"geometry"];
        
        NSDictionary *loc = [geo objectForKey:@"location"];
        
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];
        
        CLLocationCoordinate2D placeCoord;
        
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        GVegResturants *placeObject = [[GVegResturants alloc] initWithName:name address:vicinity coordinate:placeCoord];
        NSLog(@"Get ready to add google anotations!");
        [_mapView addAnnotation:placeObject];
        [_mapView showAnnotations: _mapView.annotations animated: YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

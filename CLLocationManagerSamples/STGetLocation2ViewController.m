//
//  STGetLocation2ViewController.m
//  CLLocationManagerSamples
//
//  Created by EIMEI on 2013/08/05.
//  Copyright (c) 2013 stack3. All rights reserved.
//

#import "STGetLocation2ViewController.h"
#import <MapKit/MapKit.h>

@implementation STGetLocation2ViewController {
    IBOutlet __weak MKMapView *_mapView;
    IBOutlet __weak UIButton *_getLocationButton;
    __strong CLLocationManager *_locationManager;
    __strong NSDate *_startUpdatingLocationAt;
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = @"Get Location 2";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    [_getLocationButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_getLocationButton addTarget:self action:@selector(didTapGetLocationButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    _locationManager.delegate = nil;
    _locationManager = nil;
}

- (void)didTapGetLocationButton
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (!((status == kCLAuthorizationStatusNotDetermined) ||
          (status == kCLAuthorizationStatusAuthorized))) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:NSLocalizedString(@"Alert Location Service Disabled", nil)
                                   delegate:nil
                          cancelButtonTitle:nil
                            otherButtonTitles:@"OK", nil] show];
        return;
    }

    [_locationManager startUpdatingLocation];
    
    _getLocationButton.enabled = NO;
    _startUpdatingLocationAt = [NSDate date];
    
    NSLog(@"Start updating location. timestamp:%@", [[NSDate date] description]);
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *recentLocation = locations.lastObject;
    if (recentLocation.timestamp.timeIntervalSince1970 < _startUpdatingLocationAt.timeIntervalSince1970) {
        // Ignore old location.
        return;
    }

    [_locationManager stopUpdatingLocation];
    
    _getLocationButton.enabled = YES;
    
    [_mapView setCenterCoordinate:recentLocation.coordinate animated:YES];
    
    MKPointAnnotation *mapAnnotation = [[MKPointAnnotation alloc] init];
    mapAnnotation.coordinate = recentLocation.coordinate;
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotation:mapAnnotation];
    
    NSLog(@"Updated location:%f %f timestamp:%@", recentLocation.coordinate.latitude, recentLocation.coordinate.longitude, recentLocation.timestamp.description);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [_locationManager stopUpdatingLocation];
    
    _getLocationButton.enabled = YES;
}

@end

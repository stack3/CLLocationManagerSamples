//
//  STNavigateLocationViewController.m
//  CLLocationManagerSamples
//
//  Created by EIMEI on 2013/08/05.
//  Copyright (c) 2013 stack3. All rights reserved.
//

#import "STNavigateLocationViewController.h"

@implementation STNavigateLocationViewController {
    IBOutlet __weak MKMapView *_mapView;
    IBOutlet __weak UILabel *_errorLabel;
    __strong CLLocationManager *_locationManager;
    __strong NSDate *_startUpdatingLocationAt;
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = @"Navigate Location";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _errorLabel.textColor = [UIColor whiteColor];
    _errorLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _errorLabel.text = nil;
    _errorLabel.hidden = YES;
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
 
    [_locationManager stopUpdatingLocation]; // Just in case.
    _locationManager.delegate = nil;
    _locationManager = nil;
}
- (void)viewDidAppear:(BOOL)animated
{
    [_locationManager startUpdatingLocation];
    _startUpdatingLocationAt = [NSDate date];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_locationManager stopUpdatingLocation];
    _startUpdatingLocationAt = nil;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *recentLocation = locations.lastObject;
    if (recentLocation.timestamp.timeIntervalSince1970 < _startUpdatingLocationAt.timeIntervalSince1970) {
        // Ignore old location.
        return;
    }
    
    [_mapView setCenterCoordinate:recentLocation.coordinate animated:YES];
    
    MKPointAnnotation *mapAnnotation = [[MKPointAnnotation alloc] init];
    mapAnnotation.coordinate = recentLocation.coordinate;
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotation:mapAnnotation];
 
    _errorLabel.text = nil;
    _errorLabel.hidden = YES;
    
    NSLog(@"Updated location:%f %f timestamp:%@", recentLocation.coordinate.latitude, recentLocation.coordinate.longitude, recentLocation.timestamp.description);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorized) {
        _errorLabel.text = NSLocalizedString(@"Failed to get your location.", nil);
    } else {
        _errorLabel.text = NSLocalizedString(@"Alert Location Service Disabled", nil);
    }
    _errorLabel.hidden = NO;
}

@end

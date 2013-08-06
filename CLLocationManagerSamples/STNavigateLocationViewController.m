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
    __strong MKPointAnnotation *_mapAnnotation;
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = @"Navigate Location";
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.332331, -122.031219), MKCoordinateSpanMake(0.01, 0.01));
    
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
    [self updateErrorLabelWithIgnoreAuthorized:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleApplicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_locationManager stopUpdatingLocation];
    _startUpdatingLocationAt = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateErrorLabelWithIgnoreAuthorized:(BOOL)isIgnoreAuthorized
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (isIgnoreAuthorized && (status == kCLAuthorizationStatusAuthorized)) {
        return;
    }
    
    if (status == kCLAuthorizationStatusAuthorized) {
        _errorLabel.text = NSLocalizedString(@"Failed to get your location.", nil);
    } else {
        _errorLabel.text = NSLocalizedString(@"Alert Location Service Disabled", nil);
    }
    _errorLabel.hidden = NO;
    
    if (_mapAnnotation) {
        [_mapView removeAnnotation:_mapAnnotation];
        _mapAnnotation = nil;
    }
}

#pragma mark - NSNotification

- (void)handleApplicationDidBecomeActive:(NSNotification *)notitication
{
    [self updateErrorLabelWithIgnoreAuthorized:YES];
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
    
    if (_mapAnnotation == nil) {
        _mapAnnotation = [[MKPointAnnotation alloc] init];
        [_mapView addAnnotation:_mapAnnotation];
    }
    _mapAnnotation.coordinate = recentLocation.coordinate;
 
    _errorLabel.text = nil;
    _errorLabel.hidden = YES;
    
    NSLog(@"Updated location:%f %f timestamp:%@", recentLocation.coordinate.latitude, recentLocation.coordinate.longitude, recentLocation.timestamp.description);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self updateErrorLabelWithIgnoreAuthorized:NO];
}

@end

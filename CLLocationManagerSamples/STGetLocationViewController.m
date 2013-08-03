//
//  STGetLocationViewController.m
//  CLLocationSamples
//
//  Created by MIYAMOTO, Hideaki on 2013/08/01.
//  Copyright (c) 2013年 stack3. All rights reserved.
//

#import "STGetLocationViewController.h"

@implementation STGetLocationViewController {
    IBOutlet __weak UITextField *_latitudeField;
    IBOutlet __weak UITextField *_longitudeField;
    IBOutlet __weak UIButton *_startButton;
    IBOutlet __weak UIButton *_stopButton;
    __strong CLLocationManager *_locationManager;
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = @"Get Location";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    [_startButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_startButton addTarget:self action:@selector(didTapStartButton) forControlEvents:UIControlEventTouchUpInside];
    
    [_stopButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_stopButton addTarget:self action:@selector(didTapStopButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    _locationManager.delegate = nil;
    _locationManager = nil;
}

- (void)didTapStartButton
{
    [_locationManager startUpdatingLocation];
    
    _startButton.enabled = NO;
    _stopButton.enabled = YES;
    NSLog(@"start updating location. timestamp:%@", [[NSDate date] description]);
}

- (void)didTapStopButton
{
    [_locationManager stopUpdatingLocation];
    _startButton.enabled = YES;
    _stopButton.enabled = NO;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *recentLocation = locations.lastObject;
    _latitudeField.text = [NSString stringWithFormat:@"%f", recentLocation.coordinate.latitude];
    _longitudeField.text = [NSString stringWithFormat:@"%f", recentLocation.coordinate.longitude];
    NSLog(@"location:%f %f timestamp:%@", recentLocation.coordinate.latitude, recentLocation.coordinate.longitude, recentLocation.timestamp.description);
    NSLog(@"count:%d", locations.count);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    _latitudeField.text = @"---";
    _longitudeField.text = @"---";
}

@end

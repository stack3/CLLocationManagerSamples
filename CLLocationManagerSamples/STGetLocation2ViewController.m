//
//  STGetLocation2ViewController.m
//  CLLocationManagerSamples
//
//  Created by MIYAMOTO, Hideaki on 2013/08/05.
//  Copyright (c) 2013年 stack3. All rights reserved.
//

#import "STGetLocation2ViewController.h"

@implementation STGetLocation2ViewController {
    IBOutlet __weak UILabel *_statusLabel;
    IBOutlet __weak UITextField *_latitudeField;
    IBOutlet __weak UITextField *_longitudeField;
    IBOutlet __weak UIButton *_startButton;
    IBOutlet __weak UIButton *_stopButton;
    __strong CLLocationManager *_locationManager;
    __strong NSDate *_startUpdatingLocationAt;
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
    _stopButton.enabled = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    _locationManager.delegate = nil;
    _locationManager = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateStatus];
}

- (void)updateStatus
{
    if ([CLLocationManager locationServicesEnabled]) {
        _statusLabel.text = @"Location Service is Enabled.";
    } else {
        _statusLabel.text = @"Location Service is Disabled.";
    }
}

- (void)didTapStartButton
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (!((status == kCLAuthorizationStatusNotDetermined) ||
          (status == kCLAuthorizationStatusAuthorized))) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"iOSの設定 > プライバシー > 位置情報サービスから、本アプリの位置情報の利用を許可してください"
                                   delegate:nil
                          cancelButtonTitle:nil
                            otherButtonTitles:@"OK", nil] show];
        return;
    }

    //
    // If the status was kCLAuthorizationStatusNotDetermined, the alert that is location service setting will be opened.
    //
    [_locationManager startUpdatingLocation];
    
    _startButton.enabled = NO;
    _stopButton.enabled = YES;
    _startUpdatingLocationAt = [NSDate date];
    
    NSLog(@"Start updating location. timestamp:%@", [[NSDate date] description]);
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
    if (recentLocation.timestamp.timeIntervalSince1970 < _startUpdatingLocationAt.timeIntervalSince1970) {
        // Ignore old location.
        return;
    }
    
    _latitudeField.text = [NSString stringWithFormat:@"%f", recentLocation.coordinate.latitude];
    _longitudeField.text = [NSString stringWithFormat:@"%f", recentLocation.coordinate.longitude];
    
    NSLog(@"Updated location:%f %f timestamp:%@", recentLocation.coordinate.latitude, recentLocation.coordinate.longitude, recentLocation.timestamp.description);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    _latitudeField.text = @"---";
    _longitudeField.text = @"---";
    _startButton.enabled = YES;
    _stopButton.enabled = NO;
}

#pragma mark - NSNotification

- (void)handleApplicationDidBecomeActiveNotification:(NSNotification *)notification
{
    [self updateStatus];
}

@end

//
//  AdvertisingViewController.m
//  BLE-Demo
//
//  Created by Joseph Lin on 4/19/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import "AdvertisingViewController.h"
#import "BLEManager.h"


@interface AdvertisingViewController ()
@end


@implementation AdvertisingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)startButtonTapped:(id)sender
{
    [[BLEManager sharedInstance] startAdvertising];
}

- (IBAction)stopButtonTapped:(id)sender
{
    [[BLEManager sharedInstance] stopAdvertising];
}

@end

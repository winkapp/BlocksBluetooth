//
//  CBPeripheral+Debug.m
//  BLE-Demo
//
//  Created by Joseph Lin on 4/22/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import "CBPeripheral+Debug.h"


@implementation CBPeripheral (Debug)

- (NSString *)stateString
{
    switch (self.state) {
        case CBPeripheralStateDisconnected:
            return @"Disconnected";
            
        case CBPeripheralStateConnecting:
            return @"Connecting";

        case CBPeripheralStateConnected:
            return @"Connected";
            
        default:
            return nil;
    }
}

@end

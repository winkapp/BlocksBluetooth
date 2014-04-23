//
//  CBPeripheralManager+Debug.m
//  BLE-Demo
//
//  Created by Joseph Lin on 4/19/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import "CBPeripheralManager+Debug.h"


@implementation CBPeripheralManager (Debug)

- (NSString *)stateString
{
    switch (self.state) {
        case CBPeripheralManagerStateUnknown:
            return @"Unknown";

        case CBPeripheralManagerStateResetting:
            return @"Resetting";
            
        case CBPeripheralManagerStateUnsupported:
            return @"Unsupported";
            
        case CBPeripheralManagerStateUnauthorized:
            return @"Unauthorized";
            
        case CBPeripheralManagerStatePoweredOff:
            return @"PoweredOff";
            
        case CBPeripheralManagerStatePoweredOn:
            return @"PoweredOn";
            
        default:
            return nil;
    }
}

@end

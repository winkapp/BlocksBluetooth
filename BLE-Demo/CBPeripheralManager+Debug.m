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
            return @"CBPeripheralManagerStateUnknown";

        case CBPeripheralManagerStateResetting:
            return @"CBPeripheralManagerStateResetting";
            
        case CBPeripheralManagerStateUnsupported:
            return @"CBPeripheralManagerStateUnsupported";
            
        case CBPeripheralManagerStateUnauthorized:
            return @"CBPeripheralManagerStateUnauthorized";
            
        case CBPeripheralManagerStatePoweredOff:
            return @"CBPeripheralManagerStatePoweredOff";
            
        case CBPeripheralManagerStatePoweredOn:
            return @"CBPeripheralManagerStatePoweredOn";
            
        default:
            return nil;
    }
}

@end

//
//  CBCentralManager+Debug.m
//  BLE-Demo
//
//  Created by Joseph Lin on 4/19/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import "CBCentralManager+Debug.h"


@implementation CBCentralManager (Debug)

- (NSString *)stateString
{
    switch (self.state) {
        case CBCentralManagerStateUnknown:
            return @"CBCentralManagerStateUnknown";
            
        case CBCentralManagerStateResetting:
            return @"CBCentralManagerStateResetting";
            
        case CBCentralManagerStateUnsupported:
            return @"CBCentralManagerStateUnsupported";
            
        case CBCentralManagerStateUnauthorized:
            return @"CBCentralManagerStateUnauthorized";
            
        case CBCentralManagerStatePoweredOff:
            return @"CBCentralManagerStatePoweredOff";
            
        case CBCentralManagerStatePoweredOn:
            return @"CBCentralManagerStatePoweredOn";
            
        default:
            return nil;
    }
}

@end

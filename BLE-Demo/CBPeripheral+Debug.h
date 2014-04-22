//
//  CBPeripheral+Debug.h
//  BLE-Demo
//
//  Created by Joseph Lin on 4/22/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>


@interface CBPeripheral (Debug)

- (NSString *)stateString;

@end

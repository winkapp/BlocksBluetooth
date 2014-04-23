//
//  CBCharacteristic+Debug.h
//  BLE-Demo
//
//  Created by Joseph Lin on 4/22/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>


@interface CBCharacteristic (Debug)

@property (nonatomic, copy, readonly) NSString *propertiesString;

@end

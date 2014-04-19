//
//  BLEManager.h
//  BLE-Demo
//
//  Created by Joseph Lin on 4/19/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

extern NSString * const BLEDidDiscoverPeripheralNotification;
extern NSString * const BLEDidConnectPeripheralNotification;
extern NSString * const BLEDidDiscoverServicesNotification;
extern NSString * const BLEDidDiscoverCharacteristicsNotification;


@interface BLEManager : NSObject

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) NSMutableArray *peripherals;
@property (nonatomic, getter = isScanning) BOOL scanning;

+ (instancetype)sharedInstance;
- (void)startScan;
- (void)stopScan;

@end

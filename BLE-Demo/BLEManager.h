//
//  BLEManager.h
//  BLE-Demo
//
//  Created by Joseph Lin on 4/19/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

// Central Notifications
extern NSString * const BLEDidDiscoverPeripheralNotification;
extern NSString * const BLEDidConnectPeripheralNotification;
extern NSString * const BLEDidDiscoverServicesNotification;
extern NSString * const BLEDidDiscoverCharacteristicsNotification;
extern NSString * const BLEDidDiscoverDescriptorsNotification;

// Peripheral Notifications
extern NSString * const BLEDidStartAdvertisingNotification;



@interface BLEManager : NSObject

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, getter = isScanning) BOOL scanning;

+ (instancetype)sharedInstance;
- (void)startAdvertising;
- (void)stopAdvertising;
- (void)startScan;
- (void)stopScan;

@end

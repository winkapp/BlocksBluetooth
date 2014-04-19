//
//  BLEManager.m
//  BLE-Demo
//
//  Created by Joseph Lin on 4/19/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import "BLEManager.h"
#import "CBCentralManager+Debug.h"

NSString * const BLEDidDiscoverPeripheralNotification = @"BLEDidDiscoverPeripheralNotification";
NSString * const BLEDidConnectPeripheralNotification = @"BLEDidConnectPeripheralNotification";
NSString * const BLEDidDiscoverServicesNotification = @"BLEDidDiscoverServicesNotification";
NSString * const BLEDidDiscoverCharacteristicsNotification = @"BLEDidDiscoverCharacteristicsNotification";


@interface BLEManager () <CBCentralManagerDelegate, CBPeripheralDelegate>
@end


@implementation BLEManager

+ (instancetype)sharedInstance
{
    static BLEManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [BLEManager new];
    });
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    self.peripherals = [NSMutableArray new];
    return self;
}


#pragma mark - Control

- (void)startScan
{
    if (!self.isScanning) {
        self.scanning = YES;
        [self.peripherals removeAllObjects];
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
}

- (void)stopScan
{
    if (self.isScanning) {
        [self.centralManager stopScan];
        self.scanning = NO;
    }
}


#pragma mark - Central Manager Delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"centralManagerDidUpdateState: %@", central.stateString);
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discovered %@", peripheral);
    [self.peripherals addObject:peripheral];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BLEDidDiscoverPeripheralNotification object:peripheral];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral connected");
    
    peripheral.delegate = self;
    [[NSNotificationCenter defaultCenter] postNotificationName:BLEDidConnectPeripheralNotification object:peripheral];

    [peripheral discoverServices:nil];
}


#pragma mark - Peripheral Delegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BLEDidDiscoverServicesNotification object:peripheral];

    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service %@", service);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BLEDidDiscoverCharacteristicsNotification object:service];

    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"Discovered characteristic %@", characteristic);
    }
}

@end

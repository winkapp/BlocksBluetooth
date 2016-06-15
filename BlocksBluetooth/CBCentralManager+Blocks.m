//
//  CBCentralManager+Blocks.m
//  BLE-Demo
//
//  Created by Joseph Lin on 4/22/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import "CBCentralManager+Blocks.h"
#import <objc/runtime.h>
#import "CBCentralManager+Debug.h"


#pragma mark - CBCentralManager Private Properties

@interface CBCentralManager (_Blocks)
@property (nonatomic, copy) BBPeripheralDiscoverBlock didDiscoverPeripheral;
@end


@implementation CBCentralManager (_Blocks)

- (BBPeripheralDiscoverBlock)didDiscoverPeripheral
{
    return (BBPeripheralDiscoverBlock)objc_getAssociatedObject(self, @selector(didDiscoverPeripheral));
}

- (void)setDidDiscoverPeripheral:(BBPeripheralDiscoverBlock)didDiscoverPeripheral
{
    objc_setAssociatedObject(self, @selector(didDiscoverPeripheral), didDiscoverPeripheral, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end



#pragma mark - CBCentralManager

@implementation CBCentralManager (Blocks)

- (BBVoidBlock)didUpdateState
{
    return (BBVoidBlock)objc_getAssociatedObject(self, @selector(didUpdateState));
}

- (void)setDidUpdateState:(BBVoidBlock)didUpdateState
{
    objc_setAssociatedObject(self, @selector(didUpdateState), didUpdateState, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


#pragma mark - Initializing a Central Manager

+ (instancetype)defaultManager
{
    static CBCentralManager *_defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [[CBCentralManager alloc] initWithQueue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@NO}];
    });
    return _defaultManager;
}

- (id)initWithQueue:(dispatch_queue_t)queue
{
    self = [self initWithDelegate:self queue:queue];
    return self;
}

- (id)initWithQueue:(dispatch_queue_t)queue options:(NSDictionary *)options NS_AVAILABLE(NA, 7_0)
{
    self = [self initWithDelegate:self queue:queue options:options];
    return self;
}


#pragma mark - Scanning or Stopping Scans of Peripherals

- (void)scanForPeripheralsWithServices:(NSArray *)serviceUUIDs options:(NSDictionary *)options didDiscover:(BBPeripheralDiscoverBlock)didDiscover
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    self.didDiscoverPeripheral = didDiscover;
    [self scanForPeripheralsWithServices:serviceUUIDs options:options];
}

- (void)stopScanAndRemoveHandler
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    [self stopScan];
    self.didDiscoverPeripheral = nil;
}


#pragma mark - Establishing or Canceling Connections with Peripherals

- (void)connectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary *)options didConnect:(BBPeripheralBlock)didConnect didDisconnect:(BBPeripheralBlock)didDisconnect
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    peripheral.didConnect = didConnect;
    peripheral.didDisconnect = didDisconnect;
    [self connectPeripheral:peripheral options:options];
}

- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral didDisconnect:(BBPeripheralBlock)didDisconnect
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    peripheral.didDisconnect = didDisconnect;
    [self cancelPeripheralConnection:peripheral];
}


#pragma mark - Central Manager Delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"centralManagerDidUpdateState: %@", central.stateString);
    if (self.didUpdateState) {
        self.didUpdateState();
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discovered %@", peripheral);
    if (self.didDiscoverPeripheral) {
        self.didDiscoverPeripheral(peripheral, advertisementData, RSSI);
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral connected: %@", peripheral);
    if (peripheral.didConnect) {
        peripheral.didConnect(peripheral, nil);
        peripheral.didConnect = nil;
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"didFailToConnectPeripheral: %@", error);
    if (peripheral.didConnect) {
        peripheral.didConnect(nil, error);
        peripheral.didConnect = nil;
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"didDisconnectPeripheral: %@, %@", peripheral, error);
    if (peripheral.didDisconnect) {
        peripheral.didDisconnect(peripheral, error);
        peripheral.didDisconnect = nil;
    }
}

@end

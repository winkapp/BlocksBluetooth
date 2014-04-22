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


#pragma mark - CBPeripheral Private Properties

@interface CBPeripheral (_Blocks)
@property (nonatomic, copy) CBPeripheralBlock didConnect;
@property (nonatomic, copy) CBPeripheralBlock didDisconnect;
@end


@implementation CBPeripheral (_Blocks)

- (CBPeripheralBlock)didConnect
{
    return (CBPeripheralBlock)objc_getAssociatedObject(self, @selector(didConnect));
}

- (void)setDidConnect:(CBPeripheralBlock)didConnect
{
    objc_setAssociatedObject(self, @selector(didConnect), didConnect, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CBPeripheralBlock)didDisconnect
{
    return (CBPeripheralBlock)objc_getAssociatedObject(self, @selector(didDisconnect));
}

- (void)setDidDisconnect:(CBPeripheralBlock)didDisconnect
{
    objc_setAssociatedObject(self, @selector(didDisconnect), didDisconnect, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end



#pragma mark - CBCentralManager Private Properties

@interface CBCentralManager (_Blocks)
@property (nonatomic, copy) CBPeripheralDiscoverBlock didDiscoverPeripheral;
@property (nonatomic, copy) CBPeripheralArrayBlock didRetrievePeripherals;
@property (nonatomic, copy) CBPeripheralArrayBlock didRetrieveConnectedPeripherals;
@end


@implementation CBCentralManager (_Blocks)

- (CBPeripheralDiscoverBlock)didDiscoverPeripheral
{
    return (CBPeripheralDiscoverBlock)objc_getAssociatedObject(self, @selector(didDiscoverPeripheral));
}

- (void)setDidDiscoverPeripheral:(CBPeripheralDiscoverBlock)didDiscoverPeripheral
{
    objc_setAssociatedObject(self, @selector(didDiscoverPeripheral), didDiscoverPeripheral, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CBPeripheralArrayBlock)didRetrievePeripherals
{
    return (CBPeripheralArrayBlock)objc_getAssociatedObject(self, @selector(didRetrievePeripherals));
}

- (void)setDidRetrievePeripherals:(CBPeripheralArrayBlock)didRetrievePeripherals
{
    objc_setAssociatedObject(self, @selector(didRetrievePeripherals), didRetrievePeripherals, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CBPeripheralArrayBlock)didRetrieveConnectedPeripherals
{
    return (CBPeripheralArrayBlock)objc_getAssociatedObject(self, @selector(didRetrieveConnectedPeripherals));
}

- (void)setDidRetrieveConnectedPeripherals:(CBPeripheralArrayBlock)didRetrieveConnectedPeripherals
{
    objc_setAssociatedObject(self, @selector(didRetrieveConnectedPeripherals), didRetrieveConnectedPeripherals, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end



#pragma mark - CBCentralManager

@implementation CBCentralManager (Blocks)

+ (instancetype)defaultManager
{
    static CBCentralManager *_defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [[CBCentralManager alloc] initWithQueue:nil];
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

- (void)scanForPeripheralsWithServices:(NSArray *)serviceUUIDs options:(NSDictionary *)options didDiscover:(CBPeripheralDiscoverBlock)didDiscover
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


#pragma mark - Retrieving Lists of Peripherals

- (NSArray *)retrievePeripheralsWithIdentifiers:(NSArray *)identifiers didRetrieve:(CBPeripheralArrayBlock)didRetrieve
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    self.didRetrievePeripherals = didRetrieve;
    NSArray *peripherals = [self retrievePeripheralsWithIdentifiers:identifiers];
    return peripherals;
}

- (NSArray *)retrieveConnectedPeripheralsWithServices:(NSArray *)serviceUUIDs didRetrieve:(CBPeripheralArrayBlock)didRetrieve
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    self.didRetrieveConnectedPeripherals = didRetrieve;
    NSArray *peripherals = [self retrieveConnectedPeripheralsWithServices:serviceUUIDs];
    return peripherals;
}


#pragma mark - Establishing or Canceling Connections with Peripherals

- (void)connectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary *)options didConnect:(CBPeripheralBlock)didConnect
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    peripheral.didConnect = didConnect;
    [self connectPeripheral:peripheral options:options];
}

- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral didDisconnect:(CBPeripheralBlock)didDisconnect
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
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discovered %@", peripheral);
    if (self.didDiscoverPeripheral) {
        self.didDiscoverPeripheral(peripheral, advertisementData, RSSI);
    }
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"didRetrievePeripherals: %@", peripherals);
    if (self.didRetrievePeripherals) {
        self.didRetrievePeripherals(peripherals);
        self.didRetrievePeripherals = nil;
    }
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    NSLog(@"didRetrieveConnectedPeripherals: %@", peripherals);
    if (self.didRetrieveConnectedPeripherals) {
        self.didRetrieveConnectedPeripherals(peripherals);
        self.didRetrieveConnectedPeripherals = nil;
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

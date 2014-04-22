//
//  BLEManager.m
//  BLE-Demo
//
//  Created by Joseph Lin on 4/19/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import "BLEManager.h"
#import "CBCentralManager+Debug.h"
#import "CBPeripheralManager+Debug.h"

NSString * const BLEDidDiscoverPeripheralNotification      = @"BLEDidDiscoverPeripheralNotification";
NSString * const BLEDidConnectPeripheralNotification       = @"BLEDidConnectPeripheralNotification";
NSString * const BLEDidDiscoverServicesNotification        = @"BLEDidDiscoverServicesNotification";
NSString * const BLEDidDiscoverCharacteristicsNotification = @"BLEDidDiscoverCharacteristicsNotification";
NSString * const BLEDidStartAdvertisingNotification        = @"BLEDidStartAdvertisingNotification";
NSString * const BLEDidDiscoverDescriptorsNotification     = @"BLEDidDiscoverDescriptorsNotification";

static NSString * const BLEDemoServiceUUID       = @"7846ED88-7CD9-495F-AC2A-D34D245C9FB6";
static NSString * const BLEDemoCharateristicUUID = @"B97E791B-F1A3-486C-9AF4-4DA083BB9539";


@interface BLEManager () <CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate>
@property (nonatomic, strong) CBService *demoService;
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
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    return self;
}

#pragma mark - Peripheral Commands

- (void)startAdvertising
{
    CBUUID *demoCharateristicUUID = [CBUUID UUIDWithString:BLEDemoCharateristicUUID];
    CBMutableCharacteristic *characteristic = [[CBMutableCharacteristic alloc] initWithType:demoCharateristicUUID
                                                                                 properties:CBCharacteristicPropertyRead
                                                                                      value:nil
                                                                                permissions:CBAttributePermissionsReadable];

    CBUUID *demoServiceUUID = [CBUUID UUIDWithString:BLEDemoServiceUUID];
    CBMutableService *service = [[CBMutableService alloc] initWithType:demoServiceUUID primary:YES];
    service.characteristics = @[characteristic];

    [self.peripheralManager addService:service];
    self.demoService = service;
}

- (void)stopAdvertising
{
    [self.peripheralManager stopAdvertising];
}

#pragma mark - Peripheral Manager Delegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"peripheralManagerDidUpdateState: %@", peripheral.stateString);
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"Error publishing service: %@", [error localizedDescription]);
        return;
    }
    
    NSLog(@"peripheralManagerDidAddService: %@", service);

    [self.peripheralManager startAdvertising:@{
                                               CBAdvertisementDataServiceUUIDsKey : @[service.UUID],
                                               CBAdvertisementDataLocalNameKey : @"BLE Demo",
                                               }];
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    if (error) {
        NSLog(@"Error advertising: %@", [error localizedDescription]);
        return;
    }

    NSLog(@"peripheralManagerDidStartAdvertising: %@", peripheral);
    [[NSNotificationCenter defaultCenter] postNotificationName:BLEDidStartAdvertisingNotification object:peripheral];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request
{
    NSLog(@"peripheralManagerDidReceiveReadRequest: %@", request);

    CBCharacteristic *characteristic = [self.demoService.characteristics firstObject];
    
    if ([request.characteristic.UUID isEqual:characteristic.UUID]) {
        if (request.offset > characteristic.value.length) {
            [self.peripheralManager respondToRequest:request withResult:CBATTErrorInvalidOffset];
            return;
        }
        
        request.value = [characteristic.value subdataWithRange:NSMakeRange(request.offset, characteristic.value.length - request.offset)];
        [self.peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
    }
}


#pragma mark - Central Commands

- (void)startScan
{
    if (!self.isScanning) {
        self.scanning = YES;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:BLEDidDiscoverPeripheralNotification object:peripheral];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral connected");
    
    peripheral.delegate = self;
    [[NSNotificationCenter defaultCenter] postNotificationName:BLEDidConnectPeripheralNotification object:peripheral];

    [peripheral readRSSI];
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"didDisconnectPeripheral: %@, %@", peripheral, error);
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"didFailToConnectPeripheral: %@", error);
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    NSLog(@"didRetrieveConnectedPeripherals: %@", peripherals);
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"didRetrievePeripherals: %@", peripherals);
}



#pragma mark - Peripheral Delegate

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    
}

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
        [peripheral readValueForCharacteristic:characteristic];
        [peripheral discoverDescriptorsForCharacteristic:characteristic];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BLEDidDiscoverDescriptorsNotification object:characteristic];
    
    for (CBDescriptor *descriptor in characteristic.descriptors) {
        NSLog(@"Discovered descriptor %@", descriptor);
        [peripheral readValueForDescriptor:descriptor];
    }
}

@end

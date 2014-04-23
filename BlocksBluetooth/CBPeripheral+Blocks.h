//
//  CBPeripheral+Blocks.h
//  BLE-Demo
//
//  Created by Joseph Lin on 4/22/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

typedef void(^CBPeripheralBlock)(CBPeripheral *peripheral, NSError *error);
typedef void(^CBPeripheralUpdateBlock)(CBPeripheral *peripheral, NSArray *invalidatedServices);

typedef void(^CBServicesBlock)(NSArray *services, NSError *error);

typedef void(^CBCharacteristicBlock)(CBCharacteristic *characteristic, NSError *error);
typedef void(^CBCharacteristicsBlock)(NSArray *characteristics, NSError *error);

typedef void(^CBDescriptorBlock)(CBDescriptor *descriptor, NSError *error);
typedef void(^CBDescriptorsBlock)(NSArray *descriptors, NSError *error);


@interface CBPeripheral (Blocks) <CBPeripheralDelegate>

#pragma mark - Discovering Services
- (void)discoverServices:(NSArray *)serviceUUIDs didDiscover:(CBServicesBlock)didDiscover;
- (void)discoverIncludedServices:(NSArray *)includedServiceUUIDs forService:(CBService *)service didDiscover:(CBServicesBlock)didDiscover;

#pragma mark - Discovering Characteristics and Characteristic Descriptors
- (void)discoverCharacteristics:(NSArray *)characteristicUUIDs forService:(CBService *)service didDiscover:(CBCharacteristicsBlock)didDiscover;
- (void)discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic didDiscover:(CBDescriptorsBlock)didDiscover;

#pragma mark - Reading Characteristic and Characteristic Descriptor Values
- (void)readValueForCharacteristic:(CBCharacteristic *)characteristic didUpdate:(CBCharacteristicBlock)didUpdate;
- (void)readValueForDescriptor:(CBDescriptor *)descriptor didUpdate:(CBDescriptorBlock)didUpdate;

#pragma mark - Writing Characteristic and Characteristic Descriptor Values
- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type didWrite:(CBCharacteristicBlock)didWrite;
- (void)writeValue:(NSData *)data forDescriptor:(CBDescriptor *)descriptor didWrite:(CBDescriptorBlock)didWrite;

#pragma mark - Setting Notifications for a Characteristic’s Value
- (void)setNotifyValue:(BOOL)enabled forCharacteristic:(CBCharacteristic *)characteristic didUpdate:(CBCharacteristicBlock)didUpdate;

#pragma mark - Accessing a Peripheral’s Received Signal Strength Indicator (RSSI) Data
- (void)readRSSIAndOnUpdate:(CBPeripheralBlock)didUpdate;

#pragma mark - Additional CBPeripheralDelegate Methods
- (void)onNameUpdate:(CBPeripheralBlock)didUpdate;
- (void)onServicesModification:(CBPeripheralUpdateBlock)didModify;

@end

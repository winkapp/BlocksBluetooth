//
//  CBPeripheral+Blocks.h
//  BLE-Demo
//
//  Created by Joseph Lin on 4/22/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "BlocksBluetoothDefinitions.h"


@interface CBPeripheral (Blocks) <CBPeripheralDelegate>

#pragma mark - Discovering Services
- (void)discoverServices:(NSArray *)serviceUUIDs didDiscover:(BBServicesBlock)didDiscover;
- (void)discoverIncludedServices:(NSArray *)includedServiceUUIDs forService:(CBService *)service didDiscover:(BBServicesBlock)didDiscover;

#pragma mark - Discovering Characteristics and Characteristic Descriptors
- (void)discoverCharacteristics:(NSArray *)characteristicUUIDs forService:(CBService *)service didDiscover:(BBCharacteristicsBlock)didDiscover;
- (void)discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic didDiscover:(BBDescriptorsBlock)didDiscover;

#pragma mark - Reading Characteristic and Characteristic Descriptor Values
- (void)readValueForCharacteristic:(CBCharacteristic *)characteristic didUpdate:(BBCharacteristicBlock)didUpdate;
- (void)readValueForDescriptor:(CBDescriptor *)descriptor didUpdate:(BBDescriptorBlock)didUpdate;

#pragma mark - Writing Characteristic and Characteristic Descriptor Values
- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type didWrite:(BBCharacteristicBlock)didWrite;
- (void)writeValue:(NSData *)data forDescriptor:(CBDescriptor *)descriptor didWrite:(BBDescriptorBlock)didWrite;

#pragma mark - Setting Notifications for a Characteristic’s Value
- (void)setNotifyValue:(BOOL)enabled forCharacteristic:(CBCharacteristic *)characteristic didUpdate:(BBCharacteristicBlock)didUpdate;

#pragma mark - Accessing a Peripheral’s Received Signal Strength Indicator (RSSI) Data
- (void)readRSSIAndOnUpdate:(BBPeripheralBlock)didUpdate;

#pragma mark - Additional CBPeripheralDelegate Methods
- (void)onNameUpdate:(BBPeripheralBlock)didUpdate;
- (void)onServicesModification:(BBPeripheralUpdateBlock)didModify;

@end

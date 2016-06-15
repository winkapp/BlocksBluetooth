//
//  CBPeripheral+Blocks.h
//  BLE-Demo
//
//  Created by Joseph Lin on 4/22/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "BlocksBluetoothDefinitions.h"

NS_ASSUME_NONNULL_BEGIN


@interface CBPeripheral (Blocks) <CBPeripheralDelegate>

@property (nonatomic, nullable, copy) BBPeripheralBlock didConnect;
@property (nonatomic, nullable, copy) BBPeripheralBlock didDisconnect;

#pragma mark - Discovering Services

/**
 *  Calls <code>discoverServices:</code> and uses <code>didDiscover</code> to handle the <code>peripheral:didDiscoverServices:</code> callbacks.
 *
 *  @param serviceUUIDs A list of <code>CBUUID</code> objects representing the service types to be discovered. If <i>nil</i>,
 *						all services will be discovered, which is considerably slower and not recommended.
 *  @param didDiscover  Called when peripheral:didDiscoverServices: is called. Set to nil afterward.
 */
- (void)discoverServices:(nullable NSArray<CBUUID *> *)serviceUUIDs didDiscover:(nullable BBServicesBlock)didDiscover;

/**
 *  Calls <code>discoverIncludedServices:forService:</code> and uses <code>didDiscover</code> to handle the <code>peripheral:didDiscoverIncludedServicesForService:error:</code> callbacks.
 *
 *  @param includedServiceUUIDs A list of <code>CBUUID</code> objects representing the characteristic types to be discovered. If <i>nil</i>,
 *								all characteristics of <i>service</i> will be discovered, which is considerably slower and not recommended.
 *  @param service              A GATT service.
 *  @param didDiscover          Called when peripheral:didDiscoverIncludedServicesForService:error: is called. Set to nil afterward.
 */
- (void)discoverIncludedServices:(nullable NSArray<CBUUID *> *)includedServiceUUIDs forService:(CBService *)service didDiscover:(nullable BBServicesBlock)didDiscover;


#pragma mark - Discovering Characteristics and Characteristic Descriptors

/**
 *  Calls <code>discoverCharacteristics:forService:didDiscover:</code> and uses <code>didDiscover</code> to handle the <code>peripheral:didDiscoverCharacteristicsForService:error:</code> callbacks.
 *
 *  @param characteristicUUIDs A list of <code>CBUUID</code> objects representing the characteristic types to be discovered. If <i>nil</i>,
 *								all characteristics of <i>service</i> will be discovered, which is considerably slower and not recommended.
 *  @param service             A GATT service.
 *  @param didDiscover         Called when peripheral:didDiscoverCharacteristicsForService:error: is called. Set to nil afterward.
 */
- (void)discoverCharacteristics:(nullable NSArray<CBUUID *> *)characteristicUUIDs forService:(CBService *)service didDiscover:(nullable BBCharacteristicsBlock)didDiscover;

/**
 *  Calls <code>discoverDescriptorsForCharacteristic:</code> and uses <code>didDiscover</code> to handle the <code>peripheral:didDiscoverDescriptorsForCharacteristic:error:</code> callbacks.
 *
 *  @param characteristic A GATT characteristic.
 *  @param didDiscover    Called when peripheral:didDiscoverDescriptorsForCharacteristic:error: is called. Set to nil afterward.
 */
- (void)discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic didDiscover:(nullable BBDescriptorsBlock)didDiscover;


#pragma mark - Reading Characteristic and Characteristic Descriptor Values

/**
 *  Calls <code>readValueForCharacteristic:</code> and uses <code>didUpdate</code> to handle the <code>peripheral:didUpdateValueForCharacteristic:error:</code> callbacks.
 *
 *  @param characteristic A GATT characteristic.
 *  @param didUpdate      Called when peripheral:didUpdateValueForCharacteristic:error: is called. Set to nil afterward.
 */
- (void)readValueForCharacteristic:(CBCharacteristic *)characteristic didUpdate:(nullable BBCharacteristicBlock)didUpdate;

/**
 *  Calls <code>readValueForDescriptor:</code> and uses <code>didUpdate</code> to handle the <code>peripheral:didUpdateValueForDescriptor:error:</code> callbacks.
 *
 *  @param descriptor   A GATT characteristic descriptor.
 *  @param didUpdate    Called when peripheral:didUpdateValueForDescriptor:error: is called. Set to nil afterward.
 */
- (void)readValueForDescriptor:(CBDescriptor *)descriptor didUpdate:(nullable BBDescriptorBlock)didUpdate;


#pragma mark - Writing Characteristic and Characteristic Descriptor Values

/**
 *  Calls <code>writeValue:forCharacteristic:type:</code> and uses <code>didWrite</code> to handle the <code>peripheral:didWriteValueForCharacteristic:error:</code> callbacks.
 *
 *  @param data           The value to write.
 *  @param characteristic The characteristic whose characteristic value will be written.
 *  @param type           The type of write to be executed.
 *  @param didWrite       Called when peripheral:didWriteValueForCharacteristic:error: is called. Set to nil afterward.
 */
- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type didWrite:(nullable BBCharacteristicBlock)didWrite;

/**
 *  Calls <code>writeValue:forDescriptor:</code> and uses <code>didWrite</code> to handle the <code>peripheral:didUpdateValueForDescriptor:error:</code> callbacks.
 *
 *  @param data       The value to write.
 *  @param descriptor A GATT characteristic descriptor.
 *  @param didWrite   Called when peripheral:didUpdateValueForDescriptor:error: is called. Set to nil afterward.
 */
- (void)writeValue:(NSData *)data forDescriptor:(CBDescriptor *)descriptor didWrite:(nullable BBDescriptorBlock)didWrite;


#pragma mark - Setting Notifications for a Characteristic’s Value

/**
 *  Calls <code>setNotifyValue:forCharacteristic:</code> and uses <code>didUpdate</code> to handle the <code>peripheral:didUpdateNotificationStateForCharacteristic:error:</code> callbacks.
 *
 *  @param enabled        Whether or not notifications/indications should be enabled.
 *  @param characteristic The characteristic containing the client characteristic configuration descriptor.
 *  @param didUpdate      Called when peripheral:didUpdateNotificationStateForCharacteristic:error: is called. Set to nil afterward.
 */
- (void)setNotifyValue:(BOOL)enabled forCharacteristic:(CBCharacteristic *)characteristic didUpdate:(nullable BBCharacteristicBlock)didUpdate;


#pragma mark - Accessing a Peripheral’s Received Signal Strength Indicator (RSSI) Data

/**
 *  Calls <code>readRSSI</code> and uses <code>didUpdate</code> to handle the <code>peripheralDidUpdateRSSI:error:</code> callbacks.
 *
 *  @param didUpdate Called when peripheralDidUpdateRSSI:error: is called. Set to nil afterward.
 */
- (void)readRSSIAndOnUpdate:(nullable BBPeripheralBlock)didUpdate;


#pragma mark - Additional CBPeripheralDelegate Methods

/**
 *  Handler for peripheralDidUpdateName:. Does not set to nil automatically.
 *
 *  @param didUpdate Called when peripheralDidUpdateName: is called.
 */
- (void)onNameUpdate:(BBPeripheralBlock)didUpdate;

/**
 *  Handler for peripheral:didModifyServices:. Does not set to nil automatically.
 *
 *  @param didModify Called when peripheral:didModifyServices: is called.
 */
- (void)onServicesModification:(BBPeripheralUpdateBlock)didModify;

@end


NS_ASSUME_NONNULL_END

//
//  CBPeripheral+Blocks.m
//  BLE-Demo
//
//  Created by Joseph Lin on 4/22/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import "CBPeripheral+Blocks.h"
#import <objc/runtime.h>



#pragma mark - CBPeripheral Private Properties

@interface CBPeripheral (_Blocks)
@property (nonatomic, copy) BBServicesBlock didDiscoverServices;
@property (nonatomic, copy) BBPeripheralBlock didUpdateRSSI;
@property (nonatomic, copy) BBPeripheralBlock didUpdateName;
@property (nonatomic, copy) BBPeripheralUpdateBlock didModifyServices;
@end


@implementation CBPeripheral (_Blocks)

- (BBServicesBlock)didDiscoverServices
{
    return (BBServicesBlock)objc_getAssociatedObject(self, @selector(didDiscoverServices));
}

- (void)setDidDiscoverServices:(BBServicesBlock)didDiscoverServices
{
    objc_setAssociatedObject(self, @selector(didDiscoverServices), didDiscoverServices, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BBPeripheralBlock)didUpdateRSSI
{
    return (BBPeripheralBlock)objc_getAssociatedObject(self, @selector(didUpdateRSSI));
}

- (void)setDidUpdateRSSI:(BBPeripheralBlock)didUpdateRSSI
{
    objc_setAssociatedObject(self, @selector(didUpdateRSSI), didUpdateRSSI, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BBPeripheralBlock)didUpdateName
{
    return (BBPeripheralBlock)objc_getAssociatedObject(self, @selector(didUpdateName));
}

- (void)setDidUpdateName:(BBPeripheralBlock)didUpdateName
{
    objc_setAssociatedObject(self, @selector(didUpdateName), didUpdateName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BBPeripheralUpdateBlock)didModifyServices
{
    return (BBPeripheralUpdateBlock)objc_getAssociatedObject(self, @selector(didModifyServices));
}

- (void)setDidModifyServices:(BBPeripheralUpdateBlock)didModifyServices
{
    objc_setAssociatedObject(self, @selector(didModifyServices), didModifyServices, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end



#pragma mark - CBService Private Properties

@interface CBService (_Blocks)
@property (nonatomic, copy) BBServicesBlock didDiscoverIncludedServices;
@property (nonatomic, copy) BBCharacteristicsBlock didDiscoverCharacteristics;
@end


@implementation CBService (_Blocks)

- (BBServicesBlock)didDiscoverIncludedServices
{
    return (BBServicesBlock)objc_getAssociatedObject(self, @selector(didDiscoverIncludedServices));
}

- (void)setDidDiscoverIncludedServices:(BBServicesBlock)didDiscoverIncludedServices
{
    objc_setAssociatedObject(self, @selector(didDiscoverIncludedServices), didDiscoverIncludedServices, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BBCharacteristicsBlock)didDiscoverCharacteristics
{
    return (BBCharacteristicsBlock)objc_getAssociatedObject(self, @selector(didDiscoverCharacteristics));
}

- (void)setDidDiscoverCharacteristics:(BBCharacteristicsBlock)didDiscoverCharacteristics
{
    objc_setAssociatedObject(self, @selector(didDiscoverCharacteristics), didDiscoverCharacteristics, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end



#pragma mark - CBCharacteristic Private Properties

@interface CBCharacteristic (_Blocks)
@property (nonatomic, copy) BBDescriptorsBlock didDiscoverDescriptors;
@property (nonatomic, copy) BBCharacteristicBlock didUpdateValue;
@property (nonatomic, copy) BBCharacteristicBlock didWriteValue;
@property (nonatomic, copy) BBCharacteristicBlock didUpdateNotificationState;
@end


@implementation CBCharacteristic (_Blocks)

- (BBDescriptorsBlock)didDiscoverDescriptors
{
    return (BBDescriptorsBlock)objc_getAssociatedObject(self, @selector(didDiscoverDescriptors));
}

- (void)setDidDiscoverDescriptors:(BBDescriptorsBlock)didDiscoverDescriptors
{
    objc_setAssociatedObject(self, @selector(didDiscoverDescriptors), didDiscoverDescriptors, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BBCharacteristicBlock)didUpdateValue
{
    return (BBCharacteristicBlock)objc_getAssociatedObject(self, @selector(didUpdateValue));
}

- (void)setDidUpdateValue:(BBCharacteristicBlock)didUpdateValue
{
    objc_setAssociatedObject(self, @selector(didUpdateValue), didUpdateValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BBCharacteristicBlock)didWriteValue
{
    return (BBCharacteristicBlock)objc_getAssociatedObject(self, @selector(didWriteValue));
}

- (void)setDidWriteValue:(BBCharacteristicBlock)didWriteValue
{
    objc_setAssociatedObject(self, @selector(didWriteValue), didWriteValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BBCharacteristicBlock)didUpdateNotificationState
{
    return (BBCharacteristicBlock)objc_getAssociatedObject(self, @selector(didUpdateNotificationState));
}

- (void)setDidUpdateNotificationState:(BBCharacteristicBlock)didUpdateNotificationState
{
    objc_setAssociatedObject(self, @selector(didUpdateNotificationState), didUpdateNotificationState, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end



#pragma mark - CBDescriptor Private Properties

@interface CBDescriptor (_Blocks)
@property (nonatomic, copy) BBDescriptorBlock didUpdateValue;
@property (nonatomic, copy) BBDescriptorBlock didWriteValue;

@end


@implementation CBDescriptor (_Blocks)

- (BBDescriptorBlock)didUpdateValue
{
    return (BBDescriptorBlock)objc_getAssociatedObject(self, @selector(didUpdateValue));
}

- (void)setDidUpdateValue:(BBDescriptorBlock)didUpdateValue
{
    objc_setAssociatedObject(self, @selector(didUpdateValue), didUpdateValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BBDescriptorBlock)didWriteValue
{
    return (BBDescriptorBlock)objc_getAssociatedObject(self, @selector(didWriteValue));
}

- (void)setDidWriteValue:(BBDescriptorBlock)didWriteValue
{
    objc_setAssociatedObject(self, @selector(didWriteValue), didWriteValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end



#pragma mark - CBPeripheral

@implementation CBPeripheral (Blocks)


#pragma mark - Discovering Services

- (void)discoverServices:(NSArray *)serviceUUIDs didDiscover:(BBServicesBlock)didDiscover
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    self.didDiscoverServices = didDiscover;
    [self discoverServices:serviceUUIDs];
}

- (void)discoverIncludedServices:(NSArray *)includedServiceUUIDs forService:(CBService *)service didDiscover:(BBServicesBlock)didDiscover
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    service.didDiscoverIncludedServices = didDiscover;
    [self discoverIncludedServices:includedServiceUUIDs forService:service];
}


#pragma mark - Discovering Characteristics and Characteristic Descriptors

- (void)discoverCharacteristics:(NSArray *)characteristicUUIDs forService:(CBService *)service didDiscover:(BBCharacteristicsBlock)didDiscover
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    service.didDiscoverCharacteristics = didDiscover;
    [self discoverCharacteristics:characteristicUUIDs forService:service];
}

- (void)discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic didDiscover:(BBDescriptorsBlock)didDiscover
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    characteristic.didDiscoverDescriptors = didDiscover;
    [self discoverDescriptorsForCharacteristic:characteristic];
}


#pragma mark - Reading Characteristic and Characteristic Descriptor Values

- (void)readValueForCharacteristic:(CBCharacteristic *)characteristic didUpdate:(BBCharacteristicBlock)didUpdate
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    characteristic.didUpdateValue = didUpdate;
    [self readValueForCharacteristic:characteristic];
}

- (void)readValueForDescriptor:(CBDescriptor *)descriptor didUpdate:(BBDescriptorBlock)didUpdate
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    descriptor.didUpdateValue = didUpdate;
    [self readValueForDescriptor:descriptor];
}


#pragma mark - Writing Characteristic and Characteristic Descriptor Values

- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type didWrite:(BBCharacteristicBlock)didWrite
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    characteristic.didWriteValue = didWrite;
    [self writeValue:data forCharacteristic:characteristic type:type];
}

- (void)writeValue:(NSData *)data forDescriptor:(CBDescriptor *)descriptor didWrite:(BBDescriptorBlock)didWrite
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    descriptor.didWriteValue = didWrite;
    [self writeValue:data forDescriptor:descriptor];
}


#pragma mark - Setting Notifications for a Characteristic’s Value

- (void)setNotifyValue:(BOOL)enabled forCharacteristic:(CBCharacteristic *)characteristic didUpdate:(BBCharacteristicBlock)didUpdate
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    characteristic.didUpdateNotificationState = didUpdate;
    [self setNotifyValue:enabled forCharacteristic:characteristic];
}


#pragma mark - Accessing a Peripheral’s Received Signal Strength Indicator (RSSI) Data
- (void)readRSSIAndOnUpdate:(BBPeripheralBlock)didUpdate
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    self.didUpdateRSSI = didUpdate;
    [self readRSSI];
}


#pragma mark - Additional CBPeripheralDelegate Methods
- (void)onNameUpdate:(BBPeripheralBlock)didUpdate
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    self.didUpdateName = didUpdate;
}

- (void)onServicesModification:(BBPeripheralUpdateBlock)didModify
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    self.didModifyServices = didModify;
}



#pragma mark - Peripheral Delegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"didDiscoverServices: %@, %@", peripheral.services, error);
    if (self.didDiscoverServices) {
        self.didDiscoverServices(peripheral.services, error);
        self.didDiscoverServices = nil;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"didDiscoverIncludedServicesForService: %@, %@", service, error);
    if (service.didDiscoverIncludedServices) {
        service.didDiscoverIncludedServices(service.includedServices, error);
        service.didDiscoverIncludedServices = nil;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"didDiscoverCharacteristicsForService: %@, %@", service, error);
    if (service.didDiscoverCharacteristics) {
        service.didDiscoverCharacteristics(service.characteristics, error);
        service.didDiscoverCharacteristics = nil;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didDiscoverDescriptorsForCharacteristic: %@, %@", characteristic, error);
    if (characteristic.didDiscoverDescriptors) {
        characteristic.didDiscoverDescriptors(characteristic.descriptors, error);
        characteristic.didDiscoverDescriptors = nil;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didUpdateValueForCharacteristic: %@, %@", characteristic, error);
    if (characteristic.didUpdateValue) {
        characteristic.didUpdateValue(characteristic, error);
        characteristic.didUpdateValue = nil;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(@"didUpdateValueForDescriptor: %@, %@", descriptor, error);
    if (descriptor.didUpdateValue) {
        descriptor.didUpdateValue(descriptor, error);
        descriptor.didUpdateValue = nil;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didWriteValueForCharacteristic: %@, %@", characteristic, error);
    if (characteristic.didWriteValue) {
        characteristic.didWriteValue(characteristic, error);
        characteristic.didWriteValue = nil;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(@"didWriteValueForDescriptor: %@, %@", descriptor, error);
    if (descriptor.didWriteValue) {
        descriptor.didWriteValue(descriptor, error);
        descriptor.didWriteValue = nil;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didUpdateNotificationStateForCharacteristic: %@, %@", characteristic, error);
    if (characteristic.didUpdateNotificationState) {
        characteristic.didUpdateNotificationState(characteristic, error);
        characteristic.didUpdateNotificationState = nil;
    }
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"peripheralDidUpdateRSSI: %@, %@", peripheral, error);
    if (peripheral.didUpdateRSSI) {
        peripheral.didUpdateRSSI(peripheral, error);
        peripheral.didUpdateRSSI = nil;
    }
}

- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral
{
    NSLog(@"peripheralDidUpdateName: %@", peripheral);
    if (peripheral.didUpdateName) {
        peripheral.didUpdateName(peripheral, nil);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices
{
    NSLog(@"didModifyServices: %@, %@", peripheral, invalidatedServices);
    if (peripheral.didModifyServices) {
        peripheral.didModifyServices(peripheral, invalidatedServices);
    }
}

@end

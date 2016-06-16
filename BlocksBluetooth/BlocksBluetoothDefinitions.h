//
//  BlocksBluetoothDefinitions.h
//  BlocksBluetooth iOS Example
//
//  Created by Joseph Lin on 4/23/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#ifndef BlocksBluetooth_iOS_Example_BlocksBluetoothDefinitions_h
#define BlocksBluetooth_iOS_Example_BlocksBluetoothDefinitions_h

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral, CBService, CBCharacteristic, CBDescriptor;

typedef void(^BBVoidBlock)();
typedef void(^BBErrorBlock)(NSError *error);

typedef void(^BBPeripheralBlock)(CBPeripheral * _Nullable peripheral, NSError * _Nullable error);
typedef void(^BBPeripheralUpdateBlock)(CBPeripheral *peripheral, NSArray<CBService *> *invalidatedServices);
typedef void(^BBPeripheralDiscoverBlock)(CBPeripheral *peripheral, NSDictionary<NSString *,id> *advertisementData, NSNumber *RSSI);

typedef void(^BBServiceBlock)(CBService * _Nullable service, NSError * _Nullable error);
typedef void(^BBServicesBlock)(NSArray<CBService *> * _Nullable services, NSError * _Nullable error);

typedef void(^BBCharacteristicBlock)(CBCharacteristic * _Nullable characteristic, NSError * _Nullable error);
typedef void(^BBCharacteristicsBlock)(NSArray<CBCharacteristic *> * _Nullable characteristics, NSError * _Nullable error);

typedef void(^BBDescriptorBlock)(CBDescriptor * _Nullable descriptor, NSError * _Nullable error);
typedef void(^BBDescriptorsBlock)(NSArray<CBDescriptor *> * _Nullable descriptors, NSError * _Nullable error);

NS_ASSUME_NONNULL_END

#endif

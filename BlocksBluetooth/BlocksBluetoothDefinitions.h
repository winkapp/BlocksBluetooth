//
//  BlocksBluetoothDefinitions.h
//  BlocksBluetooth iOS Example
//
//  Created by Joseph Lin on 4/23/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#ifndef BlocksBluetooth_iOS_Example_BlocksBluetoothDefinitions_h
#define BlocksBluetooth_iOS_Example_BlocksBluetoothDefinitions_h

typedef void(^BBVoidBlock)();
typedef void(^BBErrorBlock)(NSError *error);

typedef void(^BBPeripheralBlock)(CBPeripheral *peripheral, NSError *error);
typedef void(^BBPeripheralsBlock)(NSArray *peripherals, NSError *error);
typedef void(^BBPeripheralUpdateBlock)(CBPeripheral *peripheral, NSArray *invalidatedServices);
typedef void(^BBPeripheralDiscoverBlock)(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI);

typedef void(^BBServiceBlock)(CBService *service, NSError *error);
typedef void(^BBServicesBlock)(NSArray *services, NSError *error);

typedef void(^BBCharacteristicBlock)(CBCharacteristic *characteristic, NSError *error);
typedef void(^BBCharacteristicsBlock)(NSArray *characteristics, NSError *error);

typedef void(^BBDescriptorBlock)(CBDescriptor *descriptor, NSError *error);
typedef void(^BBDescriptorsBlock)(NSArray *descriptors, NSError *error);

#endif

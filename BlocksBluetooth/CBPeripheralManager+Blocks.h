//
//  CBPeripheralManager+Blocks.h
//  BlocksBluetooth iOS Example
//
//  Created by Joseph Lin on 4/23/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "BlocksBluetoothDefinitions.h"

typedef void(^BBCentralSubscriptionBlock)(CBCentral *central, CBCharacteristic *characteristic);
typedef void(^BBRequestBlock)(CBATTRequest *request);
typedef void(^BBRequestsBlock)(NSArray *requests);


@interface CBPeripheralManager (Blocks) <CBPeripheralManagerDelegate>

@property (nonatomic, strong) BBVoidBlock didUpdateState;
@property (nonatomic, strong) BBCentralSubscriptionBlock centralDidSubscribeToCharacteristic;
@property (nonatomic, strong) BBCentralSubscriptionBlock centralDidUnsubscribeFromCharacteristic;
@property (nonatomic, strong) BBVoidBlock isReadyToUpdateSubscribers;
@property (nonatomic, strong) BBRequestBlock didReceiveReadRequest;
@property (nonatomic, strong) BBRequestsBlock didReceiveWriteRequests;

#pragma mark - Initializing a Peripheral Manager
+ (instancetype)defaultManager;
- (id)initWithQueue:(dispatch_queue_t)queue;
- (id)initWithQueue:(dispatch_queue_t)queue options:(NSDictionary *)options NS_AVAILABLE(NA, 7_0);

#pragma mark - Adding Services
- (void)addService:(CBMutableService *)service didAdd:(BBServiceBlock)didAdd;

#pragma mark - Advertising Peripheral Data
- (void)startAdvertising:(NSDictionary *)advertisementData didStart:(BBErrorBlock)didStart;

@end

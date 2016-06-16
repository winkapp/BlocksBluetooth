//
//  CBPeripheralManager+Blocks.h
//  BlocksBluetooth iOS Example
//
//  Created by Joseph Lin on 4/23/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "BlocksBluetoothDefinitions.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^BBCentralSubscriptionBlock)(CBCentral *central, CBCharacteristic *characteristic);
typedef void(^BBRequestBlock)(CBATTRequest *request);
typedef void(^BBRequestsBlock)(NSArray *requests);


@interface CBPeripheralManager (Blocks) <CBPeripheralManagerDelegate>

@property (nonatomic, nullable, copy) BBVoidBlock didUpdateState;
@property (nonatomic, nullable, copy) BBCentralSubscriptionBlock centralDidSubscribeToCharacteristic;
@property (nonatomic, nullable, copy) BBCentralSubscriptionBlock centralDidUnsubscribeFromCharacteristic;
@property (nonatomic, nullable, copy) BBVoidBlock isReadyToUpdateSubscribers;
@property (nonatomic, nullable, copy) BBRequestBlock didReceiveReadRequest;
@property (nonatomic, nullable, copy) BBRequestsBlock didReceiveWriteRequests;

#pragma mark - Initializing a Peripheral Manager
+ (instancetype)defaultManager;
- (instancetype)initWithQueue:(nullable dispatch_queue_t)queue;
- (instancetype)initWithQueue:(nullable dispatch_queue_t)queue options:(nullable NSDictionary<NSString *, id> *)options;

#pragma mark - Adding Services
- (void)addService:(CBMutableService *)service didAdd:(nullable BBServiceBlock)didAdd;

#pragma mark - Advertising Peripheral Data
- (void)startAdvertising:(nullable NSDictionary<NSString *, id> *)advertisementData didStart:(nullable BBErrorBlock)didStart;

@end


NS_ASSUME_NONNULL_END

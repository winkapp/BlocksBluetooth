//
//  CBPeripheralManager+Blocks.m
//  BlocksBluetooth iOS Example
//
//  Created by Joseph Lin on 4/23/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import "CBPeripheralManager+Blocks.h"
#import <objc/runtime.h>
#import "CBPeripheralManager+Debug.h"



#pragma mark - CBService Private Properties

@interface CBService (_Blocks)
@property (nonatomic, copy) BBServiceBlock didAddService;
@end


@implementation CBService (_Blocks)

- (BBServiceBlock)didAddService
{
    return (BBServiceBlock)objc_getAssociatedObject(self, @selector(didAddService));
}

- (void)setDidAddService:(BBServiceBlock)didAddService
{
    objc_setAssociatedObject(self, @selector(didAddService), didAddService, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end



#pragma mark - CBPeripheralManager Private Properties

@interface CBPeripheralManager (_Blocks)
@property (nonatomic, copy) BBErrorBlock didStartAdvertising;
@end


@implementation CBPeripheralManager (_Blocks)

- (BBErrorBlock)didStartAdvertising
{
    return (BBErrorBlock)objc_getAssociatedObject(self, @selector(didStartAdvertising));
}

- (void)setDidStartAdvertising:(BBErrorBlock)didStartAdvertising
{
    objc_setAssociatedObject(self, @selector(didStartAdvertising), didStartAdvertising, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end



#pragma mark - CBPeripheralManager

@implementation CBPeripheralManager (Blocks)

- (BBVoidBlock)didUpdateState
{
    return (BBVoidBlock)objc_getAssociatedObject(self, @selector(didUpdateState));
}

- (void)setDidUpdateState:(BBVoidBlock)didUpdateState
{
    objc_setAssociatedObject(self, @selector(didUpdateState), didUpdateState, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BBCentralSubscriptionBlock)centralDidSubscribeToCharacteristic
{
    return (BBCentralSubscriptionBlock)objc_getAssociatedObject(self, @selector(centralDidSubscribeToCharacteristic));
}

- (void)setCentralDidSubscribeToCharacteristic:(BBCentralSubscriptionBlock)centralDidSubscribeToCharacteristic
{
    objc_setAssociatedObject(self, @selector(centralDidSubscribeToCharacteristic), centralDidSubscribeToCharacteristic, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BBCentralSubscriptionBlock)centralDidUnsubscribeFromCharacteristic
{
    return (BBCentralSubscriptionBlock)objc_getAssociatedObject(self, @selector(centralDidUnsubscribeFromCharacteristic));
}

- (void)setCentralDidUnsubscribeFromCharacteristic:(BBCentralSubscriptionBlock)centralDidUnsubscribeFromCharacteristic
{
    objc_setAssociatedObject(self, @selector(centralDidUnsubscribeFromCharacteristic), centralDidUnsubscribeFromCharacteristic, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BBVoidBlock)isReadyToUpdateSubscribers
{
    return (BBVoidBlock)objc_getAssociatedObject(self, @selector(isReadyToUpdateSubscribers));
}

- (void)setIsReadyToUpdateSubscribers:(BBVoidBlock)isReadyToUpdateSubscribers
{
    objc_setAssociatedObject(self, @selector(isReadyToUpdateSubscribers), isReadyToUpdateSubscribers, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BBRequestBlock)didReceiveReadRequest
{
    return (BBRequestBlock)objc_getAssociatedObject(self, @selector(didReceiveReadRequest));
}

- (void)setDidReceiveReadRequest:(BBRequestBlock)didReceiveReadRequest
{
    objc_setAssociatedObject(self, @selector(didReceiveReadRequest), didReceiveReadRequest, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BBRequestsBlock)didReceiveWriteRequests
{
    return (BBRequestsBlock)objc_getAssociatedObject(self, @selector(didReceiveWriteRequests));
}

- (void)setDidReceiveWriteRequests:(BBRequestsBlock)didReceiveWriteRequests
{
    objc_setAssociatedObject(self, @selector(didReceiveWriteRequests), didReceiveWriteRequests, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


#pragma mark - Initializing a Peripheral Manager

+ (instancetype)defaultManager
{
    static CBPeripheralManager *_defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [[CBPeripheralManager alloc] initWithQueue:nil];
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


#pragma mark - Adding Services

- (void)addService:(CBMutableService *)service didAdd:(BBServiceBlock)didAdd
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    service.didAddService = didAdd;
    [self addService:service];
}


#pragma mark - Advertising Peripheral Data

- (void)startAdvertising:(NSDictionary *)advertisementData didStart:(BBErrorBlock)didStart
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    self.didStartAdvertising = didStart;
    [self startAdvertising:advertisementData];
}


#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"peripheralManagerDidUpdateState: %@", peripheral.stateString);
    if (self.didUpdateState) {
        self.didUpdateState();
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    NSLog(@"didAddService: %@, %@", service, error);
    if (service.didAddService) {
        service.didAddService(service, error);
        service.didAddService = nil;
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    NSLog(@"didStartAdvertising: %@, %@", peripheral, error);
    if (self.didStartAdvertising) {
        self.didStartAdvertising(error);
        self.didStartAdvertising = nil;
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"central: %@, didSubscribeToCharacteristic: %@", central, characteristic);
    if (self.centralDidSubscribeToCharacteristic) {
        self.centralDidSubscribeToCharacteristic(central, characteristic);
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"central: %@, didUnsubscribeFromCharacteristic: %@", central, characteristic);
    if (self.centralDidUnsubscribeFromCharacteristic) {
        self.centralDidUnsubscribeFromCharacteristic(central, characteristic);
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request
{
    NSLog(@"didReceiveReadRequest: %@", request);
    if (self.didReceiveReadRequest) {
        self.didReceiveReadRequest(request);
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests
{
    NSLog(@"didReceiveWriteRequests: %@", requests);
    if (self.didReceiveWriteRequests) {
        self.didReceiveWriteRequests(requests);
    }
}

@end






























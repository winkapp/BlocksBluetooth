//
//  AdvertisingViewController.m
//  BLE-Demo
//
//  Created by Joseph Lin on 4/19/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import "AdvertisingViewController.h"
#import "CBPeripheralManager+Blocks.h"

static NSString * const BBDemoServiceUUID       = @"7846ED88-7CD9-495F-AC2A-D34D245C9FB6";
static NSString * const BBDemoCharateristicUUID = @"B97E791B-F1A3-486C-9AF4-4DA083BB9539";


@interface AdvertisingViewController () <UITextFieldDelegate>
@property (nonatomic, strong) CBMutableService *demoService;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@end


@implementation AdvertisingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textField.text = BBDemoServiceUUID;
    
    __weak typeof(self) weakSelf = self;
    
    [[CBPeripheralManager defaultManager] addService:self.demoService didAdd:^(CBService *service, NSError *error) {
        
    }];
    
    [CBPeripheralManager defaultManager].didReceiveReadRequest = ^(CBATTRequest *request){
        
        for (CBCharacteristic *characteristic in weakSelf.demoService.characteristics) {
            if ([request.characteristic.UUID isEqual:characteristic.UUID]) {
                if (request.offset > characteristic.value.length) {
                    [[CBPeripheralManager defaultManager] respondToRequest:request withResult:CBATTErrorInvalidOffset];
                }
                else {
                    request.value = [characteristic.value subdataWithRange:NSMakeRange(request.offset, characteristic.value.length - request.offset)];
                    [[CBPeripheralManager defaultManager] respondToRequest:request withResult:CBATTErrorSuccess];
                }
                break;
            }
        }
    };
}

- (CBMutableService *)demoService
{
    if (!_demoService) {
        NSString *stringValue = @"This is a BlocksBluetooth demo characteristic";
        NSData *value = [stringValue dataUsingEncoding:NSUTF8StringEncoding];
        
        CBUUID *demoCharateristicUUID = [CBUUID UUIDWithString:BBDemoCharateristicUUID];
        CBMutableCharacteristic *characteristic = [[CBMutableCharacteristic alloc] initWithType:demoCharateristicUUID
                                                                                     properties:CBCharacteristicPropertyRead
                                                                                          value:value
                                                                                    permissions:CBAttributePermissionsReadable];
        
        CBUUID *demoServiceUUID = [CBUUID UUIDWithString:self.textField.text];
        CBMutableService *service = [[CBMutableService alloc] initWithType:demoServiceUUID primary:YES];
        service.characteristics = @[characteristic];
        _demoService = service;
    }
    return _demoService;
}

- (IBAction)startButtonTapped:(id)sender
{
    NSDictionary *dict = @{
                           CBAdvertisementDataServiceUUIDsKey : @[self.demoService.UUID],
                           CBAdvertisementDataLocalNameKey : @"BlocksBluetooth Demo",
                           };
    [[CBPeripheralManager defaultManager] startAdvertising:dict didStart:^(NSError *error) {
    }];
}

- (IBAction)stopButtonTapped:(id)sender
{
    [[CBPeripheralManager defaultManager] stopAdvertising];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.demoService = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end

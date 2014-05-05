//
//  PeripheralViewController.m
//  BLE-Demo
//
//  Created by Joseph Lin on 4/19/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import "PeripheralViewController.h"
#import "CBPeripheral+Blocks.h"
#import "CBCentralManager+Blocks.h"
#import "CBPeripheral+Debug.h"
#import "CharacteristicCell.h"


@interface PeripheralViewController ()
@property (nonatomic, weak) IBOutlet UILabel *identifierLabel;
@property (nonatomic, weak) IBOutlet UILabel *RSSILabel;
@property (nonatomic, weak) IBOutlet UILabel *stateLabel;
@end


@implementation PeripheralViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.peripheral.name;
    self.identifierLabel.text = self.peripheral.identifier.UUIDString;
    self.RSSILabel.text = [NSString stringWithFormat:@"RSSI: %@", self.peripheral.RSSI ?: @"--"];
    self.stateLabel.text = @"Connecting";


    __weak typeof(self) weakSelf = self;
    [[CBCentralManager defaultManager] connectPeripheral:self.peripheral options:nil didConnect:^(CBPeripheral *peripheral, NSError *error) {
        
        weakSelf.stateLabel.text = weakSelf.peripheral.stateString;
        
        // 1A. Read RSSI
        [peripheral readRSSIAndOnUpdate:^(CBPeripheral *peripheral, NSError *error) {
            weakSelf.RSSILabel.text = [NSString stringWithFormat:@"RSSI: %@", peripheral.RSSI ?: @"--"];
        }];

        // 1B. Discover Services
        [peripheral discoverServices:nil didDiscover:^(NSArray *services, NSError *error) {
            
            [weakSelf.tableView reloadData];
            
            for (CBService *service in services) {
                
                // 2A. Discover Characteristics
                [peripheral discoverCharacteristics:nil forService:service didDiscover:^(NSArray *characteristics, NSError *error) {
                    [weakSelf.tableView beginUpdates];
                    NSUInteger index = [peripheral.services indexOfObject:service];
                    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
                    [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    [weakSelf.tableView endUpdates];
                    
                    for (CBCharacteristic *characteristic in characteristics) {

                        // 3A. Read Value For Characteristic
                        [peripheral readValueForCharacteristic:characteristic didUpdate:^(CBCharacteristic *characteristic, NSError *error) {
                            [weakSelf updateTableViewForCharacteristic:characteristic];
                        }];
                        
                        // 3A. Discover Descriptors For Characteristic
                        [peripheral discoverDescriptorsForCharacteristic:characteristic didDiscover:^(NSArray *descriptors, NSError *error) {
                            [weakSelf updateTableViewForCharacteristic:characteristic];
                        }];
                    }
                }];
                
                // 2B. Discover Included Services
                [peripheral discoverIncludedServices:nil forService:service didDiscover:^(NSArray *services, NSError *error) {
                    //TODO:
                }];
            }
        }];
        
    } didDisconnect:^(CBPeripheral *peripheral, NSError *error) {
        
        weakSelf.stateLabel.text = weakSelf.peripheral.stateString;
        [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
    }];
}

- (void)dealloc
{
    [[CBCentralManager defaultManager] cancelPeripheralConnection:self.peripheral didDisconnect:nil];
}

- (void)updateTableViewForCharacteristic:(CBCharacteristic *)characteristic
{
    [self.tableView beginUpdates];
    CBService *service = characteristic.service;
    CBPeripheral *peripheral = service.peripheral;
    NSUInteger section = [peripheral.services indexOfObject:service];
    NSUInteger row = [service.characteristics indexOfObject:characteristic];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.peripheral.services.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    CBService *service = self.peripheral.services[section];
    if (service.isPrimary) {
        return [NSString stringWithFormat:@"%@ (Primary)", service.UUID.UUIDString];
    }
    else {
        return service.UUID.UUIDString;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CBService *service = self.peripheral.services[section];
    return service.characteristics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CharacteristicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CharacteristicCell class]) forIndexPath:indexPath];
    CBService *service = self.peripheral.services[indexPath.section];
    CBCharacteristic *characteristic = service.characteristics[indexPath.row];
    cell.characteristic = characteristic;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBService *service = self.peripheral.services[indexPath.section];
    CBCharacteristic *characteristic = service.characteristics[indexPath.row];
    
    NSString *string = @"greetings from ios";
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [service.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse didWrite:^(CBCharacteristic *characteristic, NSError *error) {
        if (error) {
            NSLog(@"didWrite error: %@", error);
            [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
        }
        else {
            NSLog(@"didWrite: %@", characteristic);
            [[[UIAlertView alloc] initWithTitle:nil message:@"Success!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
        }
    }];
}

@end

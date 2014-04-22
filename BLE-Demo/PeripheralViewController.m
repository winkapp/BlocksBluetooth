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


@interface PeripheralViewController ()

@end


@implementation PeripheralViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.peripheral.name;

    __weak typeof(self) weakSelf = self;
    [[CBCentralManager defaultManager] connectPeripheral:self.peripheral options:nil didConnect:^(CBPeripheral *peripheral, NSError *error) {
        
        [peripheral discoverServices:nil didDiscover:^(NSArray *services, NSError *error) {
            
            [weakSelf.tableView reloadData];
            
            for (CBService *service in services) {
                [peripheral discoverCharacteristics:nil forService:service didDiscover:^(NSArray *characteristics, NSError *error) {

                    [self.tableView beginUpdates];
                    NSUInteger index = [peripheral.services indexOfObject:service];
                    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
                    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationTop];
                    [self.tableView endUpdates];
                }];
            }
        }];
    }];
}

- (void)dealloc
{
    [[CBCentralManager defaultManager] cancelPeripheralConnection:self.peripheral didDisconnect:nil];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    CBService *service = self.peripheral.services[indexPath.section];
    CBCharacteristic *characteristic = service.characteristics[indexPath.row];
    cell.textLabel.text = characteristic.UUID.UUIDString;
    
    return cell;
}

@end

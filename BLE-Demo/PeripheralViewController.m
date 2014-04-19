//
//  PeripheralViewController.m
//  BLE-Demo
//
//  Created by Joseph Lin on 4/19/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import "PeripheralViewController.h"


@interface PeripheralViewController ()

@end


@implementation PeripheralViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.peripheral.name;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDiscoverServices:) name:BLEDidDiscoverServicesNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDiscoverCharacteristics:) name:BLEDidDiscoverCharacteristicsNotification object:nil];
    
    [[BLEManager sharedInstance].centralManager connectPeripheral:self.peripheral options:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didDiscoverServices:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)didDiscoverCharacteristics:(NSNotification *)notification
{
    [self.tableView reloadData];
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

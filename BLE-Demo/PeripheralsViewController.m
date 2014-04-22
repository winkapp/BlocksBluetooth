//
//  PeripheralsViewController.m
//  BLE-Demo
//
//  Created by Joseph Lin on 4/19/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import "PeripheralsViewController.h"
#import "PeripheralViewController.h"
#import "CBCentralManager+Blocks.h"
#import "CBPeripheral+Debug.h"
#import "PeripheralCell.h"


@interface PeripheralsViewController ()
@property (nonatomic, weak) IBOutlet UIBarButtonItem *scanButton;
@property (nonatomic, strong) NSMutableArray *peripherals;
@property (nonatomic, getter = isScanning) BOOL scanning;
@end


@implementation PeripheralsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.peripherals = [NSMutableArray new];
}


#pragma mark -

- (IBAction)scanButtonTapped:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    if (!self.isScanning) {
        [self.peripherals removeAllObjects];
        [self.tableView reloadData];
        [[CBCentralManager defaultManager] scanForPeripheralsWithServices:nil options:nil didDiscover:^(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
            [weakSelf addPeripheral:peripheral];
        }];
        self.scanning = YES;
        self.scanButton.title = @"Stop";
    }
    else {
        [[CBCentralManager defaultManager] stopScanAndRemoveHandler];
        self.scanButton.title = @"Rescan";
        self.scanning = NO;
    }
}

- (void)addPeripheral:(CBPeripheral *)peripheral
{
    if (![self.peripherals containsObject:peripheral]) {
        [self.tableView beginUpdates];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.peripherals.count inSection:0];
        [self.peripherals addObject:peripheral];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PeripheralCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PeripheralCell class]) forIndexPath:indexPath];
    cell.peripheral = self.peripherals[indexPath.row];
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    CBPeripheral *peripheral = self.peripherals[indexPath.row];
    
    PeripheralViewController *controller = segue.destinationViewController;
    controller.peripheral = peripheral;
}

@end

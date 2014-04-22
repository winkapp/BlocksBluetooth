//
//  PeripheralsViewController.m
//  BLE-Demo
//
//  Created by Joseph Lin on 4/19/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import "PeripheralsViewController.h"
#import "PeripheralViewController.h"
#import "BLEManager.h"


@interface PeripheralsViewController ()
@property (nonatomic, weak) IBOutlet UIBarButtonItem *scanButton;
@property (nonatomic, strong) NSMutableArray *peripherals;
@end


@implementation PeripheralsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.peripherals = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDiscoverPeripheral:) name:BLEDidDiscoverPeripheralNotification object:nil];
}


#pragma mark -

- (void)didDiscoverPeripheral:(NSNotification *)notification
{
    CBPeripheral *peripheral = notification.object;
    
    if (![self.peripherals containsObject:peripheral]) {
        [self.tableView beginUpdates];

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.peripherals.count inSection:0];
        [self.peripherals addObject:peripheral];

        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
}

- (IBAction)scanButtonTapped:(id)sender
{
    if ([BLEManager sharedInstance].isScanning) {
        [[BLEManager sharedInstance] stopScan];
        self.scanButton.title = @"Rescan";
    }
    else {
        [self.peripherals removeAllObjects];
        [self.tableView reloadData];
        [[BLEManager sharedInstance] startScan];
        self.scanButton.title = @"Stop";
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    CBPeripheral *peripheral = self.peripherals[indexPath.row];
    cell.textLabel.text = peripheral.name;
    cell.detailTextLabel.text = peripheral.identifier.UUIDString;
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

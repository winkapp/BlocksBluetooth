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
@end


@implementation PeripheralsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:BLEDidDiscoverPeripheralNotification object:nil];
}


#pragma mark -

- (void)refresh
{
    [self.tableView reloadData];
}

- (IBAction)scanButtonTapped:(id)sender
{
    if ([BLEManager sharedInstance].isScanning) {
        [[BLEManager sharedInstance] stopScan];
        self.scanButton.title = @"Rescan";
    }
    else {
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
    return [BLEManager sharedInstance].peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    CBPeripheral *peripheral = [BLEManager sharedInstance].peripherals[indexPath.row];
    cell.textLabel.text = peripheral.name;
    cell.detailTextLabel.text = peripheral.identifier.UUIDString;
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    CBPeripheral *peripheral = [BLEManager sharedInstance].peripherals[indexPath.row];
    
    PeripheralViewController *controller = segue.destinationViewController;
    controller.peripheral = peripheral;
}

@end

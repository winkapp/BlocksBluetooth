//
//  PeripheralViewController.h
//  BLE-Demo
//
//  Created by Joseph Lin on 4/19/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBPeripheral;


@interface PeripheralViewController : UITableViewController

@property (nonatomic, strong) CBPeripheral *peripheral;

@end

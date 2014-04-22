//
//  PeripheralCell.m
//  BLE-Demo
//
//  Created by Joseph Lin on 4/22/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import "PeripheralCell.h"
#import "CBPeripheral+Debug.h"


@interface PeripheralCell ()
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *stateLabel;
@property (nonatomic, weak) IBOutlet UILabel *RSSILabel;
@property (nonatomic, weak) IBOutlet UILabel *servicesLabel;
@property (nonatomic, weak) IBOutlet UILabel *identifierLabel;
@end


@implementation PeripheralCell

- (void)setPeripheral:(CBPeripheral *)peripheral
{
    _peripheral = peripheral;
    
    self.nameLabel.text = peripheral.name ?: @"(Unknown)";
    self.stateLabel.text = peripheral.stateString;
    self.RSSILabel.text = [NSString stringWithFormat:@"RSSI: %@", peripheral.RSSI ?: @"--"];
    self.servicesLabel.text = (peripheral.services) ? [NSString stringWithFormat:@"%d services", peripheral.services.count] : @"";
    self.identifierLabel.text = peripheral.identifier.UUIDString;
}

@end

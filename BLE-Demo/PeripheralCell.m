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
    self.servicesLabel.text = (peripheral.services) ? [NSString stringWithFormat:@"%lu services", (unsigned long)peripheral.services.count] : @"";
    self.identifierLabel.text = peripheral.identifier.UUIDString;
    
    switch (peripheral.state) {
        case CBPeripheralStateDisconnected:
            self.stateLabel.textColor = [UIColor colorWithRed:0.516 green:0.000 blue:0.006 alpha:1.000];
            break;
            
        case CBPeripheralStateConnecting:
            self.stateLabel.textColor = [UIColor colorWithRed:0.687 green:0.686 blue:0.001 alpha:1.000];
            break;
            
        case CBPeripheralStateConnected:
            self.stateLabel.textColor = [UIColor colorWithRed:0.251 green:0.502 blue:0.000 alpha:1.000];
            break;
            
        default:
            self.stateLabel.textColor = [UIColor darkTextColor];
            break;
    }
}

- (void)setRSSI:(NSNumber *)RSSI
{
    _RSSI = RSSI;
    
    self.RSSILabel.text = [NSString stringWithFormat:@"RSSI: %@", self.RSSI ?: @"--"];
}

@end

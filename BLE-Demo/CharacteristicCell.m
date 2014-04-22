//
//  CharacteristicCell.m
//  BLE-Demo
//
//  Created by Joseph Lin on 4/22/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import "CharacteristicCell.h"
#import "CBCharacteristic+Debug.h"


@interface CharacteristicCell ()
@property (nonatomic, weak) IBOutlet UILabel *identifierLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;
@property (nonatomic, weak) IBOutlet UILabel *propertiesLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptorsLabel;
@end


@implementation CharacteristicCell

- (void)setCharacteristic:(CBCharacteristic *)characteristic
{
    _characteristic = characteristic;
    
    self.identifierLabel.text = characteristic.UUID.UUIDString;
    
    if (characteristic.value) {
        NSString *value = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        if (value) {
            self.valueLabel.text = value;
        }
        else {
            self.valueLabel.text = @"(Unknown data type)";
        }
    }
    else {
        self.valueLabel.text = @"(No value)";
    }

    
    self.propertiesLabel.text = characteristic.propertiesString;

    self.descriptorsLabel.text = (characteristic.descriptors) ? [NSString stringWithFormat:@"%lu descriptors", (unsigned long)characteristic.descriptors.count] : nil;
}

@end

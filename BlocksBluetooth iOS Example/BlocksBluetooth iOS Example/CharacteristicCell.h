//
//  CharacteristicCell.h
//  BLE-Demo
//
//  Created by Joseph Lin on 4/22/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBCharacteristic;


@interface CharacteristicCell : UITableViewCell

@property (nonatomic, strong) CBCharacteristic *characteristic;

@end

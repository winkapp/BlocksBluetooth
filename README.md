BlocksBluetooth
========

Block-based CoreBluetooth categories to make your life easier.

This is a pre-release library. v0.0.1 focuses on `CBCentralManager` and `CBPeripheral`, aiming for devices that performs a Central role. On the other hand, only basic `CBPeripheralManager` tasks are covered in this release.


## Example

### Scanning for BLE peripherals

```objective-c
[[CBCentralManager defaultManager] scanForPeripheralsWithServices:nil options:nil didDiscover:^(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
    // Handle the returned peripheral
}];
```

### Connect to a peripheral, and then recursively discover all its services, characteristics, and descriptors

```objective-c
__weak typeof(self) weakSelf = self;
[[CBCentralManager defaultManager] connectPeripheral:self.peripheral options:nil didConnect:^(CBPeripheral *peripheral, NSError *error) {
    
    weakSelf.stateLabel.text = weakSelf.peripheral.stateString;
    
    // 1A. Read RSSI
    [peripheral readRSSIAndOnUpdate:^(CBPeripheral *peripheral, NSError *error) {
        weakSelf.RSSILabel.text = [NSString stringWithFormat:@"RSSI: %@", peripheral.RSSI ?: @"--"];
    }];

    // 1B. Discover Services
    [peripheral discoverServices:nil didDiscover:^(NSArray *services, NSError *error) {
        
        [weakSelf.tableView reloadData];
        
        for (CBService *service in services) {
            
            // 2A. Discover Characteristics
            [peripheral discoverCharacteristics:nil forService:service didDiscover:^(NSArray *characteristics, NSError *error) {
                [weakSelf.tableView beginUpdates];
                NSUInteger index = [peripheral.services indexOfObject:service];
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
                [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                [weakSelf.tableView endUpdates];
                
                for (CBCharacteristic *characteristic in characteristics) {

                    // 3A. Read Value For Characteristic
                    [peripheral readValueForCharacteristic:characteristic didUpdate:^(CBCharacteristic *characteristic, NSError *error) {
                        [weakSelf updateTableViewForCharacteristic:characteristic];
                    }];
                    
                    // 3A. Discover Descriptors For Characteristic
                    [peripheral discoverDescriptorsForCharacteristic:characteristic didDiscover:^(NSArray *descriptors, NSError *error) {
                        [weakSelf updateTableViewForCharacteristic:characteristic];
                    }];
                }
            }];
            
            // 2B. Discover Included Services
            [peripheral discoverIncludedServices:nil forService:service didDiscover:^(NSArray *services, NSError *error) {
                //TODO:
            }];
        }
    }];
    
} didDisconnect:^(CBPeripheral *peripheral, NSError *error) {
    
    weakSelf.stateLabel.text = weakSelf.peripheral.stateString;
    [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
}];
```

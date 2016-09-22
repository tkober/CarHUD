//
//  CHBLEConnector.swift
//  CarHud
//
//  Created by Thorsten Kober on 05/09/16.
//  Copyright © 2016 Thorsten Kober. All rights reserved.
//

import Foundation
import CoreBluetooth


protocol CHBLEConnectorDelegate {
    
    func connectorDiscoveredOBD2Adapter(_ connector: CHBLEConnector)
    
    func connectorEstablishedConnection(_ connector: CHBLEConnector)
    
    func connectorAuthenticationSuccessful(_ connector: CHBLEConnector)
    
    func connectorServiceStarted(_ connector: CHBLEConnector)
    
    func connectorServiceStopped(_ connector: CHBLEConnector)
    
    func connectorFailedConnecting(_ connector: CHBLEConnector)
    
    func connectorLostConnection(_ connector: CHBLEConnector)
}


class CHBLEConnector: NSObject {
    
    
    var delegate: CHBLEConnectorDelegate?
    
    
    // MARK: | UUIDs
    
    fileprivate let SERVICE_UUID = CBUUID(string: CAR_BRIDGE_SERVICE_UUID)
    
    fileprivate let OBD2_CHARACTERISTIC_UUID = CBUUID(string: CAR_BRIDGE_OBD2_CHARACTERISTIC_UUID)
    
    fileprivate let COMMAND_CHARACTERISTIC_UUID = CBUUID(string: CAR_BRIDGE_COMMANDS_CHARACTERISTIC_UUID)
    
    fileprivate let PASSWORD_CHARACTERISTIC_UUID = CBUUID(string: CAR_BRIDGE_PASSWORD_CHARACTERISTIC_UUID)
    
    fileprivate let STATUS_CHARACTERISTIC_UUID = CBUUID(string: CAR_BRIDGE_STATUS_CHARACTERISTIC_UUID)
    
    
    // MARK: | Central Manager
    
    
    fileprivate lazy var centralManager: CBCentralManager = CBCentralManager(delegate: self, queue: DispatchQueue(label: "ble_queue", attributes: []))
    
    
    // MARK: | Starting
    
    
    var startBLE = false
    
    
    func start() {
        if self.centralManager.state == CBCentralManagerState.poweredOn {
            self.centralManager.scanForPeripherals(withServices: [SERVICE_UUID], options: nil)
            self.startBLE = false
        } else {
            self.startBLE = true
        }
    }
    
    
    var peripheral: CBPeripheral!
    
    var obd2Characteristic: CBCharacteristic!
    
    var commandsCharacteristic: CBCharacteristic!
    
    var passwordCharacteristic: CBCharacteristic!
    
    var statusCharacteristic: CBCharacteristic!
    
    func updateOBD2ValuesWithData(_ data: Data) {
        preconditionFailure("Must be overridden in concrete subclass")
    }
    
    func executeCommandWithData(_ data: Data) {
        preconditionFailure("Must be overridden in concrete subclass")
    }
}


extension CHBLEConnector: CBCentralManagerDelegate {
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            
        case CBCentralManagerState.unknown:
            break
            
        case CBCentralManagerState.resetting:
            break
            
        case CBCentralManagerState.unsupported:
            break
            
        case CBCentralManagerState.unauthorized:
            break
            
        case CBCentralManagerState.poweredOff:
            break
            
        case CBCentralManagerState.poweredOn:
            if (self.startBLE) {
                self.start()
            }
            break
            
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let localDeviceName = advertisementData[CBAdvertisementDataLocalNameKey] {
            if localDeviceName as! String == LOCAL_DEVICE_NAME {
                central.stopScan()
                self.delegate?.connectorDiscoveredOBD2Adapter(self)
                self.peripheral = peripheral
                centralManager.connect(peripheral, options: nil)
            }
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices([SERVICE_UUID])
    }
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        central.connect(peripheral, options: nil)
        self.delegate?.connectorLostConnection(self)
    }
}



extension CHBLEConnector: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            self.delegate?.connectorFailedConnecting(self)
            return
        }
        for service in peripheral.services! {
            if service.uuid == SERVICE_UUID {
                peripheral.discoverCharacteristics([], for: service)
                return
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil {
            self.delegate?.connectorFailedConnecting(self)
            return
        }
        for characteristic in service.characteristics! {
            if characteristic.uuid.uuidString == CAR_BRIDGE_OBD2_CHARACTERISTIC_UUID {
                self.obd2Characteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            }
            if characteristic.uuid.uuidString == CAR_BRIDGE_COMMANDS_CHARACTERISTIC_UUID {
                self.commandsCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            }
            if characteristic.uuid.uuidString == CAR_BRIDGE_PASSWORD_CHARACTERISTIC_UUID {
                self.passwordCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            }
            if characteristic.uuid.uuidString == CAR_BRIDGE_STATUS_CHARACTERISTIC_UUID {
                self.statusCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let commands = self.commandsCharacteristic,
            let obd2 = self.obd2Characteristic,
            let password = self.passwordCharacteristic,
            let status = self.statusCharacteristic {
            
            if commands.isNotifying &&
                obd2.isNotifying &&
                password.isNotifying &&
                status.isNotifying {
                self.delegate?.connectorEstablishedConnection(self)
                peripheral.writeValue(DEVICE_PASSWORD.data(using: String.Encoding.utf8)!, for: self.passwordCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let characteristicValue = characteristic.value {
            if characteristic.uuid.uuidString == CAR_BRIDGE_OBD2_CHARACTERISTIC_UUID {
                updateOBD2ValuesWithData(characteristicValue)
            } else if characteristic.uuid.uuidString == CAR_BRIDGE_COMMANDS_CHARACTERISTIC_UUID {
                executeCommandWithData(characteristicValue)
            } else if characteristic.uuid.uuidString == CAR_BRIDGE_PASSWORD_CHARACTERISTIC_UUID {
                let result = NSNumber(value: characteristic.value!.asUInt8 as UInt8)
                if result.boolValue {
                    self.delegate?.connectorAuthenticationSuccessful(self)
                }
            } else if characteristic.uuid.uuidString == CAR_BRIDGE_STATUS_CHARACTERISTIC_UUID {
                switch Int32(characteristic.value!.asUInt8) {
                    
                case STATUS_SERVICE_STARTED:
                    self.delegate?.connectorServiceStarted(self)
                    break
                    
                case STATUS_SERVICE_STOPPED:
                    self.delegate?.connectorServiceStopped(self)
                    break;
                    
                default:
                    break;
                    
                }
            }
        }
    }
}

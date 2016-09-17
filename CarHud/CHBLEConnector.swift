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
    
    func connectorDiscoveredOBD2Adapter(connector: CHBLEConnector)
    
    func connectorEstablishedConnection(connector: CHBLEConnector)
    
    func connectorAuthenticationSuccessful(connector: CHBLEConnector)
    
    func connectorServiceStarted(connector: CHBLEConnector)
    
    func connectorServiceStopped(connector: CHBLEConnector)
    
    func connectorFailedConnecting(connector: CHBLEConnector)
    
    func connectorLostConnection(connector: CHBLEConnector)
}


class CHBLEConnector: NSObject {
    
    
    var delegate: CHBLEConnectorDelegate?
    
    
    // MARK: | UUIDs
    
    private let SERVICE_UUID = CBUUID(string: CAR_BRIDGE_SERVICE_UUID)
    
    private let OBD2_CHARACTERISTIC_UUID = CBUUID(string: CAR_BRIDGE_OBD2_CHARACTERISTIC_UUID)
    
    private let COMMAND_CHARACTERISTIC_UUID = CBUUID(string: CAR_BRIDGE_COMMANDS_CHARACTERISTIC_UUID)
    
    private let PASSWORD_CHARACTERISTIC_UUID = CBUUID(string: CAR_BRIDGE_PASSWORD_CHARACTERISTIC_UUID)
    
    private let STATUS_CHARACTERISTIC_UUID = CBUUID(string: CAR_BRIDGE_STATUS_CHARACTERISTIC_UUID)
    
    
    // MARK: | Central Manager
    
    
    private lazy var centralManager: CBCentralManager = CBCentralManager(delegate: self, queue: dispatch_queue_create("ble_queue", DISPATCH_QUEUE_SERIAL))
    
    
    // MARK: | Starting
    
    
    var startBLE = false
    
    
    func start() {
        if self.centralManager.state == CBCentralManagerState.PoweredOn {
            self.centralManager.scanForPeripheralsWithServices([SERVICE_UUID], options: nil)
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
    
    func updateOBD2ValuesWithData(data: NSData) {
        preconditionFailure("Must be overridden in concrete subclass")
    }
    
    func executeCommandWithData(data: NSData) {
        preconditionFailure("Must be overridden in concrete subclass")
    }
}


extension CHBLEConnector: CBCentralManagerDelegate {
    
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch central.state {
            
        case CBCentralManagerState.Unknown:
            break
            
        case CBCentralManagerState.Resetting:
            break
            
        case CBCentralManagerState.Unsupported:
            break
            
        case CBCentralManagerState.Unauthorized:
            break
            
        case CBCentralManagerState.PoweredOff:
            break
            
        case CBCentralManagerState.PoweredOn:
            if (self.startBLE) {
                self.start()
            }
            break
            
        }
    }
    
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        if let localDeviceName = advertisementData[CBAdvertisementDataLocalNameKey] {
            if localDeviceName as! String == LOCAL_DEVICE_NAME {
                central.stopScan()
                self.delegate?.connectorDiscoveredOBD2Adapter(self)
                self.peripheral = peripheral
                centralManager.connectPeripheral(peripheral, options: nil)
            }
        }
    }
    
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices([SERVICE_UUID])
    }
    
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        central.connectPeripheral(peripheral, options: nil)
        self.delegate?.connectorLostConnection(self)
    }
}



extension CHBLEConnector: CBPeripheralDelegate {
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if error != nil {
            self.delegate?.connectorFailedConnecting(self)
            return
        }
        for service in peripheral.services! {
            if service.UUID == SERVICE_UUID {
                peripheral.discoverCharacteristics([], forService: service)
                return
            }
        }
    }
    
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if error != nil {
            self.delegate?.connectorFailedConnecting(self)
            return
        }
        for characteristic in service.characteristics! {
            if characteristic.UUID.UUIDString == CAR_BRIDGE_OBD2_CHARACTERISTIC_UUID {
                self.obd2Characteristic = characteristic
                peripheral.setNotifyValue(true, forCharacteristic: characteristic)
            }
            if characteristic.UUID.UUIDString == CAR_BRIDGE_COMMANDS_CHARACTERISTIC_UUID {
                self.commandsCharacteristic = characteristic
                peripheral.setNotifyValue(true, forCharacteristic: characteristic)
            }
            if characteristic.UUID.UUIDString == CAR_BRIDGE_PASSWORD_CHARACTERISTIC_UUID {
                self.passwordCharacteristic = characteristic
                peripheral.setNotifyValue(true, forCharacteristic: characteristic)
            }
            if characteristic.UUID.UUIDString == CAR_BRIDGE_STATUS_CHARACTERISTIC_UUID {
                self.statusCharacteristic = characteristic
                peripheral.setNotifyValue(true, forCharacteristic: characteristic)
            }
        }
    }
    
    
    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if let commands = self.commandsCharacteristic,
            obd2 = self.obd2Characteristic,
            password = self.passwordCharacteristic,
            status = self.statusCharacteristic {
            
            if commands.isNotifying &&
                obd2.isNotifying &&
                password.isNotifying &&
                status.isNotifying {
                self.delegate?.connectorEstablishedConnection(self)
                peripheral.writeValue(DEVICE_PASSWORD.dataUsingEncoding(NSUTF8StringEncoding)!, forCharacteristic: self.passwordCharacteristic, type: CBCharacteristicWriteType.WithResponse)
            }
        }
    }
    
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if let characteristicValue = characteristic.value {
            if characteristic.UUID.UUIDString == CAR_BRIDGE_OBD2_CHARACTERISTIC_UUID {
                updateOBD2ValuesWithData(characteristicValue)
            } else if characteristic.UUID.UUIDString == CAR_BRIDGE_COMMANDS_CHARACTERISTIC_UUID {
                executeCommandWithData(characteristicValue)
            } else if characteristic.UUID.UUIDString == CAR_BRIDGE_PASSWORD_CHARACTERISTIC_UUID {
                let result = NSNumber(unsignedChar: characteristic.value!.asUInt8)
                if result.boolValue {
                    self.delegate?.connectorAuthenticationSuccessful(self)
                }
            } else if characteristic.UUID.UUIDString == CAR_BRIDGE_STATUS_CHARACTERISTIC_UUID {
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

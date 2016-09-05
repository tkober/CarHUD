//
//  CHBLEConnector.swift
//  CarHud
//
//  Created by Thorsten Kober on 05/09/16.
//  Copyright © 2016 Thorsten Kober. All rights reserved.
//

import Foundation
import CoreBluetooth


protocol CHCHBLEConnectorDelegate {
    
    func connectorDiscoveredPFD(connector: CHBLEConnector)
    
    func connectorEstablishedConnection(connector: CHBLEConnector)
    
    func connectorFailedConnecting(connector: CHBLEConnector)
    
    func connectorLostConnection(connector: CHBLEConnector)
}


class CHBLEConnector: NSObject {
    
    
    var delegate: CHCHBLEConnectorDelegate?
    
    
    // MARK: | UUIDs
    
    private let SERVICE_UUID = CBUUID(string: CAR_BRIDGE_SERVICE_UUID)
    
    private let OBD2_CHARACTERISTIC_UUID = CBUUID(string: CAR_BRIDGE_OBD2_CHARACTERISTIC_UUID)
    
    private let COMMAND_CHARACTERISTIC_UUID = CBUUID(string: CAR_BRIDGE_COMMANDS_CHARACTERISTIC_UUID)
    
    
    // MARK: | Shared Instance
    
    class var sharedInstance : CHBLEConnector {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: CHBLEConnector? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = CHBLEConnector()
        }
        return Static.instance!
    }
    
    
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
        central.stopScan()
        self.delegate?.connectorDiscoveredPFD(self)
        self.peripheral = peripheral
        centralManager.connectPeripheral(peripheral, options: nil)
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
            if characteristic.UUID == CAR_BRIDGE_OBD2_CHARACTERISTIC_UUID {
                self.obd2Characteristic = characteristic
                peripheral.setNotifyValue(true, forCharacteristic: characteristic)
                return
            }
            if characteristic.UUID == CAR_BRIDGE_COMMANDS_CHARACTERISTIC_UUID {
                self.commandsCharacteristic = characteristic
                peripheral.setNotifyValue(true, forCharacteristic: characteristic)
                return
            }
        }
    }
    
    
    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        self.delegate?.connectorEstablishedConnection(self)
    }
    
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if let characteristicValue = characteristic.value {
            if characteristic.UUID == CAR_BRIDGE_OBD2_CHARACTERISTIC_UUID {
                updateOBD2ValuesWithData(characteristicValue)
            } else if characteristic.UUID == CAR_BRIDGE_COMMANDS_CHARACTERISTIC_UUID {
                executeCommandWithData(characteristicValue)
            }
        }
    }
}

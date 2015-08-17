//
//  CHOBD2Connector.swift
//  CarHud
//
//  Created by Thorsten Kober on 17.08.15.
//  Copyright (c) 2015 Thorsten Kober. All rights reserved.
//

import Foundation
import CoreBluetooth


typealias CHOBD2_PID = UInt8
typealias CHValueUpdate = (newValue: NSNumber) -> ();


class CHOBD2Connecor: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    
    // MARK: - Bluetooth
    // MARK: | Central Manager
    
    
    private lazy var centralManagerQueue: dispatch_queue_t = {
        return dispatch_queue_create("kober.thorsten.CarHUD.\(NSStringFromClass(self.classForCoder)).centralManagerQueue", nil)
    }()
    
    
    private lazy var centralManager: CBCentralManager = CBCentralManager(delegate: self, queue: self.centralManagerQueue)
    
    
    // MARK: | Peripheral
    
    
    private var UARTCharacteristic: CBCharacteristic?
    
    
    
    // MARK: - CBCentralManagerDelegate
    
    
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        // TODO
    }
    
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        // TODO
    }
    
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        // TODO
    }
    
    
    
    // MARK: - CBPeripheralDelegate
    
    
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        // TODO
    }
    
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        // TODO
    }
    
    
    func peripheral(peripheral: CBPeripheral!, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        // TODO
        if let data = characteristic.value {
            self.updateOBD2ValueWithData(data)
        }
    }
    
    
    
    // MARK: | OBD2 Value Updates
    
    
    func updateOBD2ValueWithData(data: NSData) {
        let parsedValues = CHOBD2Parser.parseData(data)
        for parsedValue in parsedValues.values {
            if let value = parsedValue.value {
                self.setValue(value, forPID: parsedValue.pid)
            }
        }
    }
    
    
    func setValue(value: NSNumber, forPID pid: CHOBD2_PID) {
        
    }
    
    
    
    // MARK: - OBD2 Values
    // MARK: | Speed
    
    
    internal var speed: NSNumber? {
        get {
            return self._speed
        }
    }
    
    
    internal var onSpeedUpdate: CHValueUpdate?
    
    
    // MARK: | RPM
    
    
    internal var rpm: NSNumber? {
        get {
            return self._rpm
        }
    }
    
    
    internal var onRPMUpdate: CHValueUpdate?
    
    
    // MARK: | Throttle
    
    
    internal var throttle: NSNumber? {
        get {
            return self._throttle
        }
    }
    
    
    internal var onThrottleUpdate: CHValueUpdate?
    
    
    // MARK: | Engine Load
    
    
    internal var engineLoad: NSNumber? {
        get {
            return self._engineLoad
        }
    }
    
    
    internal var onEngineLoadUpdate: CHValueUpdate?
    
    
    // MARK: | Coolant Temp
    
    
    internal var coolantTemp: NSNumber? {
        get {
            return self._coolantTemp
        }
    }
    
    
    internal var onCoolantTempUpdate: CHValueUpdate?
    
    
    // MARK: | Fuel Pressure
    
    
    internal var fuelPressure: NSNumber? {
        get {
            return self._fuelPressure
        }
    }
    
    
    internal var onFuelPressureUpdate: CHValueUpdate?
    
    
    // MARK: | Runtime
    
    
    internal var runtime: NSNumber? {
        get {
            return self._runtime
        }
    }
    
    
    internal var onRuntimeUpdate: CHValueUpdate?
    
    
    // MARK: | Fuel Rate
    
    
    internal var fuelLevel: NSNumber? {
        get {
            return self._fuelLevel
        }
    }
    
    
    internal var onFuelLevelUpdate: CHValueUpdate?
    
    
    // MARK: | Distance
    
    
    internal var distance: NSNumber? {
        get {
            return self._distance
        }
    }
    
    
    internal var onDistanceUpdate: CHValueUpdate?
    
    
    // MARK: | Control Module Voltage
    
    
    internal var controlModuleVoltage: NSNumber? {
        get {
            return self._controlModuleVoltage
        }
    }
    
    
    internal var onControlModuleVoltageUpdate: CHValueUpdate?
    
    
    // MARK: | Ambient Temp
    
    
    internal var ambientTemp: NSNumber? {
        get {
            return self._ambientTemp
        }
    }
    
    
    internal var onAmbientTempUpdate: CHValueUpdate?
    
    
    // MARK: | Eninge Oil Temp
    
    
    internal var engineOilTemp: NSNumber? {
        get {
            return self._engineOilTemp
        }
    }
    
    
    internal var onEngineOilTempUpdate: CHValueUpdate?
    
    
    // MARK: | Engine Fuel Rate
    
    
    internal var engineFuelRate: NSNumber? {
        get {
            return self._engineFuelRate
        }
    }
    
    
    internal var onEngineFuelRateUpdate: CHValueUpdate?
    
    
    
    // MARK: | Storage Variables
    
    
    
    private var _speed: NSNumber? {
        didSet {
            if let update = self.onSpeedUpdate {
                update(newValue: self.speed!)
            }
        }
    }
    
    
    private var _rpm: NSNumber? {
        didSet {
            if let update = self.onRPMUpdate {
                update(newValue: self.rpm!)
            }
        }
    }
    
    
    private var _throttle: NSNumber? {
        didSet {
            if let update = self.onThrottleUpdate {
                update(newValue: self.throttle!)
            }
        }
    }
    
    
    private var _engineLoad: NSNumber? {
        didSet {
            if let update = self.onEngineLoadUpdate {
                update(newValue: self.engineLoad!)
            }
        }
    }
    
    
    private var _coolantTemp: NSNumber? {
        didSet {
            if let update = self.onCoolantTempUpdate {
                update(newValue: self.coolantTemp!)
            }
        }
    }
    
    
    private var _fuelPressure: NSNumber? {
        didSet {
            if let update = self.onFuelPressureUpdate {
                update(newValue: self.fuelPressure!)
            }
        }
    }
    
    
    private var _runtime: NSNumber? {
        didSet {
            if let update = self.onRuntimeUpdate {
                update(newValue: self.runtime!)
            }
        }
    }
    
    
    private var _fuelLevel: NSNumber? {
        didSet {
            if let update = self.onFuelLevelUpdate {
                update(newValue: self.fuelLevel!)
            }
        }
    }
    
    
    private var _distance: NSNumber? {
        didSet {
            if let update = self.onDistanceUpdate {
                update(newValue: self.distance!)
            }
        }
    }
    
    
    private var _controlModuleVoltage: NSNumber? {
        didSet {
            if let update = self.onControlModuleVoltageUpdate {
                update(newValue: self.controlModuleVoltage!)
            }
        }
    }
    
    
    private var _ambientTemp: NSNumber? {
        didSet {
            if let update = self.onAmbientTempUpdate {
                update(newValue: self.ambientTemp!)
            }
        }
    }
    
    
    private var _engineOilTemp: NSNumber? {
        didSet {
            if let update = self.onEngineOilTempUpdate {
                update(newValue: self.engineOilTemp!)
            }
        }
    }
    
    
    private var _engineFuelRate: NSNumber? {
        didSet {
            if let update = self.onEngineFuelRateUpdate {
                update(newValue: self.engineFuelRate!)
            }
        }
    }
}
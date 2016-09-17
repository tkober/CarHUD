//
//  CarBridgeConnector.swift
//  CarHud
//
//  Created by Thorsten Kober on 17.08.15.
//  Copyright (c) 2015 Thorsten Kober. All rights reserved.
//

import Foundation
import CoreBluetooth


protocol CHCommandReceiver {
    
    func left()
    func right()
    func press()
    func longPress()
    
}


typealias CHOBD2_PID = Int32
typealias CHValueUpdate = (newValue: NSNumber) -> ();


class CHCarBridgeConnector: CHBLEConnector {
    
    // MARK: | Shared Instance
    
    class var sharedInstance : CHCarBridgeConnector {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: CHCarBridgeConnector? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = CHCarBridgeConnector()
        }
        return Static.instance!
    }
    
    
    // MARK: | OBD2 Value Updates
    
    
    override func updateOBD2ValuesWithData(data: NSData) {
        let parsedValues = CHOBD2Parser.parseData(data)
        for parsedValue in parsedValues.values {
            if let value = parsedValue.value {
                self.setValue(value, forPID: parsedValue.pid)
            }
        }
    }
    
    
    func setValue(value: NSNumber, forPID pid: CHOBD2_PID) {
        let blockSelf = self
        dispatch_async(dispatch_get_main_queue()) { 
            switch pid {
                
            case PID_SPEED:
                blockSelf._speed = value
                break
                
            case PID_RPM:
                blockSelf._rpm = value
                break
                
            case PID_THROTTLE:
                blockSelf._throttle = value
                break
                
            default:
                return
            }
        }
    }
    
    
    // MARK: | Commands
    
    var commandReceiver: CHCommandReceiver?
    
    
    override func executeCommandWithData(data: NSData) {
        let blockSelf = self
        dispatch_async(dispatch_get_main_queue()) { 
            let command = Int32(data.asUInt8)
            switch command {
                
            case LEFT:
                blockSelf.commandReceiver?.left()
                break
                
            case RIGHT:
                blockSelf.commandReceiver?.right()
                break
                
            case PRESS:
                blockSelf.commandReceiver?.press()
                break
                
            case LONG_PRESS:
                blockSelf.commandReceiver?.longPress()
                break
                
            default:
                return
            }
        }
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
    
    
    // MARK: | Intake Temp
    
    
    internal var intakeTemp: NSNumber? {
        get {
            return self._intakeTemp
        }
    }
    
    
    internal var onIntakeTempUpdate: CHValueUpdate?
    
    
    // MARK: | Intake MAP
    
    
    internal var intakeMAP: NSNumber? {
        get {
            return self._intakeMAP
        }
    }
    
    
    internal var onIntakeMAPUpdate: CHValueUpdate?
    
    
    
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
    
    
    private var _intakeTemp: NSNumber? {
        didSet {
            if let update = self.onIntakeTempUpdate {
                update(newValue: self.intakeTemp!)
            }
        }
    }
    
    
    private var _intakeMAP: NSNumber? {
        didSet {
            if let update = self.onIntakeMAPUpdate {
                update(newValue: self.intakeMAP!)
            }
        }
    }
}
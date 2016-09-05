//
//  CHOBD2.swift
//  CarHud
//
//  Created by Thorsten Kober on 17.08.15.
//  Copyright (c) 2015 Thorsten Kober. All rights reserved.
//

import Foundation


struct OBDValue {
    var pid: Int32
    var size: UInt8
}


/*
 *  PID     Name                        Size [Byte]
 *  0x0D    PID_SPEED                   1
 *  0x0C    PID_RPM                     2
 *  0x11    PID_THROTTLE                1
 */
let PRIMARY_OBD_VALUES: [OBDValue] = [
    OBDValue(pid: PID_SPEED, size:1),
    OBDValue(pid: PID_RPM, size:2),
    OBDValue(pid: PID_THROTTLE, size:1)
]
let OBD_VALUE_SPEED                 = PRIMARY_OBD_VALUES[0]
let OBD_VALUE_RPM                   = PRIMARY_OBD_VALUES[1]
let OBD_VALUE_THROTTLE              = PRIMARY_OBD_VALUES[2]

let LAST_PRIMARY_OBD_VALUE          = OBD_VALUE_THROTTLE


/*
 *  PID     Name                        Size [Byte]
 *  0x04    PID_ENGINE_LOAD             1
 *  0x05    PID_COOLANT_TEMP            1
 *  0x0A    PID_FUEL_PRESSURE           1
 *  0x1F    PID_RUNTIME                 2
 *  0x2F    PID_FUEL_LEVEL              1
 *  0x31    PID_DISTANCE                2
 *  0x42    PID_CONTROL_MODULE_VOLTAGE  2
 *  0x46    PID_AMBIENT_TEMP            1
 *  0x5C    PID_ENGINE_OIL_TEMP         1
 *  0x5E    PID_ENGAINE_FUEL_RATE       2
 */
let SECONDARY_OBD_VALUES: [OBDValue] = [
    OBDValue(pid: PID_ENGINE_LOAD, size:1),
    OBDValue(pid: PID_COOLANT_TEMP, size:1),
    OBDValue(pid: PID_FUEL_PRESSURE, size:1),
    OBDValue(pid: PID_RUNTIME, size:2),
    OBDValue(pid: PID_FUEL_LEVEL, size:1),
    OBDValue(pid: PID_DISTANCE, size:2),
    OBDValue(pid: PID_CONTROL_MODULE_VOLTAGE, size:2),
    OBDValue(pid: PID_AMBIENT_TEMP, size:1),
    OBDValue(pid: PID_ENGINE_OIL_TEMP, size:1),
    OBDValue(pid: PID_ENGINE_FUEL_RATE, size:2)
]
let OBD_VALUE_ENGINE_LOAD               = SECONDARY_OBD_VALUES[0]
let OBD_VALUE_COOLANT_TEMP              = SECONDARY_OBD_VALUES[1]
let OBD_VALUE_FUEL_PRESSURE             = SECONDARY_OBD_VALUES[2]
let OBD_VALUE_RUNTIME                   = SECONDARY_OBD_VALUES[3]
let OBD_VALUE_FUEL_LEVEL                = SECONDARY_OBD_VALUES[4]
let OBD_VALUE_DISTANCE                  = SECONDARY_OBD_VALUES[5]
let OBD_VALUE_CONTROL_MODULE_VOLTAGE    = SECONDARY_OBD_VALUES[6]
let OBD_VALUE_AMBIENT_TEMP              = SECONDARY_OBD_VALUES[7]
let OBD_VALUE_ENGINE_OIL_TEMP           = SECONDARY_OBD_VALUES[8]
let OBD_VALUE_ENGINE_FUEL_RATE          = SECONDARY_OBD_VALUES[9]

let LAST_SECONDARY_OBD_VALUE            = OBD_VALUE_ENGINE_FUEL_RATE

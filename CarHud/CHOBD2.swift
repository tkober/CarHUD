//
//  CHOBD2.swift
//  CarHud
//
//  Created by Thorsten Kober on 17.08.15.
//  Copyright (c) 2015 Thorsten Kober. All rights reserved.
//

import Foundation


// Mode 1 PIDs
let PID_ENGINE_LOAD: UInt8                     = 0x04
let PID_COOLANT_TEMP: UInt8                    = 0x05
let PID_SHORT_TERM_FUEL_TRIM_1: UInt8          = 0x06
let PID_LONG_TERM_FUEL_TRIM_1: UInt8           = 0x07
let PID_SHORT_TERM_FUEL_TRIM_2: UInt8          = 0x08
let PID_LONG_TERM_FUEL_TRIM_2: UInt8           = 0x09
let PID_FUEL_PRESSURE: UInt8                   = 0x0A
let PID_INTAKE_MAP: UInt8                      = 0x0B
let PID_RPM: UInt8                             = 0x0C
let PID_SPEED: UInt8                           = 0x0D
let PID_TIMING_ADVANCE: UInt8                  = 0x0E
let PID_INTAKE_TEMP: UInt8                     = 0x0F
let PID_MAF_FLOW: UInt8                        = 0x10
let PID_THROTTLE: UInt8                        = 0x11
let PID_AUX_INPUT: UInt8                       = 0x1E
let PID_RUNTIME: UInt8                         = 0x1F
let PID_DISTANCE_WITH_MIL: UInt8               = 0x21
let PID_COMMANDED_EGR: UInt8                   = 0x2C
let PID_EGR_ERROR: UInt8                       = 0x2D
let PID_COMMANDED_EVAPORATIVE_PURGE: UInt8     = 0x2E
let PID_FUEL_LEVEL: UInt8                      = 0x2F
let PID_WARMS_UPS: UInt8                       = 0x30
let PID_DISTANCE: UInt8                        = 0x31
let PID_EVAP_SYS_VAPOR_PRESSURE: UInt8         = 0x32
let PID_BAROMETRIC: UInt8                      = 0x33
let PID_CATALYST_TEMP_B1S1: UInt8              = 0x3C
let PID_CATALYST_TEMP_B2S1: UInt8              = 0x3D
let PID_CATALYST_TEMP_B1S2: UInt8              = 0x3E
let PID_CATALYST_TEMP_B2S2: UInt8              = 0x3F
let PID_CONTROL_MODULE_VOLTAGE: UInt8          = 0x42
let PID_ABSOLUTE_ENGINE_LOAD: UInt8            = 0x43
let PID_RELATIVE_THROTTLE_POS: UInt8           = 0x45
let PID_AMBIENT_TEMP: UInt8                    = 0x46
let PID_ABSOLUTE_THROTTLE_POS_B: UInt8         = 0x47
let PID_ABSOLUTE_THROTTLE_POS_C: UInt8         = 0x48
let PID_ACC_PEDAL_POS_D: UInt8                 = 0x49
let PID_ACC_PEDAL_POS_E: UInt8                 = 0x4A
let PID_ACC_PEDAL_POS_F: UInt8                 = 0x4B
let PID_COMMANDED_THROTTLE_ACTUATOR: UInt8     = 0x4C
let PID_TIME_WITH_MIL: UInt8                   = 0x4D
let PID_TIME_SINCE_CODES_CLEARED: UInt8        = 0x4E
let PID_ETHANOL_FUEL: UInt8                    = 0x52
let PID_FUEL_RAIL_PRESSURE: UInt8              = 0x59
let PID_HYBRID_BATTERY_PERCENTAGE: UInt8       = 0x5B
let PID_ENGINE_OIL_TEMP: UInt8                 = 0x5C
let PID_FUEL_INJECTION_TIMING: UInt8           = 0x5D
let PID_ENGINE_FUEL_RATE: UInt8                = 0x5E
let PID_ENGINE_TORQUE_DEMANDED: UInt8          = 0x61
let PID_ENGINE_TORQUE_PERCENTAGE: UInt8        = 0x62
let PID_ENGINE_REF_TORQUE: UInt8               = 0x63


struct OBDValue {
    var pid: UInt8
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

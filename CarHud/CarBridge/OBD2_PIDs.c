//
//  OBD2.h
//  CarBridge
//
//  Created by Thorsten Kober on 30.07.15.
//  Copyright (c) 2015 Thorsten Kober. All rights reserved.
//

#include "OBD2_PIDs.h"

// Mode 1 PIDs
const uint8_t PID_ENGINE_LOAD = 0x04;
const uint8_t PID_COOLANT_TEMP = 0x05;
const uint8_t PID_SHORT_TERM_FUEL_TRIM_1 = 0x06;
const uint8_t PID_LONG_TERM_FUEL_TRIM_1 = 0x07;
const uint8_t PID_SHORT_TERM_FUEL_TRIM_2 = 0x08;
const uint8_t PID_LONG_TERM_FUEL_TRIM_2 = 0x09;
const uint8_t PID_FUEL_PRESSURE = 0x0A;
const uint8_t PID_uint8_tAKE_MAP = 0x0B;
const uint8_t PID_RPM = 0x0C;
const uint8_t PID_SPEED = 0x0D;
const uint8_t PID_TIMING_ADVANCE = 0x0E;
const uint8_t PID_uint8_tAKE_TEMP = 0x0F;
const uint8_t PID_MAF_FLOW = 0x10;
const uint8_t PID_THROTTLE = 0x11;
const uint8_t PID_AUX_INPUT = 0x1E;
const uint8_t PID_RUNTIME = 0x1F;
const uint8_t PID_DISTANCE_WITH_MIL = 0x21;
const uint8_t PID_COMMANDED_EGR = 0x2C;
const uint8_t PID_EGR_ERROR = 0x2D;
const uint8_t PID_COMMANDED_EVAPORATIVE_PURGE = 0x2E;
const uint8_t PID_FUEL_LEVEL = 0x2F;
const uint8_t PID_WARMS_UPS = 0x30;
const uint8_t PID_DISTANCE = 0x31;
const uint8_t PID_EVAP_SYS_VAPOR_PRESSURE = 0x32;
const uint8_t PID_BAROMETRIC = 0x33;
const uint8_t PID_CATALYST_TEMP_B1S1 = 0x3C;
const uint8_t PID_CATALYST_TEMP_B2S1 = 0x3D;
const uint8_t PID_CATALYST_TEMP_B1S2 = 0x3E;
const uint8_t PID_CATALYST_TEMP_B2S2 = 0x3F;
const uint8_t PID_CONTROL_MODULE_VOLTAGE = 0x42;
const uint8_t PID_ABSOLUTE_ENGINE_LOAD = 0x43;
const uint8_t PID_RELATIVE_THROTTLE_POS = 0x45;
const uint8_t PID_AMBIENT_TEMP = 0x46;
const uint8_t PID_ABSOLUTE_THROTTLE_POS_B = 0x47;
const uint8_t PID_ABSOLUTE_THROTTLE_POS_C = 0x48;
const uint8_t PID_ACC_PEDAL_POS_D = 0x49;
const uint8_t PID_ACC_PEDAL_POS_E = 0x4A;
const uint8_t PID_ACC_PEDAL_POS_F = 0x4B;
const uint8_t PID_COMMANDED_THROTTLE_ACTUATOR = 0x4C;
const uint8_t PID_TIME_WITH_MIL = 0x4D;
const uint8_t PID_TIME_SINCE_CODES_CLEARED = 0x4E;
const uint8_t PID_ETHANOL_FUEL = 0x52;
const uint8_t PID_FUEL_RAIL_PRESSURE = 0x59;
const uint8_t PID_HYBRID_BATTERY_PERCENTAGE = 0x5B;
const uint8_t PID_ENGINE_OIL_TEMP = 0x5C;
const uint8_t PID_FUEL_INJECTION_TIMING = 0x5D;
const uint8_t PID_ENGINE_FUEL_RATE = 0x5E;
const uint8_t PID_ENGINE_TORQUE_DEMANDED = 0x61;
const uint8_t PID_ENGINE_TORQUE_PERCENTAGE = 0x62;
const uint8_t PID_ENGINE_REF_TORQUE = 0x63;
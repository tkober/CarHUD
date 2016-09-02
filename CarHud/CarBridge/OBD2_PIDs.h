//
//  OBD2.h
//  CarBridge
//
//  Created by Thorsten Kober on 30.07.15.
//  Copyright (c) 2015 Thorsten Kober. All rights reserved.
//

#ifndef OBD2_PIDs
#define OBD2_PIDs

#include <stdlib.h>

// Mode 1 PIDs
extern const uint8_t PID_ENGINE_LOAD;
extern const uint8_t PID_COOLANT_TEMP;
extern const uint8_t PID_SHORT_TERM_FUEL_TRIM_1;
extern const uint8_t PID_LONG_TERM_FUEL_TRIM_1;
extern const uint8_t PID_SHORT_TERM_FUEL_TRIM_2;
extern const uint8_t PID_LONG_TERM_FUEL_TRIM_2;
extern const uint8_t PID_FUEL_PRESSURE;
extern const uint8_t PID_uint8_tAKE_MAP;
extern const uint8_t PID_RPM;
extern const uint8_t PID_SPEED;
extern const uint8_t PID_TIMING_ADVANCE;
extern const uint8_t PID_uint8_tAKE_TEMP;
extern const uint8_t PID_MAF_FLOW;
extern const uint8_t PID_THROTTLE;
extern const uint8_t PID_AUX_INPUT;
extern const uint8_t PID_RUNTIME;
extern const uint8_t PID_DISTANCE_WITH_MIL;
extern const uint8_t PID_COMMANDED_EGR;
extern const uint8_t PID_EGR_ERROR;
extern const uint8_t PID_COMMANDED_EVAPORATIVE_PURGE;
extern const uint8_t PID_FUEL_LEVEL;
extern const uint8_t PID_WARMS_UPS;
extern const uint8_t PID_DISTANCE;
extern const uint8_t PID_EVAP_SYS_VAPOR_PRESSURE;
extern const uint8_t PID_BAROMETRIC;
extern const uint8_t PID_CATALYST_TEMP_B1S1;
extern const uint8_t PID_CATALYST_TEMP_B2S1;
extern const uint8_t PID_CATALYST_TEMP_B1S2;
extern const uint8_t PID_CATALYST_TEMP_B2S2;
extern const uint8_t PID_CONTROL_MODULE_VOLTAGE;
extern const uint8_t PID_ABSOLUTE_ENGINE_LOAD;
extern const uint8_t PID_RELATIVE_THROTTLE_POS;
extern const uint8_t PID_AMBIENT_TEMP;
extern const uint8_t PID_ABSOLUTE_THROTTLE_POS_B;
extern const uint8_t PID_ABSOLUTE_THROTTLE_POS_C;
extern const uint8_t PID_ACC_PEDAL_POS_D;
extern const uint8_t PID_ACC_PEDAL_POS_E;
extern const uint8_t PID_ACC_PEDAL_POS_F;
extern const uint8_t PID_COMMANDED_THROTTLE_ACTUATOR;
extern const uint8_t PID_TIME_WITH_MIL;
extern const uint8_t PID_TIME_SINCE_CODES_CLEARED;
extern const uint8_t PID_ETHANOL_FUEL;
extern const uint8_t PID_FUEL_RAIL_PRESSURE;
extern const uint8_t PID_HYBRID_BATTERY_PERCENTAGE;
extern const uint8_t PID_ENGINE_OIL_TEMP;
extern const uint8_t PID_FUEL_INJECTION_TIMING;
extern const uint8_t PID_ENGINE_FUEL_RATE;
extern const uint8_t PID_ENGINE_TORQUE_DEMANDED;
extern const uint8_t PID_ENGINE_TORQUE_PERCENTAGE;
extern const uint8_t PID_ENGINE_REF_TORQUE;

#endif
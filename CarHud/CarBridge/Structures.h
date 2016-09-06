#ifndef STRUCTURES_H
#define STRUCTURES_H


struct OBDValue {
    uint8_t pid;
    uint8_t size;
};
typedef struct OBDValue OBDValue;
#define OBDValueMake(pid, size)     (OBDValue){pid, size}


/*
 *  PID     Name                        Size [Byte]
 *  0x0D    PID_SPEED                   1
 *  0x0C    PID_RPM                     2
 *  0x11    PID_THROTTLE                1
 */
const OBDValue PRIMARY_OBD_VALUES[] = {
    OBDValueMake(PID_SPEED, 1),
    OBDValueMake(PID_RPM, 2),
    OBDValueMake(PID_THROTTLE, 1)
};
#define LAST_PRIMARY_OBD_VALUE      PRIMARY_OBD_VALUES+2


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
 *  0x5E    PID_ENGINE_FUEL_RATE        2
 */
const OBDValue SECONDARY_OBD_VALUES[] = {
    OBDValueMake(PID_ENGINE_LOAD, 1),
    OBDValueMake(PID_COOLANT_TEMP, 1),
    OBDValueMake(PID_FUEL_PRESSURE, 1),
    OBDValueMake(PID_RUNTIME, 2),
    OBDValueMake(PID_FUEL_LEVEL, 1),
    OBDValueMake(PID_DISTANCE, 2),
    OBDValueMake(PID_CONTROL_MODULE_VOLTAGE, 2),
    OBDValueMake(PID_AMBIENT_TEMP, 1),
    OBDValueMake(PID_ENGINE_OIL_TEMP, 1),
    OBDValueMake(PID_ENGINE_FUEL_RATE, 2)
};
#define LAST_SECONDARY_OBD_VALUE    SECONDARY_OBD_VALUES+9


#endif

#include <CurieBLE.h>
#include <Wire.h>

#include "OBD2_PIDs.h"
#include "RemoteControl/Commands.h"
#include "Pins.h"
#include "BLE.h"
#include "Structures.h"
#include "Colors.h"

#define BT_MESSAGE_SIZE     20
#define BT_MESSAGE_BORDER   BT_MESSAGE_SIZE-1

//////////////////////////////////////////////////////////////////////////////////////////
// Simulated Bus
//////////////////////////////////////////////////////////////////////////////////////////
uint8_t simulatedBus[] = {
    // PID_SPEED                            0
    0x01,
    // PID_RPM                              1
    0x00, 0x02,
    // PID_THROTTLE                         3
    0x03,
    // PID_ENGINE_LOAD                      4
    0x04,
    // PID_COOLANT_TEMP                     5
    0x05,
    // PID_FUEL_PRESSURE                    6
    0x06,
    // PID_RUNTIME                          7
    0x00, 0x07,
    // PID_FUEL_LEVEL                       9
    0x08,
    // PID_DISTANCE                         10
    0x00, 0x09,
    // PID_CONTROL_MODULE_VOLTAGE           12
    0x00, 0x0A,
    // PID_AMBIENT_TEMP                     14
    0x0B,
    // PID_ENGINE_OIL_TEMP                  15
    0x0C,
    // PID_ENGINE_FUEL_RATE                 16
    0x00, 0x0D
};

uint8_t simulated_bus_address_for_pid(uint8_t pid);
//////////////////////////////////////////////////////////////////////////////////////////

BLEPeripheral blePeripheral;       
BLEService carBridgeService = BLEService(CAR_BRIDGE_SERVICE_UUID); 
BLECharacteristic obd2Characteristic = BLECharacteristic(CAR_BRIDGE_OBD2_CHARACTERISTIC_UUID, BLERead | BLENotify, BT_MESSAGE_SIZE);
BLECharacteristic commandsCharacteristic = BLECharacteristic(CAR_BRIDGE_COMMANDS_CHARACTERISTIC_UUID, BLERead | BLENotify, BT_MESSAGE_SIZE);

void reset_message(uint8_t *message, int size);
int copy_obd_values_to_message(OBDValue *obd_values, int index, OBDValue *last_obd_value, uint8_t **message, uint8_t *message_bound);
int read_obd_value(OBDValue value, int *result);
void send_message(uint8_t *message, int size);

void send_command(uint8_t command);

void set_status_led(COLOR color);

void setup() {
  // Setup BLE Peripheral
  blePeripheral.setLocalName(LOCAL_DEVICE_NAME);
  blePeripheral.setAdvertisedServiceUuid(carBridgeService.uuid());  
  blePeripheral.addAttribute(carBridgeService);
  blePeripheral.addAttribute(obd2Characteristic);   
  blePeripheral.addAttribute(commandsCharacteristic);
  blePeripheral.begin();

  Wire.begin();

  pinMode(STATUS_LED_R, OUTPUT);
  pinMode(STATUS_LED_G, OUTPUT);
  pinMode(STATUS_LED_B, OUTPUT);

  Serial.begin(9600);
}

void loop() {
  uint8_t message_memory[BT_MESSAGE_SIZE];
  reset_message(message_memory, BT_MESSAGE_SIZE);
  int OBD_VALUE_INDEX = 0;
  set_status_led(RED);
  
  BLECentral central = blePeripheral.central();
  if (central) {
    set_status_led(GREEN);
    
    while(central.connected()) {
      Wire.requestFrom(0x0F, 1); 
      uint8_t command = Wire.read();
      if (command != EMPTY_COMMAND) {
        send_command(command);
      }
      
      uint8_t *message = message_memory;
      int status = copy_obd_values_to_message((OBDValue *)PRIMARY_OBD_VALUES, 0, (OBDValue *)LAST_PRIMARY_OBD_VALUE, &message, message+BT_MESSAGE_BORDER);
      if (status > 0) {
        central.disconnect();
      }
      OBD_VALUE_INDEX = copy_obd_values_to_message((OBDValue *)SECONDARY_OBD_VALUES, OBD_VALUE_INDEX, (OBDValue *)LAST_SECONDARY_OBD_VALUE, &message, message_memory+BT_MESSAGE_BORDER);
      OBD_VALUE_INDEX = OBD_VALUE_INDEX > 0 ? OBD_VALUE_INDEX : 0;

      send_message(message_memory, BT_MESSAGE_SIZE);
      reset_message(message_memory, BT_MESSAGE_SIZE);
    }
  }
}

// OBD2

void reset_message(uint8_t *message, int size) {
    for (int i = 0; i < size; i++) {
        message[i] = 0x00;
    }
}

int copy_obd_values_to_message(OBDValue *obd_values, int index, OBDValue *last_obd_value, uint8_t **message, uint8_t *message_bound) {
    OBDValue *currentOBDValue = obd_values;
    currentOBDValue += index;
    while (currentOBDValue <= last_obd_value) {
        // Check remaining message capacity
        uint8_t *new_size = *message + 1 + currentOBDValue->size;
        if (new_size > message_bound) {
            return index;
        }
        
        // Copy the PID
        memcpy(*message, currentOBDValue, 1);
        (*message)++;
        
        // Copy the value for the PID
        int value = 0;
        read_obd_value(*currentOBDValue, &value);
        memcpy(*message, &value, currentOBDValue->size);
        (*message) += currentOBDValue->size;
        
        // Next OBD Value
        currentOBDValue++;
        index++;
    }
    return -1;
}

int read_obd_value(OBDValue value, int *result) {
  memcpy(result, simulatedBus+simulated_bus_address_for_pid(value.pid), value.size);
  return 1;
}

void send_message(uint8_t *message, int size) {
  obd2Characteristic.setValue(message, size);
}

void send_command(uint8_t command) {
  const unsigned char value[] = { command };
  commandsCharacteristic.setValue(value, 1);
}

void set_status_led(COLOR color) {
  analogWrite(STATUS_LED_R, color.r * 4);
  analogWrite(STATUS_LED_G, color.g * 4);
  analogWrite(STATUS_LED_B, color.b * 4);
}


//////////////////////////////////////////////////////////////////////////////////////////
// Simulated Bus
//////////////////////////////////////////////////////////////////////////////////////////
uint8_t simulated_bus_address_for_pid(uint8_t pid) {
    switch (pid) {
        case PID_SPEED:
            return 0;
            
        case PID_RPM:
            return 1;
            
        case PID_THROTTLE:
            return 3;
            
        case PID_ENGINE_LOAD:
            return 4;
            
        case PID_COOLANT_TEMP:
            return 5;
            
        case PID_FUEL_PRESSURE:
            return 6;
            
        case PID_RUNTIME:
            return 7;
            
        case PID_FUEL_LEVEL:
            return 9;
            
        case PID_DISTANCE:
            return 10;
            
        case PID_CONTROL_MODULE_VOLTAGE:
            return 12;
            
        case PID_AMBIENT_TEMP:
            return 14;
            
        case PID_ENGINE_OIL_TEMP:
            return 15;
            
        case PID_ENGINE_FUEL_RATE:
            return 16;
            
        default:
            return 1;
    }
}
//////////////////////////////////////////////////////////////////////////////////////////

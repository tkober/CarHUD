#include <CurieBLE.h>
#include <Wire.h>
#include <string.h>

#include "OBD2_PIDs.h"
#include "RemoteControl/Commands.h"
#include "Pins.h"
#include "BLE.h"
#include "Structures.h"
#include "Colors.h"
#include "OBD.h"
#include "Status.h"

#define BT_MESSAGE_SIZE     20
#define BT_MESSAGE_BORDER   BT_MESSAGE_SIZE-1

BLEPeripheral blePeripheral;
BLEService carBridgeService = BLEService(CAR_BRIDGE_SERVICE_UUID);
BLECharacteristic obd2Characteristic = BLECharacteristic(CAR_BRIDGE_OBD2_CHARACTERISTIC_UUID, BLERead | BLENotify, BT_MESSAGE_SIZE);
BLECharacteristic commandsCharacteristic = BLECharacteristic(CAR_BRIDGE_COMMANDS_CHARACTERISTIC_UUID, BLERead | BLENotify, BT_MESSAGE_SIZE);
BLECharacteristic passwordCharacteristic = BLECharacteristic(CAR_BRIDGE_PASSWORD_CHARACTERISTIC_UUID, BLERead | BLEWrite | BLENotify, PASSWORD_SIZE);
BLECharacteristic statusCharacteristic = BLECharacteristic(CAR_BRIDGE_STATUS_CHARACTERISTIC_UUID, BLERead | BLENotify, STATUS_SIZE);

int authenticated = 0;

COBDI2C obd;

void reset_message(uint8_t *message, int size);
int copy_obd_values_to_message(OBDValue *obd_values, int index, OBDValue *last_obd_value, uint8_t **message, uint8_t *message_bound);
int read_obd_value(OBDValue obdValue, int *success);
void send_message(uint8_t *message, int size);
void confirm_authentication();
void password_written(BLECentral &central, BLECharacteristic &characteristic);
void update_status(uint8_t status);

void send_command(uint8_t command);

void set_status_led(COLOR color);

void setup() {
  // Setup BLE Peripheral
  blePeripheral.setLocalName(LOCAL_DEVICE_NAME);
  blePeripheral.setAdvertisedServiceUuid(carBridgeService.uuid());
  blePeripheral.addAttribute(carBridgeService);
  blePeripheral.addAttribute(obd2Characteristic);
  blePeripheral.addAttribute(commandsCharacteristic);
  blePeripheral.addAttribute(passwordCharacteristic);
  blePeripheral.addAttribute(statusCharacteristic);
  
  passwordCharacteristic.setEventHandler(BLEWritten, password_written);
  
  const unsigned char initialStatus[] = { STATUS_SERVICE_STOPPED };
  statusCharacteristic.setValue(initialStatus, 1);
  
  blePeripheral.begin();

  Wire.begin();

  pinMode(STATUS_LED_R, OUTPUT);
  pinMode(STATUS_LED_G, OUTPUT);
  pinMode(STATUS_LED_B, OUTPUT);

  Serial.begin(9600);
  /*while (!Serial.available()) {
    Serial.println("ready to start");
    }

    for (int i = 0; i < PID_COUNT; i++) {
    uint8_t pid = ALL_PIDS[i];
    Serial.print("pid[");
    Serial.print(pid);
    Serial.print("] -> ");
    int result = 0;
    if (!obd.isValidPID(pid)) {
      Serial.println("invalid");
    } else {
      bool success = obd.readPID(pid, result);
      if (success) {
        Serial.println(result);
      } else {
        Serial.println("error");
      }
    }
    }

    char buffer[64];
    obd.write("0101\r");
    Serial.print("success -> ");
    Serial.println(obd.receive(buffer, 1000));
    Serial.print("dtc -> ");
    Serial.println(buffer);

    while (1);*/
}

void loop() {
  uint8_t message_memory[BT_MESSAGE_SIZE];
  reset_message(message_memory, BT_MESSAGE_SIZE);
  int OBD_VALUE_INDEX = 0;
  set_status_led(RED);

  // Connecting
  BLECentral central = blePeripheral.central();
  if (central && central.connected()) {

    // Authentication
    long connectedTime = millis();
    while (!authenticated) {
      long waiting = millis() - connectedTime;
      if (waiting > AUTHENTICATION_TIMEOUT) {
        goto DISCONNECT;
      }
      blePeripheral.poll();
    }
    
    const char *password = (const char *)passwordCharacteristic.value();
    if (strncmp(password, DEVICE_PASSWORD, passwordCharacteristic.valueSize()) == 0) {
      Serial.println("authenticated");
      confirm_authentication();
      set_status_led(GREEN);

      obd.begin();
      while (!obd.init());
      update_status(STATUS_SERVICE_STARTED);
      while (central.connected()) {
        Wire.requestFrom(0x0F, 1);
        uint8_t command = Wire.read();
        if (command != EMPTY_COMMAND) {
          send_command(command);
        }

        uint8_t *message = message_memory;
        int status = copy_obd_values_to_message((OBDValue *)PRIMARY_OBD_VALUES, 0, (OBDValue *)LAST_PRIMARY_OBD_VALUE, &message, message + BT_MESSAGE_BORDER);
        if (status > 0) {
          goto DISCONNECT;
        }
        //OBD_VALUE_INDEX = copy_obd_values_to_message((OBDValue *)SECONDARY_OBD_VALUES, OBD_VALUE_INDEX, (OBDValue *)LAST_SECONDARY_OBD_VALUE, &message, message_memory+BT_MESSAGE_BORDER);
        OBD_VALUE_INDEX = OBD_VALUE_INDEX > 0 ? OBD_VALUE_INDEX : 0;

        send_message(message_memory, BT_MESSAGE_SIZE);
        reset_message(message_memory, BT_MESSAGE_SIZE);
      }
      goto DISCONNECT;  
    }
  }
  return;
  DISCONNECT: 
    central.disconnect();
    authenticated = 0;
    obd.end();
    update_status(STATUS_SERVICE_STOPPED);
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
    int success;
    int value = read_obd_value(*currentOBDValue, &success);
    memcpy(*message, &value, currentOBDValue->size);
    (*message) += currentOBDValue->size;

    // Next OBD Value
    currentOBDValue++;
    index++;
  }
  return -1;
}

int read_obd_value(OBDValue obdValue, int *success) {
  int result = 0;
  if (obd.isValidPID(obdValue.pid)) {
    *success = obd.readPID(obdValue.pid, result);
  }
  return result;
}

void send_message(uint8_t *message, int size) {
  obd2Characteristic.setValue(message, size);
}

void confirm_authentication() {
  const unsigned char confirmation[] = { 0x01 };
  passwordCharacteristic.setValue(confirmation, 1);
}

void send_command(uint8_t command) {
  const unsigned char value[] = { command };
  commandsCharacteristic.setValue(value, 1);
}

void update_status(uint8_t status) {
  const unsigned char value[] = { status };
  statusCharacteristic.setValue(value, 1);
}

void set_status_led(COLOR color) {
  analogWrite(STATUS_LED_R, color.r * 4);
  analogWrite(STATUS_LED_G, color.g * 4);
  analogWrite(STATUS_LED_B, color.b * 4);
}

void password_written(BLECentral &central, BLECharacteristic &characteristic) {
  authenticated = 1;
}


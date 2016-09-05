#include <BLEAttribute.h>
#include <BLECentral.h>
#include <BLECharacteristic.h>
#include <BLECommon.h>
#include <BLEDescriptor.h>
#include <BLEPeripheral.h>
#include <BLEService.h>
#include <BLETypedCharacteristic.h>
#include <BLETypedCharacteristics.h>
#include <BLEUuid.h>
#include <CurieBLE.h>

#include "OBD2_PIDs.h"
#include "Commands.h"
#include "Pins.h"
#include "Button.h"
#include "RotaryEncoder.h"
#include "BLE.h"

BLEPeripheral blePeripheral;       
BLEService carBridgeService = BLEService(CAR_BRIDGE_SERVICE_UUID); 
BLECharacteristic obd2Characteristic = BLECharacteristic(CAR_BRIDGE_OBD2_CHARACTERISTIC_UUID, BLERead | BLENotify, 20);
BLECharacteristic commandsCharacteristic = BLECharacteristic(CAR_BRIDGE_COMMANDS_CHARACTERISTIC_UUID, BLERead | BLENotify, 20);

PushableRotaryEncoder controlKnob = PushableRotaryEncoder(CONTROL_KNOB_ENCODER_PIN_A, CONTROL_KNOB_ENCODER_PIN_B, CONTROL_KNOB_BUTTON_PIN, 1);

void knob_left(int boost);
void knob_right(int boost);
void knob_press();

void send_command(const unsigned char command);


void setup() {
  // Setting up control knob
  controlKnob.setOnRotateClockwise(knob_right);
  controlKnob.setOnRotateCounterClockwise(knob_left);
  controlKnob.setOnClick(knob_press);

  // Setup BLE Peripheral
  blePeripheral.setLocalName("CarBridge");
  blePeripheral.setAdvertisedServiceUuid(carBridgeService.uuid());  
  blePeripheral.addAttribute(obd2Characteristic);   
  blePeripheral.addAttribute(commandsCharacteristic);
  blePeripheral.begin();
}

void loop() {
  BLECentral central = blePeripheral.central();
  if (central) {
    digitalWrite(ON_BOARD_LED, HIGH);
    
    while(central.connected()) {
      controlKnob.tick();
      // TODO: OBD2 values
    }

    digitalWrite(ON_BOARD_LED, LOW);
  }
}


// Private
void knob_left(int boost) {
  send_command(LEFT);
}

void knob_right(int boost) {
  send_command(RIGHT);
}

void knob_press() {
  send_command(PRESS);
}

void send_command(const unsigned char command) {
  const unsigned char value[] = { command };
  commandsCharacteristic.setValue(value, 1);
}







#include <Wire.h>

#include "Commands.h"
#include "Pins.h"
#include "Button.h"
#include "RotaryEncoder.h"

#define I2C_ADDRESS   0x0F

PushableRotaryEncoder controlKnob = PushableRotaryEncoder(CONTROL_KNOB_ENCODER_PIN_A, CONTROL_KNOB_ENCODER_PIN_B, CONTROL_KNOB_BUTTON_PIN, 1);

unsigned char currentCommand = EMPTY_COMMAND;

void knob_left(int boost);
void knob_right(int boost);
void knob_press();
void knob_long_press();
void send_command(const unsigned char command);


void setup() {
  // Setting up control knob
  controlKnob.setOnRotateClockwise(knob_right);
  controlKnob.setOnRotateCounterClockwise(knob_left);
  controlKnob.setOnClick(knob_press);
  controlKnob.setOnLongPress(knob_long_press);

  Wire.begin(I2C_ADDRESS);
  Wire.onRequest(requestEvent);
  pinMode(13, OUTPUT);
}

void loop() {
  controlKnob.tick();
}

void requestEvent() {
  if (currentCommand != EMPTY_COMMAND) {
    Wire.write(currentCommand);
    currentCommand = EMPTY_COMMAND;
  }
}


// Commands

void knob_left(int boost) {
  send_command(LEFT);
}

void knob_right(int boost) {
  send_command(RIGHT);
}

void knob_press() {
  send_command(PRESS);
}

void knob_long_press() {
  send_command(LONG_PRESS);
}

void send_command(const unsigned char command) {
  if (currentCommand == EMPTY_COMMAND) {
    currentCommand = command;
  }
}

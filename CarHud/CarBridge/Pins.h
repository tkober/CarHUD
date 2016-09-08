#ifndef PINS_H
#define PINS_H

#define ANALOG_PIN(_pin)              (_pin+14)

// Board
#define ON_BOARD_LED                  13

/**
 * Status LED
 *   /| \
 *  / |  \\
 * |  |  | |
 * G GND B R
 */
#define STATUS_LED_R                  6
#define STATUS_LED_G                  3
#define STATUS_LED_B                  5

#endif

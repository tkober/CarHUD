#include "RotaryEncoder.h"

#define LATCHSTATE                          3
#define DEFAULT_DEBOUNCE_FILTER             200
#define DEFAULT_BOOST_ACTIVATION_COUNT      15
#define DEFAULT_BOOST_ACTIVATION_INTERVAL   500


const int8_t KNOBDIR[] = {
  0, -1,  1,  0,
  1,  0,  0, -1,
  -1,  0,  0,  1,
  0,  1, -1,  0
};


PushableRotaryEncoder::PushableRotaryEncoder(int rotaryPinA, int rotaryPinB, int buttonPin, int pullUp) {
  _rotaryPinA = rotaryPinA;
  _rotaryPinB = rotaryPinB;
  _buttonPin = buttonPin;
  _pullUp = pullUp;
  _button = Button(buttonPin, pullUp);
  pinMode(rotaryPinA, pullUp == 1 ? INPUT_PULLUP : INPUT);
  pinMode(rotaryPinB, pullUp == 1 ? INPUT_PULLUP : INPUT);
  debouncerA.attach(rotaryPinA);
  debouncerB.attach(rotaryPinB);

  _oldState = 3;
  _lastTime = millis();
  _directionState = Stopped;
  _debounceFilter = DEFAULT_DEBOUNCE_FILTER;
  _boostCount = 0;
  _boostActivationCount = DEFAULT_BOOST_ACTIVATION_COUNT;
  _boostActivationInterval = DEFAULT_BOOST_ACTIVATION_INTERVAL;
}


void PushableRotaryEncoder::setOnRotateClockwise(RotaryEncoderEventHandler handler) {
  _onRotateClockwise = handler;
}


void PushableRotaryEncoder::setOnRotateCounterClockwise(RotaryEncoderEventHandler handler) {
  _onRotateCounterClockwise = handler;
}


void PushableRotaryEncoder::setOnClick(ButtonEventHandler handler) {
  _button.setOnClick(handler);
}


void PushableRotaryEncoder::setOnLongPress(ButtonEventHandler handler) {
  _button.setOnLongPress(handler);
}


void PushableRotaryEncoder::setLongPressClickTicks(unsigned int ticks) {
  _button.setLongPressClickTicks(ticks);
}


void PushableRotaryEncoder::setDebounceFilter(int debounceFilter) {
  _debounceFilter = debounceFilter;
}


void PushableRotaryEncoder::setBoostActivationCount(int boostActivationCount) {
  _boostActivationCount = boostActivationCount;
}


void PushableRotaryEncoder::setBoostActivationInterval(int boostActivationInterval) {
  _boostActivationInterval = boostActivationInterval;
}


void PushableRotaryEncoder::tick() {
  _button.tick();
  debouncerA.update();
  debouncerB.update();

  int sigA = debouncerA.read();
  int sigB = debouncerB.read();
  int8_t thisState = sigA | (sigB << 1);

  if (_oldState != thisState) {
    int direction = KNOBDIR[thisState | (_oldState<<2)];

    if (thisState == LATCHSTATE) {
      unsigned long now = millis();
      if (now - _lastTime >= _debounceFilter) {
        _directionState = Stopped;
      }
      if (now - _lastTime <= _boostActivationInterval) {
        _boostCount++;
      } else {
        _boostCount = 0;
      }
      _lastTime = now;
      if (direction > 0) {
        switch (_directionState) {

          case Stopped:
            _directionState = StartedClockwise;
            break;

          case StartedClockwise:
            _directionState = RotatingClockwise;
            break;

          case RotatingClockwise:
            break;

          default:
            goto on_bounce;
            break;
        }
        if (_onRotateClockwise != NULL) {
          _onRotateClockwise(_boostCount >= _boostActivationCount);
        }
      } else {
        switch (_directionState) {

          case Stopped:
            _directionState = StartedCounterClockwise;
            break;

          case StartedCounterClockwise:
            _directionState = RotatingCounterClockwise;
            break;

          case RotatingCounterClockwise:
            break;

          default:
            goto on_bounce;
            break;
        }
        if (_onRotateCounterClockwise != NULL) {
          _onRotateCounterClockwise(_boostCount >= _boostActivationCount);
        }
      }
    }

on_bounce:
    _oldState = thisState;
  } else {
    if (millis() - _lastTime > 2000) {
      _oldState = LATCHSTATE;
    }
  }
}

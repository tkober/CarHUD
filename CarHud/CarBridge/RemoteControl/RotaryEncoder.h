#ifndef ROTARY_ENCODER_H
#define ROTARY_ENCODER_H

#include "Bounce2.h"

enum DirectionState {
  Stopped,
  StartedClockwise,
  StartedCounterClockwise,
  RotatingClockwise,
  RotatingCounterClockwise
};


typedef void (*RotaryEncoderEventHandler)(int boost);


class PushableRotaryEncoder {

  public:
    PushableRotaryEncoder(int rotaryPinA, int rotaryPinB, int buttonPin, int pullUp);

    void setOnRotateClockwise(RotaryEncoderEventHandler handler);
    void setOnRotateCounterClockwise(RotaryEncoderEventHandler handler);
    
    void setOnClick(ButtonEventHandler handler);
    void setOnLongPress(ButtonEventHandler handler);
    void setLongPressClickTicks(unsigned int ticks);
    
    void setDebounceFilter(int debounceFilter);
    void setBoostActivationCount(int boostActivationCount);
    void setBoostActivationInterval(int boostActivationInterval);

    void tick();

  private:
    int _rotaryPinA;
    int _rotaryPinB;
    int _buttonPin;
    int _pullUp;
    Button _button = Button(_buttonPin, _pullUp);
    Bounce  debouncerA  = Bounce(); 
    Bounce  debouncerB  = Bounce(); 

    int _oldState;
    unsigned long _lastTime;
    int _boostCount;

    DirectionState _directionState;
    unsigned int _debounceFilter;
    int _boostActivationCount;
    unsigned int _boostActivationInterval;

    RotaryEncoderEventHandler _onRotateClockwise;
    RotaryEncoderEventHandler _onRotateCounterClockwise;
};

#endif

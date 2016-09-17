#ifndef BUTTON_H
#define BUTTON_H

typedef void (*ButtonEventHandler)();


typedef enum {
  Normal  = 0,
  ClickStarted,
  LongPressed
} ButtonState;


class Button {
  
  public:
    Button(int pin, int pullUp);
  
    void setOnClick(ButtonEventHandler handler);
    void setOnLongPress(ButtonEventHandler handler);
  
    void setLongPressClickTicks(unsigned int ticks);
    
    void tick();
  
  private:
    int _pin;
    int _isPullUp;
    ButtonState _state;
  
    unsigned int _longPressClickTicks;
    
    ButtonEventHandler _onClick;
    ButtonEventHandler _onLongPress;
    
    unsigned long _startedTime;
};

#endif

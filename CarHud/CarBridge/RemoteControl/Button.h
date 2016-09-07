#ifndef BUTTON_H
#define BUTTON_H

typedef void (*ButtonEventHandler)();


typedef enum {
  Normal  = 0,
  ClickStarted,
  Clicked
} ButtonState;


class Button {
  
  public:
    Button(int pin, int pullUp);
  
    void setOnClick(ButtonEventHandler handler);
    void setClickTicks(int clickTicks);
    
    void tick();
  
  private:
    int _pin;
    int _isPullUp;
    ButtonState _state;
    
    unsigned int _clickTicks;
    
    ButtonEventHandler _onClick;
    
    unsigned long _startedTime;
};

#endif

//used library for LCD: https://github.com/arduino-libraries/LiquidCrystal

#include <Arduino.h>
#include <LiquidCrystal.h>

LiquidCrystal lcd(8, 9, 4, 5, 6, 7);

int buttons = 0;
int adc = 0;


#define RIGHT  0
#define UP     1
#define DOWN   2
#define LEFT   3
#define SELECT 4
#define NONE   5

int read_LCD_buttons() {
  
  adc = analogRead(0);       
  
  if (adc > 1000) return NONE;
  if (adc < 50)   return RIGHT;
  if (adc < 250)  return UP;
  if (adc < 450)  return DOWN;
  if (adc < 650)  return LEFT;
  if (adc < 850)  return SELECT;

  return NONE;
}


void setup() {

  lcd.begin(16 , 2);

  lcd.setCursor(0 , 0);
  lcd.print("TENSTESTER V1.0");
  lcd.setCursor(0 , 1);
  lcd.print("POWERED BY JJ");
  delay(3000);
  lcd.clear();

  lcd.setCursor(16 , 0);
  lcd.print("TO START PRESS BUTTON");
  
  for(int i = 0; i < 37; i++)
    {
      lcd.scrollDisplayLeft();
      delay(500);
    }
  lcd.clear();
 
}


void loop() {
  // put your main code here, to run repeatedly:


  buttons = read_LCD_buttons();
  switch (buttons)
  {
  case SELECT:
    {

      break;
    }
    case LEFT:
    {

      break;
    }
      case RIGHT:
    {

      break;
    }
    case NONE:
    {

  
  for (int k = 0; k < 5; k++)
  {
    String text = " ";
    if (k == 0)
    {
      text = "SLOW TEST PRESS 1";
    }
    else if (k == 1)
    {
      text = "FAST TEST PRESS 2";
    }
    else if (k == 2)
    {
      text = "MODULUS TEST PRESS 3";
    }
    else if (k == 3)
    {
      text = "MOVE UP PRESS 4";
    }
    else if (k == 4)
    {
      text = "MOVE DOWN PRESS 5";
    }

    lcd.setCursor(16, 0);
    lcd.print(text);

    for (int i = 0; i < 20; i++) // Remove the semicolon after the for loop
    {
      lcd.scrollDisplayLeft();
      delay(500);
    }

    lcd.clear();

   
      
      
  }
    break;
    }
  }
}

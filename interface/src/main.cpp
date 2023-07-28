//used library for LCD: https://github.com/arduino-libraries/LiquidCrystal

#include <Arduino.h>
#include <LiquidCrystal.h>

LiquidCrystal lcd(8, 9, 4, 5, 6, 7);

int lcd_key = 0;
int adc_key_in = 0;


#define btnRIGHT  0
#define btnUP     1
#define btnDOWN   2
#define btnLEFT   3
#define btnSELECT 4
#define btnNONE   5

int read_LCD_buttons() {
  
  adc_key_in = analogRead(0);       
  
  if (adc_key_in > 1000) return btnNONE;
  if (adc_key_in < 50)   return btnRIGHT;
  if (adc_key_in < 250)  return btnUP;
  if (adc_key_in < 450)  return btnDOWN;
  if (adc_key_in < 650)  return btnLEFT;
  if (adc_key_in < 850)  return btnSELECT;

  return btnNONE;
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

  int j = 0;

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
}
void testtextdisplay()
{





  
}
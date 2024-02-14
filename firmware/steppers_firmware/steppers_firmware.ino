// TensTester Control Program
// Author: Jakub Jasiejko
// GitHub: https://github.com/JakubJasiejko/JJ-TENSTESTER-V1.0
// License: MIT License


#include <Arduino.h>
void(* resetFunc) (void) = 0;

static const int interruptButton = 2;
static const int interruptPin = 5;
static const int step1Pin = 4;
static const int dir1Pin = 3;


static const int step2Pin = 11;
static const int dir2Pin = 12;


const int steps = 200;
float angle = 0;
float RPM = 0;
int microSteppingValue = 1;

void interrupt(){
    resetFunc();

}

void setup() {
    Serial.begin(9600);
  
  digitalWrite(interruptPin, HIGH);
  delay(1000);
  digitalWrite(interruptPin, LOW); 


  pinMode(interruptPin, OUTPUT); 
  pinMode(step1Pin, OUTPUT);
  pinMode(dir1Pin, OUTPUT);


  pinMode(step2Pin, OUTPUT);
  pinMode(dir2Pin, OUTPUT);

attachInterrupt(digitalPinToInterrupt(interruptButton), interrupt,FALLING);
}

void loop() {
  if (Serial.available() > 0) {
    String data = Serial.readStringUntil('\n');
   Serial.println(data); //COMMENT
    int spaceIndex1 = data.indexOf(' ');
    int spaceIndex2 = data.indexOf(' ', spaceIndex1 + 1);

    if (spaceIndex1 != -1) {
      RPM = data.substring(0, spaceIndex1).toFloat();
      String direction = data.substring(spaceIndex1 + 1, spaceIndex2);
      direction.trim();



      float delayDuration = (60 * 1000000) / (steps * RPM);

      while(1) {
        if (direction == "left") {
          digitalWrite(dir1Pin, HIGH);
          digitalWrite(dir2Pin, HIGH);
         //Serial.println("lewo");  //COMMENT
        } else if (direction == "right") {
          digitalWrite(dir1Pin, LOW);
          digitalWrite(dir2Pin, LOW);
        //Serial.println("prawo");  ///COMMENT
        }

        digitalWrite(step1Pin, HIGH);
        digitalWrite(step2Pin, HIGH);
        delayMicroseconds(delayDuration);

        digitalWrite(step1Pin, LOW);
        digitalWrite(step2Pin, LOW);
        delayMicroseconds(delayDuration);
      }
    }
    digitalWrite(interruptPin, HIGH);
    delay(1000);
    digitalWrite(interruptPin, LOW);

  }


}
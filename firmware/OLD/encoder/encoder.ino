#include <arduino.h>


//encoder pins
static const int encoderPinA = 3;
static const int encoderPinB = 4;

//encoder variables
bool encoderPinBState = false;
volatile int encoderPulses = 0;




void interruptService() {
  encoderPinBState = digitalRead(encoderPinB);
  if (encoderPinBState == LOW) {  
    encoderPulses++;
  } else if (encoderPinBState == HIGH) {
    
  encoderPulses--;

  }

      }
  
  
  }


void setup() {

  
  Serial.begin(9600);

  pinMode(encoderPinA, INPUT);
  pinMode(encoderPinB, INPUT);

  digitalWrite(encoderPinA, HIGH);
  digitalWrite(encoderPinB, HIGH);

 attachInterrupt(digitalPinToInterrupt(encoderPinA), interruptService, RISING);

}


void loop() {
           
           Serial.println(encoderPulses);

}

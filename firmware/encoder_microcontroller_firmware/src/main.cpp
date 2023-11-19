#include <arduino.h>
#include <Wire.h>

static const int encoderPinA = 3;
static const int encoderPinB = 6;
static const int dataInterruptPin = 2;

bool encoderPinBState = false;

int encoderPulses = 0;

void interruptService(){
encoderPinBState = digitalRead(encoderPinB);
if (encoderPinBState == LOW){
  encoderPulses++;
  //Serial.println(encoderPulses);
}
else if(encoderPinBState == HIGH){
  encoderPulses--;
  //Serial.println(encoderPulses);
}

}
void dataService(){
Serial.print("position: ");
Serial.println(encoderPulses);


}




void setup(){

 // Inicjalizacja portu szeregowego dla monitora szeregowego (do celów diagnostycznych)
  Serial.begin(9600);
  Serial.println("ready");
  Wire.begin(8);
  // Konfiguracja pinu przerwań jako wejście
  pinMode(encoderPinA, INPUT);
  pinMode(encoderPinB, INPUT);
  pinMode(dataInterruptPin, INPUT);

  // Włączenie pull-up na pinie przerwań
  digitalWrite(encoderPinA, HIGH);
  digitalWrite(encoderPinB, HIGH);
  digitalWrite(dataInterruptPin, HIGH);

  // Konfiguracja przerwania na narastające zbocze (RISING)
  attachInterrupt(digitalPinToInterrupt(encoderPinA), interruptService, RISING);
  attachInterrupt(digitalPinToInterrupt(dataInterruptPin), dataService, RISING);
}
void loop(){}
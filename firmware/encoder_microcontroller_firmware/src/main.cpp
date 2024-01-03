#include <arduino.h>
#include <Wire.h>

static const int encoderPinA = 2;
static const int encoderPinB = 4;
static const int dataInterruptPin = 3;

bool encoderPinBState = false;
volatile int encoderPulses = 0;

bool measurementInProgress = false;
String measurementData = "";

void interruptService() {
  encoderPinBState = digitalRead(encoderPinB);
  if (encoderPinBState == LOW) {
    encoderPulses++;
  } else if (encoderPinBState == HIGH) {
    encoderPulses--;
  }
}

void dataService() {
  Serial.print("position: ");
  Serial.println(encoderPulses);
}

void startMeasurement() {
  measurementInProgress = true;
  encoderPulses = 0;
  measurementData = "";
}

void stopMeasurement() {
  measurementInProgress = false;
  Serial.println("Measurement stopped");
  Serial.println("Measurement data: " + measurementData);
}

void processI2CCommand() {
  Wire.requestFrom(8, 4);
  String command = "";
  while (Wire.available()) {
    char c = Wire.read();
    command += c;
  }

  if (command == "stop") {
    stopMeasurement();
  }
}

void setup() {
  Serial.begin(9600);
  pinMode(encoderPinA, INPUT);
  pinMode(encoderPinB, INPUT);
  pinMode(dataInterruptPin, INPUT);
  digitalWrite(encoderPinA, HIGH);
  digitalWrite(encoderPinB, HIGH);
  digitalWrite(dataInterruptPin, HIGH);
  attachInterrupt(digitalPinToInterrupt(encoderPinA), interruptService, RISING);
  attachInterrupt(digitalPinToInterrupt(dataInterruptPin), dataService, RISING);
  Wire.begin(8);
  //Wire.onReceive()processI2CCommand;
}

void loop() {
  if (measurementInProgress) {
    measurementData += String(encoderPulses) + " ";
  }
  if (Wire.available()) {
    processI2CCommand();

  }


}

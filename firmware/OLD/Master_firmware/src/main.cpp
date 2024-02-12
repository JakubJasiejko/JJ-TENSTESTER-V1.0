#include <Arduino.h>

int i = 0;

void setup() {
  Serial.begin(9600);    // PC
  Serial1.begin(9600);   // STEPPERS
  Serial2.begin(9600);   // LOADCELL AND ENCODER
}

void dataEvent() {
  String rpm, angle, direction, action;

  if (Serial.available() > 0) {
    String receivedData = Serial.readStringUntil('\n');
    
    // Extract data using indexOf and substring
    int spaceIndex1 = receivedData.indexOf(' ');
    rpm = receivedData.substring(0, spaceIndex1);
    
    int spaceIndex2 = receivedData.indexOf(' ', spaceIndex1 + 1);
    angle = receivedData.substring(spaceIndex1 + 1, spaceIndex2);
    
    int spaceIndex3 = receivedData.indexOf(' ', spaceIndex2 + 1);
    direction = receivedData.substring(spaceIndex2 + 1, spaceIndex3);
    
    action = receivedData.substring(spaceIndex3 + 1);

    // Send the first three variables over UART1
    String sendData = rpm + " " + angle + " " + direction;
    Serial1.println(sendData);
    Serial2.println(action);
   // Serial.println(action);
  }
}

void dataSending() {
  String measurement;

  // Wait for and read the measurements from Arduino Nano via UART2
  measurement = Serial2.readStringUntil('\n');
  if (measurement.length() > 0) {
    Serial.println(measurement);
  }
}

void loop() {
  while (i == 0) {
    dataEvent();
    i++;
  }

  while (i == 1) {
    dataSending();
    i--;
  }
}

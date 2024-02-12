#include <Arduino.h>

bool measurement = false;

void setup() {
  Serial.begin(9600);    // PC
  Serial1.begin(9600);   // STEPPERS
  Serial2.begin(9600);   // ENCODER
  Serial3.begin(9600);    //LOADCELL
}
void dataReceiving() {
    String encoderDataFromSlave, loadCellDataFromSlave;



    while (Serial2.available()) {
        encoderDataFromSlave = Serial2.read(); 
        Serial.println("E");
        Serial.print(encoderDataFromSlave);
    }
    /*while (Serial3.available()) {
        loadCellDataFromSlave = Serial3.read(); 
        Serial.println("L");
        Serial.print(loadCellDataFromSlave);
    }*/
}

void loop() {

String rpm, angle, direction, time;

  if (Serial.available() > 0) {
    String receivedData = Serial.readStringUntil('\n');

    int spaceIndex1 = receivedData.indexOf(' ');
    rpm = receivedData.substring(0, spaceIndex1);
    
    int spaceIndex2 = receivedData.indexOf(' ', spaceIndex1 + 1);
    angle = receivedData.substring(spaceIndex1 + 1, spaceIndex2);
    
    int spaceIndex3 = receivedData.indexOf(' ', spaceIndex2 + 1);
    direction = receivedData.substring(spaceIndex2 + 1, spaceIndex3);
    
    time = receivedData.substring(spaceIndex3 + 1);

    String sendData = rpm + " " + angle + " " + direction;
    Serial1.println(sendData);
    Serial.println(sendData);  //COMMENT
    Serial3.println(time);
    measurement = true;
  }
if (measurement == true){

  
}


}

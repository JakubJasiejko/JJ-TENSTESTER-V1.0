#include <Arduino.h>


bool measurement = false;
String encoderString = " ";
String loadCellString = " ";

int RX_BUFFER_SIZE = 256;
int TX_BUFFER_SIZE = 256;

void setup() {
  Serial.begin(9600);    // PC
  Serial1.begin(9600);   // STEPPERS
  Serial2.begin(9600); // ENCODER
  Serial3.begin(9600);    //LOADCELL
}

void loop() {

String rpm, direction, time;

  if (Serial.available() > 0) {
    String receivedData = Serial.readStringUntil('\n');

    int spaceIndex1 = receivedData.indexOf(' ');
    rpm = receivedData.substring(0, spaceIndex1);
    
    int spaceIndex2 = receivedData.indexOf(' ', spaceIndex1 + 1);
    direction = receivedData.substring(spaceIndex1 + 1, spaceIndex2);

    

    String sendData = rpm + " " + direction;
  
    Serial1.println(sendData);

    Serial3.println("start");

    measurement = true;
  }
if (measurement == true){

  String dataString = " ";
  while (Serial2.available() && Serial3.available()){

    String loadCellData = Serial3.readStringUntil('\n');

    
    String encoderData = Serial2.readStringUntil('\n');
    
    
    Serial.println(loadCellData + " " + encoderData);

  }

}

}

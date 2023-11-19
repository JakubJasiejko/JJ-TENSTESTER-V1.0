# JJ-TENSTESTER-V1.0

## Author
- Jakub Jasiejko ([GitHub Repository](https://github.com/JakubJasiejko/JJ-TENSTESTER-V1.0))

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Date
18.11.2023

## Overview
This repository contains the software for one of the slave microcontrollers in the TensTester v1.0 project, focusing on force measurement. The microcontroller utilizes a load cell and an HX711 amplifier for precise force measurements during static tensile testing. The software facilitates communication with the Arduino Mega Master microcontroller, receiving test duration instructions and providing synchronized force measurements. Additionally, it synchronizes its timer via I2C with another slave microcontroller responsible for displacement measurement through an incremental encoder.

## Functionality
Serial Communication: The code establishes communication with the Arduino Mega Master microcontroller, receiving a string variable representing the duration of the test. It interprets this input to determine the time duration for measurements.

After processing the input, the code initiates continuous measurements. Synchronized force measurements are sent via UART as a string variable separated by spaces. These values are transmitted back to the master microcontroller. The timer synchronization via I2C ensures coordination with another slave microcontroller responsible for displacement measurement using an incremental encoder.

Example:

Input: "10.0" (represents a 10-second measurement duration)  
Output: "123 456 789 ..." (space-separated synchronized force measurements)

This communication scheme allows for flexibility and ease of integration with other components within the TensTester v1.0 system. The received force measurements are transmitted to the master microcontroller and then to dedicated PC software as part of an Engineering Thesis, where they undergo analysis for various applications, enhancing the TensTester v1.0 as a versatile tool for static tensile testing.

## Variables
- `measurementDelay`: Time delay between measurements in microseconds.
- `lastMeasurementTime`: Timestamp of the last measurement.
- `currentTimeToSend`: Current time for synchronization purposes.
- `timeOfMeasurement`: Time duration for measurements.
- `calFactor`: Calibration factor for the load cell.
- `allMeasurements`: String to store the collected measurements.

## Load Cell Initialization
The HX711 library is used to interface with the load cell. The load cell is initialized, tared, and the scale is set using the specified calibration factor.

## Serial Communication
The code listens for input from the serial port, interpreting it as the time duration for measurements, and performs continuous measurements. The measured weights are sent over UART to the master microcontroller.

## Example Usage
1. Input the time of measurement via the Arduino Serial Monitor.
2. Receive synchronized force measurements.

## Repository
- [JJ-TENSTESTER-V1.0 Repository](https://github.com/JakubJasiejko/JJ-TENSTESTER-V1.0)

## Library
- HX711 Library: [https://github.com/bogde/HX711](https://github.com/bogde/HX711)
  - Author: Bogdan Necula

## Acknowledgment
This work is part of an Engineering Thesis conducted by Jakub Jasiejko.

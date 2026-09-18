# IoT-Based Three-Player First-Press Quiz Game

## Project Description
This project is an IoT-based three-player quiz game developed using ESP32, Node-RED, MQTT, RESTful API, and Dashboard 2.0.

The system determines which player presses the physical button first. Once the first player is detected, the round is locked to prevent the other players from answering. The selected player can then answer the displayed question through the Node-RED Dashboard.

A correct answer increases the player's score by one point. At the end of the game, the system compares the players' scores and displays the winner.

## Technologies Used
- ESP32
- Node-RED
- Node-RED Dashboard 2.0
- MQTT Protocol
- Mosquitto MQTT Broker
- RESTful API
- Postman
- MQTTX
- Arduino IDE

## Hardware Components
- ESP32
- 3 Push Buttons
- 3 LEDs
- 3 × 220 Ohm Resistors
- Buzzer
- P817 Optocoupler
- Breadboard
- Jumper Wires

## Game Features
- Three-player quiz system
- First-button detection
- Round locking
- Seven quiz questions
- Questions displayed on Dashboard 2.0
- Four answer choices: A, B, C, and D
- Score calculation
- Round reset
- Final winner calculation
- MQTT communication between ESP32 and Node-RED
- RESTful API implementation

## Project Structure

ESP32/
- ESP32 Arduino source code

NodeRED/
- Complete Node-RED flow

Documentation/
- Final project report

Postman/
- REST API test files

## How It Works
1. The game starts from the Node-RED Dashboard.
2. A question is displayed on Dashboard 2.0.
3. The three players can press their physical ESP32 buttons.
4. The first button press is accepted and the round is locked.
5. The selected player answers the question.
6. A correct answer adds one point to the player's score.
7. The system continues through the quiz questions.
8. At the end of the game, the player with the highest score is displayed as the winner.

## Communication Architecture

ESP32 → MQTT → Mosquitto Broker → Node-RED → Dashboard 2.0

RESTful API endpoints were tested using Postman.

## Team Members
- Bashayer Al-Matari
- Zainab Al-Matari
- Maysoun Al-Matari
- Shahd Al-Sanbani
- Alyaa Al-Madani

## Course
Internet of Things (IoT)

## Project Status
Completed
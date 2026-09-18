#include <WiFi.h>
#include <PubSubClient.h>

const char* ssid = "YOUR_WIFI_NAME";
const char* password = "YOUR_WIFI_NAME";

const char* mqtt_server = "192.168.0.108";

WiFiClient espClient;
PubSubClient client(espClient);   

int v[3] = {14, 33, 25};     // Buttons
int g[3] = {5, 4, 2};     // LEDs
int f = 18;                  // Buzzer

bool k = false;

unsigned long l = 0;
unsigned long s = 150;

void off() {
  for (int i = 0; i < 3; i++) {
    digitalWrite(g[i], LOW);
  }
}

// void beep() {
//   digitalWrite(f, HIGH);
//   delay(200);
//   digitalWrite(f, LOW);
// }

void connectWiFi() {

  Serial.print("Connecting to WiFi");

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println();
  Serial.println("WiFi Connected");

  Serial.print("ESP32 IP: ");
  Serial.println(WiFi.localIP());
}

void callback(char* topic, byte* payload, unsigned int length) {

  String message = "";

  for (unsigned int i = 0; i < length; i++) {
    message += (char)payload[i];
  }

  Serial.print("MQTT Topic: ");
  Serial.println(topic);

  Serial.print("MQTT Message: ");
  Serial.println(message);

  if (String(topic) == "quiz/reset") {

    if (message == "reset" || message == "RESET") {

      // فتح الجولة من جديد
      k = false;

      // إطفاء جميع LEDs
      off();

      Serial.println("RESET FROM MQTT");
      Serial.println("ROUND READY");
    }
  }
}

void connectMQTT() {

  while (!client.connected()) {

    Serial.print("Connecting to MQTT...");

    if (client.connect("ESP32_Quiz_Game")) {

      Serial.println("Connected");

      // استقبال reset من Node-RED
      bool subscribed = client.subscribe("quiz/reset");

      if (subscribed) {
        Serial.println("Subscribed to: quiz/reset");
      } else {
        Serial.println("Subscribe to quiz/reset FAILED");
      }

    } else {

      Serial.print("Failed, rc=");
      Serial.print(client.state());

      Serial.println(" retry in 2 seconds");

      delay(2000);
    }
  }
}

void sendWinner(int playerNumber) {

  String message = String(playerNumber);

  bool published = client.publish(
    "quiz/winner",
    message.c_str()
  );

  if (published) {

    Serial.print("MQTT Winner Sent: Player ");
    Serial.println(playerNumber);

  } else {

    Serial.println("MQTT Winner Send Failed");
  }
}

void setup() {

  Serial.begin(115200);

  delay(500);

  for (int i = 0; i < 3; i++) {

    pinMode(v[i], INPUT_PULLUP);

    pinMode(g[i], OUTPUT);

    digitalWrite(g[i], LOW);
  }


  pinMode(f, OUTPUT);

  digitalWrite(f, LOW);

  connectWiFi();

  client.setServer(mqtt_server, 1883);

  client.setCallback(callback);

  connectMQTT();


  Serial.println("=========================");
  Serial.println("QUIZ GAME READY");
  Serial.println("=========================");
}

void loop() {

  if (!client.connected()) {
    connectMQTT();
  }

  client.loop();

  if (!k) {

    for (int i = 0; i < 3; i++) {

      if (
        digitalRead(v[i]) == LOW &&
        (millis() - l > s)
      ) {

        l = millis();

        // قفل الجولة
        k = true;

        // إطفاء LEDs أولًا
        off();

        // تشغيل LED اللاعب الفائز
        digitalWrite(g[i], HIGH);

        // تشغيل البازر
        beep();

        // عرض الفائز
        Serial.print("WINNER: Player ");
        Serial.println(i + 1);

        // إرسال الفائز إلى Node-RED عبر MQTT
        sendWinner(i + 1);

        break;
      }
    }
  }

  if (Serial.available()) {

    char c = Serial.read();

    if (c == 'r' || c == 'R') {

      k = false;

      off();

      Serial.println("RESET FROM SERIAL");
      Serial.println("ROUND READY");
    }
  }
}
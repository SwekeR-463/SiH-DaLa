#include <ESP8266WiFi.h>
#include <Firebase_ESP_Client.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

#define WIFI_SSID "Galaxy A32CB54"
#define WIFI_PASSWORD "maeb6490"

#define DATABASE_URL "https://coalquip-default-rtdb.firebaseio.com/"
#define DATABASE_SECRET "ftYSsNDfAdbh6LFtYU8jiQj4eCYSEYSF04moznbn"
#define API_KEY "AIzaSyB26FTTHQBOzapURuy7S1k3g8Gbrnfg2ao"

#define LED_PIN D1

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
bool signupOk = false;


void wifiInit() {
  // Connect to Wifi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  Serial.print("Connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }

  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  WiFi.setSleepMode(WIFI_NONE_SLEEP);
}

void setup() {
  Serial.begin(115200);

  wifiInit();

  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;

  if (Firebase.signUp(&config, &auth, "", "")) {
    Serial.println("Sign Up OK");
    signupOk = true;
  } else {
    Serial.println("Error");
  }

  config.token_status_callback = tokenStatusCallback;
  Firebase.begin(&config, &auth);
  Firebase.reconnectNetwork(true);

  pinMode(LED_PIN, OUTPUT);
}

int n = 0;
void loop() {
  if (Firebase.ready() && signupOk && (millis() - sendDataPrevMillis > 1000 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();

    // if (Firebase.RTDB.setInt(&fbdo, "LED_STATUS", n)) {
    //   Serial.println("Success");
    // } else {
    //   Serial.println("Error");
    // }

    // n++;

    int status = Firebase.RTDB.getInt(&fbdo, "LED_STATUS");

    if (status = 1) {
      digitalWrite(LED_PIN, HIGH);
      Serial.println("Success");
      int data = fbdo.to<int>();

      if (data == 1) {
        digitalWrite(LED_PIN, HIGH);
        Serial.println("LED is on");
      } else if (data == 0) {
        digitalWrite(LED_PIN, LOW);
        Serial.println("LED is off");
      } else {
        Serial.println("Error: Value is not 0 or 1");
      }
    } else {
      digitalWrite(LED_PIN, LOW);
      Serial.println("Error");
    }
  }
}

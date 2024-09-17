// #include <ESP8266WiFi.h>
// #include <FirebaseArduino.h>

// #define WIFI_SSID "Galaxy A32CB54"
// #define WIFI_PASSWORD "maeb6490"

// #define FIREBASE_HOST "coalquip-default-rtdb.firebaseio.com"
// #define FIREBASE_AUTH "ftYSsNDfAdbh6LFtYU8jiQj4eCYSEYSF04moznbn"

// void wifiInit() {
//   // Connect to Wifi
//   WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

//   Serial.print("Connecting");
//   while (WiFi.status() != WL_CONNECTED) {
//     Serial.print(".");
//     delay(500);
//   }

//   Serial.println();
//   Serial.print("Connected with IP: ");
//   Serial.println(WiFi.localIP());
//   Serial.println();

//   WiFi.setSleepMode(WIFI_NONE_SLEEP);
// }

// void setup() {
//   Serial.begin(9600);

//   wifiInit();

//   Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
//   Firebase.setInt("LED_STATUS", 0);

//   pinMode(D1, OUTPUT);

//   Firebase.pushInt("led/state", 100);
// }

// int fireStatus = 0;
// void loop() {
//   fireStatus = 1;
//   Firebase.setInt("LED_STATUS", 1);


//   if (fireStatus == 1) {
//     Serial.println("Led Turned ON");
//     digitalWrite(D1, HIGH);
//   } else if (fireStatus == 0) {
//     Serial.println("Led Turned OFF");
//     digitalWrite(D1, LOW);
//   } else {
//     Serial.println("Command Error! Please send 0/1");
//   }
// }

#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>
 
#define FIREBASE_HOST "coalquip-default-rtdb.firebaseio.com/" // Firebase host
#define FIREBASE_AUTH "ftYSsNDfAdbh6LFtYU8jiQj4eCYSEYSF04moznbn" //Firebase Auth code
#define WIFI_SSID "Galaxy A32CB54" //Enter your wifi Name
#define WIFI_PASSWORD "maeb6490" // Enter your password
int fireStatus = 0;
 
void setup() {
  Serial.begin(9600);
  pinMode(D1, OUTPUT);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.println("Connected.");
  Serial.println(WiFi.localIP());
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.set("LED_STATUS", 0);
}
 
void loop() {
  fireStatus = Firebase.getInt("LED_STATUS");
  if (fireStatus == 1) {
    Serial.println("Led Turned ON");
    digitalWrite(D1, HIGH);
  }
  else if (fireStatus == 0) {
    Serial.println("Led Turned OFF");
    digitalWrite(D1, LOW);
  }
  else {
    Serial.println("Command Error! Please send 0/1");
  }
} 
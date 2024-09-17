#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>
#include <FirebaseClient.h>

#define WIFI_SSID "Galaxy A32CB54"
#define WIFI_PASSWORD "maeb6490"

// The API key can be obtained from Firebase console > Project Overview > Project settings.
#define API_KEY "AIzaSyB26FTTHQBOzapURuy7S1k3g8Gbrnfg2ao"

// User Email and password that already registerd or added in your project
#define USER_EMAIL "swayam1223@gmail.com"
#define USER_PASSWORD "Swayamsahoo@12345"
#define DATABASE_URL "https://coalquip-default-rtdb.firebaseio.com"

void asyncCB(AsyncResult &aResult);
void printResult(AsyncResult &aResult);

DefaultNetwork network;

UserAuth user_auth(API_KEY, USER_EMAIL, USER_PASSWORD);

FirebaseApp app;

WiFiClientSecure ssl_client;

using AsyncClient = AsyncClientClass;

AsyncClient aClient(ssl_client, getNetwork(network));

RealtimeDatabase Database;

bool taskComplete = false;

void setup() {
  Serial.begin(9600);

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

  Firebase.printf("Firebase Client v%s\n", FIREBASE_CLIENT_VERSION);

  Serial.println("Initializing app...");

  ssl_client.setInsecure();
  ssl_client.setBufferSizes(4096, 1024);

  initializeApp(aClient, app, getAuth(user_auth), asyncCB, "authTask");

  // Binding the FirebaseApp for authentication handler.
  // To unbind, use Database.resetApp();
  app.getApp<RealtimeDatabase>(Database);

  Database.url(DATABASE_URL);

  pinMode(D1, OUTPUT);
}

unsigned long lastCheck = 0;
unsigned long checkInterval = 1000;  // 1 second interval for Firebase checks

int n = 0;
void loop() {
  // set value
  // n = Firebase.getInt("LED_STATUS");
  // Serial.println(n);

  // // handle error
  // if (n == 1) {
  //   Serial.print("LED is ON");
  //   digitalWrite(D1, HIGH);
  //   Serial.println(Firebase.error());
  // } else if (n == 0) {
  //   Serial.print("LED is OFF");
  //   digitalWrite(D1, LOW);
  //   Serial.println(Firebase.error());
  // } else {
  //   Serial.println("error");
  // }

  // if (millis() - lastCheck >= checkInterval) {
  //   Serial.println("Check " + String(n));
  //   n++;
  //   lastCheck = millis();  // Update the time stamp

  //   //   n++;
  //   //   // n = fb.getInt("LED_STATUS");

  //   //   // if (n == 1) {
  //   //   //   Serial.println("LED is ON");
  //   //   //   digitalWrite(D1, HIGH);
  //   //   // } else if (n == 0) {
  //   //   //   Serial.println("LED is OFF");
  //   //   //   digitalWrite(D1, LOW);
  //   //   // } else {
  //   //   //   Serial.println("Error");
  //   //   // }
  // }



  app.loop();

  Database.loop();

  if (app.ready() && !taskComplete) {
    taskComplete = true;

    Serial.println("Asynchronous Push... ");

    // Push int
    Database.push<int>(aClient, "/test/int", 12345, asyncCB, "pushIntTask");
  }
}

void asyncCB(AsyncResult &aResult) {
  // WARNING!
  // Do no put your codes inside the callback and printResult.

  printResult(aResult);
}

void printResult(AsyncResult &aResult) {
  if (aResult.isEvent()) {
    Firebase.printf("Event task: %s, msg: %s, code: %d\n", aResult.uid().c_str(), aResult.appEvent().message().c_str(), aResult.appEvent().code());
  }

  if (aResult.isDebug()) {
    Firebase.printf("Debug task: %s, msg: %s\n", aResult.uid().c_str(), aResult.debug().c_str());
  }

  if (aResult.isError()) {
    Firebase.printf("Error task: %s, msg: %s, code: %d\n", aResult.uid().c_str(), aResult.error().message().c_str(), aResult.error().code());
  }

  if (aResult.available()) {
    if (aResult.to<RealtimeDatabaseResult>().name().length())
      Firebase.printf("task: %s, name: %s\n", aResult.uid().c_str(), aResult.to<RealtimeDatabaseResult>().name().c_str());
    Firebase.printf("task: %s, payload: %s\n", aResult.uid().c_str(), aResult.c_str());
  }
}
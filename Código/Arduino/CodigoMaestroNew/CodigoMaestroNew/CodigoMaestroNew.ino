//COMPILAR CON WEMOS D1 MINI PRO

#include <Adafruit_AHT10.h>
#include <Wire.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <RunningMedian.h>

#define ssid "SAIZ"
#define password "25768755"
//#define serverName "http://192.168.1.21:5006/api/lecturas"
#define serverName "http://77.81.230.76:5096/api/lecturas"
#define idCaja "cac70d5d-4df3-451f-bba9-59bcea039425"

String getISO8601Time();
void enviarLectura();

WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org", -10800, 60000);//Ajuste para UTC-3 Argentina y 60000 se actualiza cada 60`

// the following variables are unsigned longs because the time, measured in
// milliseconds, will quickly become a bigger number than can be stored in an int.
unsigned long lastTime = 0;
// Timer set to 30 minutes (1800000)
unsigned long timerDelay = 1800000;

#define PIN_MQ135 A0

Adafruit_AHT10 aht;

//MQ135 mq135_sensor(PIN_MQ135);
const int gasSensor = 0;
float voltage = 0.00;
float resistencia = 0.00;
float dioxidoDeCarbono = 0.00;
//float dioxidoDeCarbono1 = 0.00;
RunningMedian medianFilterCO2(5); // Ventana de 5 muestras


//For CO2, if we measure points graph and do power regression we can obtain the function
//ppm = 116.6020682 (Rs/Ro)^-2.769034857

double a = 116.6020682;
double a1 = 56.0820;

//el exponente es negativo pero para calcular usando Pow hago el reciproco
//de la potencia positiva,
double b = 2.769034857;
//double b1 = 5.9603;
double Ro = 29619.36495;
//double Ro1 = 34037.18774;

void setup() {
  Serial.begin(115200);

  if (! aht.begin()) {
    Serial.println("Could not find AHT10? Check wiring");
    while (1) delay(10);
  }
  Serial.println("AHT10 found");
  Serial.println("Voltage, Resistencia, CO2 PPM, RH, Temp");

  WiFi.begin(ssid, password);
  Serial.println("Connecting");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Connected to WiFi network with IP Address: ");
  Serial.println(WiFi.localIP());

  timeClient.begin();

  enviarLectura();
}

void loop() {
  //Enviar una solicitud HTTP POST cada 30 minutos
  if ((millis() - lastTime) > timerDelay) {
    enviarLectura();
  }
}

void enviarLectura(){
  
    String isoTime = getISO8601Time();
    Serial.print(F("Fecha y hora actual: ")); Serial.println(isoTime);

    sensors_event_t humidity, temp;
    aht.getEvent(&humidity, &temp);

    voltage = getVoltage(PIN_MQ135);
    resistencia = 1000.0 * ((5.0 - voltage) / voltage);
    dioxidoDeCarbono = a * ( 1.0 / pow( (resistencia / Ro), b));
    //dioxidoDeCarbono1 = a1 * ( 1.0 / pow( (resistencia / Ro1), b1));

    // Aplicar el filtro de mediana en la lectura de CO₂
    medianFilterCO2.add(dioxidoDeCarbono);  // Leer valor filtrado

    float co2Filtrado = medianFilterCO2.getMedian();
    
    Serial.print(voltage, 5);
    Serial.print(";");
    Serial.print(resistencia, 5);
    Serial.print(";");
    Serial.print(co2Filtrado, 5);
    Serial.print(";");
    Serial.print(humidity.relative_humidity, 5);
    Serial.print(";");
    Serial.println(temp.temperature, 5);

    //Crear un objeto JSON
    JsonDocument doc;
    doc["fechaHoraLectura"] = isoTime;
    doc["temp"] = temp.temperature;  // Asignar la temperatura
    doc["humedad"] = humidity.relative_humidity;  // Asignar la humedad
    doc["dioxidoDeCarbono"] = co2Filtrado;  // Asignar el valor de CO2
    doc["idCaja"] = idCaja;

    //Serializar el JSON a una cadena
    String jsonData;
    serializeJson(doc, jsonData);

    Serial.println(jsonData);
    
    //Verificar el estado de la conexión WiFi
    if (WiFi.status() == WL_CONNECTED) {
      WiFiClient client;
      HTTPClient http;

      http.begin(client, serverName);
      http.setTimeout(5000);  // Aumenta el tiempo de espera a 5 segundos

      http.addHeader("Content-Type", "application/json");

      // Enviar el JSON generado
      int httpResponseCode = http.POST(jsonData);
      //int httpResponseCode = http.POST("{\"nombre\": \"Producto B\",\"precio\": 19.99}");

      Serial.println(http.getString());
      Serial.print("HTTP Response code: ");
      Serial.println(httpResponseCode);
      // Liberar recursos
      http.end();
    }
    else {
      Serial.println("WiFi Disconnected");
    }
    lastTime = millis();
  
}
double getVoltage(int pin)
{
  return ((analogRead(pin) / 1023.0) * 3.3);
  // This equation converts the 0 to 1023 value that analogRead()
  // returns, into a 0.0 to 3.3 value that is the true voltage
  // being read at that pin.
}

String getISO8601Time() {
  timeClient.update();

  //Obtener los componentes de la fecha y hora
  unsigned long epochTime = timeClient.getEpochTime();
  int year = 1970 + (epochTime / 31556926); //Calcula el años desde 1970
  int month = (epochTime % 31556926) / 2629743 + 1; //Obtener el mes
  int day = (epochTime % 2629743) / 86400 + 1; //Obtener el día
  int hour = timeClient.getHours();
  int minute = timeClient.getMinutes();
  int second = timeClient.getSeconds();

  //Formato ISO 8001 (sin mili segundos)
  char isoDate[30];
  sprintf(isoDate, "%04d-%02d-%02dT%02d:%02d:%02dZ", year, month, day, hour, minute, second);
  return String(isoDate);
}

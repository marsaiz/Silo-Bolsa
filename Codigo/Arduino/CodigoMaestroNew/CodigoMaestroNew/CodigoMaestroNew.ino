//COMPILAR CON WEMOS D1 MINI PRO

#include <Adafruit_AHT10.h>
#include <Wire.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <RunningMedian.h>
#include <WiFiManager.h> // https://github.com/tzapu/WiFiManager

// Pin para resetear la configuración WiFi (opcional)
// Conecta un botón entre este pin y GND
#define RESET_WIFI_PIN D3  // Puedes cambiar esto al pin que prefieras

// Ya no necesitas estas líneas:
// #define ssid "SAIZ"
// #define password "25768755"

//#define serverName "http://192.168.1.21:5006/api/lecturas"
//#define serverName "http://77.81.230.76:5096/api/lecturas"
#define serverName "https://remarkable-healing-production.up.railway.app/api/lecturas"

#define idCaja "cac70d5d-4df3-451f-bba9-59bcea039425"

String getISO8601Time();
void enviarLectura();

WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org", -10800, 60000);//Ajuste para UTC-3 Argentina y 60000 se actualiza cada 60`

// the following variables are unsigned longs because the time, measured in
// milliseconds, will quickly become a bigger number than can be stored in an int.
unsigned long lastTime = 0;
// Timer set to 30 minutes (1800000)
unsigned long timerDelay = 300000;

#define PIN_MQ135 A0

Adafruit_AHT10 aht;


const int gasSensor = 0;
float voltage = 0.00;
float resistencia = 0.00;
float dioxidoDeCarbono = 0.00;
//float dioxidoDeCarbono1 = 0.00;
RunningMedian medianFilterCO2(5); // Ventana de 5 muestras


//For CO2, if we measure points graph and do power regression we can obtain the function
//ppm = 116.6020682 (Rs/Ro)^-2.769034857

double a = 116.6020682;

//el exponente es negativo pero para calcular usando Pow hago el reciproco
//de la potencia positiva,
double b = 2.769034857;
double Ro= 33710.79934; 

void setup() {
  Serial.begin(115200);

  // Configurar pin para resetear WiFi (opcional)
  pinMode(RESET_WIFI_PIN, INPUT_PULLUP);

//  if (! aht.begin()) {
//    Serial.println("Could not find AHT10? Check wiring");
//    while (1) delay(10);
//  }
//  Serial.println("AHT10 found");
//  Serial.println("Voltage, Resistencia, CO2 PPM, RH, Temp");

  // Crear instancia de WiFiManager
  WiFiManager wifiManager;

  // Descomentar esta línea para resetear las credenciales guardadas (útil para testing)
  // wifiManager.resetSettings();

  // Verificar si el botón de reset está presionado al iniciar
  if (digitalRead(RESET_WIFI_PIN) == LOW) {
    Serial.println("Botón de reset presionado. Borrando credenciales WiFi...");
    wifiManager.resetSettings();
    delay(1000);
  }

  // Configuración del portal cautivo
  // Si no puede conectarse, crea un AP llamado "SiloBolsa-Config"
  // Puedes cambiarlo por el nombre que prefieras
  Serial.println("Conectando a WiFi...");
  
  // Esto intentará conectarse a la red WiFi guardada
  // Si falla, creará un AP con el nombre "SiloBolsa-Config"
  // Opcionalmente puedes agregar una contraseña: autoConnect("SiloBolsa-Config", "password123")
  if (!wifiManager.autoConnect("SiloBolsa-Config")) {
    Serial.println("Fallo al conectar y timeout alcanzado");
    // Reiniciar y volver a intentar
    delay(3000);
    ESP.restart();
    delay(5000);
  }

  // Si llegamos aquí, estamos conectados!
  Serial.println("");
  Serial.print("Conectado a WiFi! IP Address: ");
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

//    sensors_event_t humidity, temp;
//    aht.getEvent(&humidity, &temp);
//
//    voltage = getVoltage(PIN_MQ135);
//    resistencia = 1000.0 * ((5.0 - voltage) / voltage);
//    dioxidoDeCarbono = a * ( 1.0 / pow( (resistencia / Ro), b)); //Obtengo valor en ppm
//    dioxidoDeCarbono /= 10000; //Convierto a %
//   
//
//    // Aplicar el filtro de mediana en la lectura de CO₂
//    medianFilterCO2.add(dioxidoDeCarbono);  // Leer valor filtrado
//
//    float co2Filtrado = medianFilterCO2.getMedian();
//    
//    Serial.print(voltage, 5);
//    Serial.print(";");
//    Serial.print(resistencia, 5);
//    Serial.print(";");
//    Serial.print(co2Filtrado, 5);
//    Serial.print(";");
//    Serial.print(humidity.relative_humidity, 5);
//    Serial.print(";");
//    Serial.println(temp.temperature, 5);
//
//    //Crear un objeto JSON
//    JsonDocument doc;
//    doc["fechaHoraLectura"] = isoTime;
//    doc["temp"] = temp.temperature;  // Asignar la temperatura
//    doc["humedad"] = humidity.relative_humidity;  // Asignar la humedad
//    doc["dioxidoDeCarbono"] = dioxidoDeCarbono;// Asignar el valor de CO2 en %
//    doc["idCaja"] = idCaja;

// Generar valores aleatorios para pruebas
    float tempAleatoria = random(150, 350) / 10.0; // Temperatura entre 15.0 y 35.0 ºC
    float humedadAleatoria = random(300, 800) / 10.0; // Humedad entre 30.0 y 80.0 %
    float co2Aleatorio = random(400, 2000); // CO2 entre 400 y 2000 ppm
    
    Serial.print("Temp: "); Serial.print(tempAleatoria);
    Serial.print("; Humedad: "); Serial.print(humedadAleatoria);
    Serial.print("; CO2: "); Serial.print(co2Aleatorio);

    // Crear un objeto JSON
    JsonDocument doc;
    doc["fechaHoraLectura"] = isoTime;
    doc["temp"] = tempAleatoria;  // Asignar la temperatura aleatoria
    doc["humedad"] = humedadAleatoria;  // Asignar la humedad ale
    doc["dioxidoDeCarbono"] = co2Aleatorio;  // Asignar el valor de CO2 aleatorio
    doc["idCaja"] = idCaja;  // Asignar el ID de la caja

    //Serializar el JSON a una cadena
    String jsonData;
    serializeJson(doc, jsonData);

    Serial.println(jsonData);
    
    //Verificar el estado de la conexión WiFi
    if (WiFi.status() == WL_CONNECTED) {
      WiFiClientSecure client;
      client.setInsecure();
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

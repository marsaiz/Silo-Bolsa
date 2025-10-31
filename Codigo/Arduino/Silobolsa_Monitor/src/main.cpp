// COMPILAR CON WEMOS D1 MINI PRO (ESP8266)

#include <Adafruit_AHTX0.h>
#include <Wire.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <RunningMedian.h>
#include <WiFiManager.h> // https://github.com/tzapu/WiFiManager
#include <MQ135.h>       // >>> NUEVA LIBRERÍA AÑADIDA para corrección de CO2 <<<

// Pin para resetear la configuración WiFi (opcional)
#define RESET_WIFI_PIN D3  // Conecta un botón entre este pin y GND

// URL del servidor de la API
#define serverName "https://remarkable-healing-production.up.railway.app/api/lecturas"

// ID único de la caja
#define idCaja "066cd7cc-0cc7-4800-af0b-290a86639117"

String getISO8601Time();
void enviarLectura();

WiFiUDP ntpUDP;
// Ajuste para UTC-3 (Argentina). 
// 60000 ms = 1 minuto de intervalo de actualización (suficiente para un time-client)
NTPClient timeClient(ntpUDP, "pool.ntp.org", -10800, 60000); 

// Temporizadores
unsigned long lastTime = 0;
// Intervalo de envío: 5 minutos (300000 ms)
unsigned long timerDelay = 30000; 

#define PIN_MQ135 A0 // Pin analógico para el sensor MQ-135

Adafruit_AHTX0 aht; // Objeto para el sensor AHT10

// Objeto para el sensor MQ-135, usando el pin analógico A0.
MQ135 mq135_sensor(PIN_MQ135);

float voltage = 0.00;
float resistencia = 0.00;
float dioxidoDeCarbonoPPM = 0.00; 

// Filtro de mediana para suavizar 5 muestras consecutivas de CO2
RunningMedian medianFilterCO2(5); 

// >>> VALORES DE CALIBRACIÓN DEL MQ-135 ELIMINADOS <<<
// La librería MQ135.h maneja la calibración interna por defecto.

void setup() {
  Serial.begin(115200);

  // Configurar pin para resetear WiFi (opcional)
  pinMode(RESET_WIFI_PIN, INPUT_PULLUP);

  // Inicialización del AHT10
  if (! aht.begin()) {
    Serial.println("Error: No se encontró AHT10. Verifique el cableado.");
    while (1) delay(10);
  }
  Serial.println("AHT10 encontrado correctamente.");
  Serial.println("Voltaje MQ-135 (V), Resistencia Rs (Ohms), CO2 PPM Corregido, Humedad (%), Temp (C)");


  // --- Configuración WiFiManager ---
  WiFiManager wifiManager;

  // Si el botón de reset está presionado al iniciar, se borran las credenciales
  if (digitalRead(RESET_WIFI_PIN) == LOW) {
    Serial.println("Botón de reset presionado. Borrando credenciales WiFi...");
    wifiManager.resetSettings();
    delay(1000);
  }

  Serial.println("Conectando a WiFi...");
  
  // Esto intentará conectarse. Si falla, creará un AP llamado "SiloBolsa-Config"
  if (!wifiManager.autoConnect("SiloBolsa-Config")) {
    Serial.println("Fallo al conectar. Reiniciando...");
    delay(3000);
    ESP.restart();
    delay(5000);
  }

  // Si llegamos aquí, estamos conectados
  Serial.println("\nConectado a WiFi!");
  Serial.print("Dirección IP: ");
  Serial.println(WiFi.localIP());

  timeClient.begin();

  // Primera lectura inmediata
  enviarLectura();
}

void loop() {
  // Enviar una solicitud HTTP POST cada 'timerDelay' (5 minutos)
  if ((millis() - lastTime) >= timerDelay) {
    enviarLectura();
  }
}

void enviarLectura(){
  
    // 1. Obtener Fecha y Hora
    String isoTime = getISO8601Time();
    Serial.print(F("Fecha y hora actual: ")); Serial.println(isoTime);

    // 2. Leer AHT10 (Temperatura y Humedad)
    sensors_event_t humidityEvent, tempEvent; // Renombradas para evitar conflicto
    aht.getEvent(&humidityEvent, &tempEvent);

    float temp = tempEvent.temperature;
    float humidity = humidityEvent.relative_humidity;

    // Verificar si las lecturas del AHT10 son válidas
    if (isnan(temp) || isnan(humidity)) {
        Serial.println("Error al leer del sensor AHT10. Reintentando...");
        return; // Salir de la función y reintentar en el próximo loop
    }

    // 3. Leer MQ-135 (CO2 - usando la librería con corrección T/H)
    
    // Obtener la lectura de PPM corregida usando los datos del AHT10
    // Esto es lo que faltaba para usar T/H en el cálculo de CO2
    dioxidoDeCarbonoPPM = mq135_sensor.getCorrectedPPM(temp, humidity); 

    // 4. Aplicar el filtro de mediana en la lectura de CO₂
    medianFilterCO2.add(dioxidoDeCarbonoPPM); 
    float co2Filtrado = medianFilterCO2.getMedian();
    
    // 5. Imprimir datos en Serial
    // NOTA: Los métodos getVoltage y getResistance de la librería MQ135 no están accesibles
    // directamente aquí, pero puedes usar los valores del sensor para debug si los necesitas:
    Serial.print(F("CO2 Corregido: "));
    Serial.print(co2Filtrado, 0); // CO2 suele mostrarse sin decimales
    Serial.print(F(" PPM; Temp: "));
    Serial.print(temp, 1);
    Serial.print(F(" C; Humedad: "));
    Serial.print(humidity, 1);
    Serial.println(F(" %"));


    // 6. Crear Objeto JSON
    JsonDocument doc;
    doc["fechaHoraLectura"] = isoTime;
    doc["temp"] = temp;                   // Temperatura en °C
    doc["humedad"] = humidity;            // Humedad en %
    doc["dioxidoDeCarbono"] = co2Filtrado;   // CO2 en PPM Corregido
    doc["idCaja"] = idCaja;

    // Serializar el JSON a una cadena
    String jsonData;
    serializeJson(doc, jsonData);

    Serial.println(jsonData);
    
    // 7. Enviar por HTTP POST
    if (WiFi.status() == WL_CONNECTED) {
      WiFiClientSecure client;
      client.setInsecure(); // Permite certificados autofirmados (puede ser necesario para Railway)
      HTTPClient http;

      http.begin(client, serverName);
      http.setTimeout(8000); // Tiempo de espera (8 segundos)

      http.addHeader("Content-Type", "application/json");

      int httpResponseCode = http.POST(jsonData);
      
      Serial.print("HTTP Response code: ");
      Serial.println(httpResponseCode);
      Serial.println(http.getString());

      http.end();
    }
    else {
      Serial.println("WiFi Desconectado. No se pudo enviar la lectura.");
    }
    
    lastTime = millis();
}

/**
 * Convierte la lectura analógica (0-1023) a voltaje (0.0 a 3.3V).
 * Mantenemos esta función para consistencia, aunque la librería MQ135 la realiza internamente.
 */
double getVoltage(int pin)
{
  // El ESP8266 tiene una resolución de 10 bits (1024 valores) y una alimentación de 3.3V
  return ((analogRead(pin) / 1024.0) * 3.3); 
}

/**
 * Obtiene la hora actual del servidor NTP y la formatea a ISO 8601 (Ej: 2025-10-30T15:30:00Z).
 */
String getISO8601Time() {
  timeClient.update();

  // Obtener los componentes de la fecha y hora
  unsigned long epochTime = timeClient.getEpochTime();
  
  // Usamos el formato "YYYY-MM-DDTHH:MM:SSZ"
  char isoDate[25]; 
  
  // Usamos strftime para un formateo más seguro si la plataforma lo soporta:
  struct tm *ptm = gmtime ((time_t *)&epochTime);
  
  // Formato ISO 8601 UTC (Z)
  strftime (isoDate, 25, "%Y-%m-%dT%H:%M:%SZ", ptm);
  
  return String(isoDate);
}

#include <AHT10.h>
#include <Wire.h>
#include <MQ135.h>

#define PIN_MQ135 A0

//Variables
// ESP8266 ESP-01 SDA: D2 / SCL: D1
AHT10 sensorTemp(AHT10_ADDRESS_0X38);
float temp = 0.00;
float hum = 0.00;

MQ135 mq135_sensor(PIN_MQ135);
const int gasSensor = 0;
float voltage = 0.00;
float resistencia = 0.00;
float dioxidoDeCarbono = 0.00;


void setup() {
  Serial.begin(115200);
  while (sensorTemp.begin() != true)
  {
    Serial.println(F("Sensor de temperatura, error de conexion")); // (F()) graba el string en la memoria flash liberando la memoria dinamica
    delay(5000);
  }
}

void loop() {
  
  temp = sensorTemp.readTemperature();
  hum = sensorTemp.readHumidity();
  Serial.print(F("Temperatura: "));Serial.println(temp);
  Serial.print(F("Humedad....: "));Serial.println(hum);
  Serial.println();

  float correctedRZero = mq135_sensor.getCorrectedRZero(temp, hum); // Devuelve el valor del "R0", que es la resistencia básica del sensor en aire limpio. Este valor es crítico para la calibración., pero ajustado según la temperatura y humedad, lo cual es muy útil en entornos donde estas variables fluctúan.
  float resistance = mq135_sensor.getResistance(); //Obtiene la resistencia del sensor en función de la lectura analógica.
  float correctedPPM = mq135_sensor.getCorrectedPPM(temp, hum); //Este método ajusta la lectura del sensor usando las correcciones basadas en la temperatura y la humedad, lo cual es crucial, ya que la resistencia del sensor cambia con estas condiciones.
  Serial.print(F("Corrected PPM: "));Serial.println(correctedPPM);
  voltage = getVoltage(gasSensor);
  resistencia = 1000 * ((5.0 - voltage) / voltage);
  dioxidoDeCarbono = 25 * pow(resistencia  / 5463, -2.26);
  
  Serial.print(F("Dioxido de Carbono: "));Serial.println(dioxidoDeCarbono);
  delay(10000);
}

float getVoltage(int pin){
  return (analogRead(pin) * 0.004882814);
   // This equation converts the 0 to 1023 value that analogRead()
  // returns, into a 0.0 to 5.0 value that is the true voltage
  // being read at that pin.
}

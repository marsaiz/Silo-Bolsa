//COMPILAR CON WEMOS D1 MINI PRO
// Y= A * POW (X,B)


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
#define a 5.58
#define b -0.365

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
  Serial.println("Formulas libreria");
  float rzero = mq135_sensor.getRZero();
  float correctedRZero = mq135_sensor.getCorrectedRZero(temp, hum); // Devuelve el valor del "R0", que es la resistencia básica del sensor en aire limpio. Este valor es crítico para la calibración., pero ajustado según la temperatura y humedad, lo cual es muy útil en entornos donde estas variables fluctúan.
  float resistance = mq135_sensor.getResistance(); //Obtiene la resistencia del sensor en función de la lectura analógica.
  float ppm = mq135_sensor.getPPM();
  float correctedPPM = mq135_sensor.getCorrectedPPM(temp, hum); //Este método ajusta la lectura del sensor usando las correcciones basadas en la temperatura y la humedad, lo cual es crucial, ya que la resistencia del sensor cambia con estas condiciones.
  Serial.print(F("MQ135 RZero: "));
  Serial.print(rzero);
  Serial.print(F("\t Corrected RZero: "));
  Serial.print(correctedRZero);
  Serial.print(F("\t Resistance: "));
  Serial.print(resistance);
  Serial.print(F("\t PPM: "));
  Serial.print(ppm);
  Serial.print(F("\t Corrected PPM: "));Serial.println(correctedPPM);
  Serial.println(F("*********************"));
  Serial.println(F("Formulas manuales"));
   
  voltage = getVoltage(gasSensor);
  resistencia = 1000 * ((5.0 - voltage) / voltage);
  dioxidoDeCarbono = 245 * pow(resistencia  / 5463, -2.26);
  float dioxidoDeCarbonoNueva = pow(resistencia  / a, -b);
  Serial.print("Voltaje");Serial.println(voltage);
  Serial.print("Resistencia: ");
  Serial.println(resistencia);
  Serial.print(F("Dioxido de Carbono: "));Serial.println(dioxidoDeCarbono);
  Serial.print(F("Dioxido de Carbono Nueva: "));Serial.println(dioxidoDeCarbonoNueva);
  delay(10000);
}

float getVoltage(int pin){
  return (analogRead(pin) * 0.0032258);
   // This equation converts the 0 to 1023 value that analogRead()
  // returns, into a 0.0 to 5.0 value that is the true voltage
  // being read at that pin.
}

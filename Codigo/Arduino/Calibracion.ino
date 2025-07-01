//COMPILAR CON WEMOS D1 MINI PRO
#include <Adafruit_AHT10.h>
#include <Wire.h>

#define PIN_MQ135 A0

Adafruit_AHT10 aht;

float temp = 0.00;
float hum = 0.00;

//MQ135 mq135_sensor(PIN_MQ135);
const int gasSensor = 0;
double voltage;
double resistencia;
double dioxidoDeCarbono;
double dioxidoDeCarbono1;

//For CO2, if we measure points graph and do power regression we can obtain the function
//ppm = 116.6020682 (Rs/Ro)^-2.769034857

double a= 116.6020682;
double a1= 56.0820;

//el exponente es negativo pero para calcular usando Pow hago el reciproco
//de la potencia positiva,
double b= 2.769034857;
double b1= 5.9603; 
double Ro= 29619.36495; 
double Ro1= 34037.18774;
 
void setup() {
  Serial.begin(115200);
  if (! aht.begin()) {
    Serial.println("Could not find AHT10? Check wiring");
    while (1) delay(10);
  }
  Serial.println("AHT10 found");
  Serial.println("Voltage, Resistencia, CO2 PPM, RH, Temp");
  
}

void loop() {

  sensors_event_t humidity, temp;
  aht.getEvent(&humidity, &temp);
 
  voltage = getVoltage(PIN_MQ135);
  resistencia = 1000.0 * ((5.0 - voltage) / voltage);
  dioxidoDeCarbono = a * ( 1.0 / pow( (resistencia/Ro), b));
  dioxidoDeCarbono1 = a1 * ( 1.0 / pow( (resistencia/Ro1), b1));
  
  Serial.print(voltage,5);
  Serial.print(";");
  Serial.print(resistencia,5);
  Serial.print(";");
  Serial.print(dioxidoDeCarbono,5);
  Serial.print(";");
  Serial.print(dioxidoDeCarbono1,5);
  Serial.print(";");
  Serial.print(humidity.relative_humidity,5);
  Serial.print(";");
  Serial.println(temp.temperature,5);
  
  delay(5000);
}

double getVoltage(int pin)
{
  return ((analogRead(pin)/1023.0) * 3.3);
   // This equation converts the 0 to 1023 value that analogRead()
  // returns, into a 0.0 to 3.3 value that is the true voltage
  // being read at that pin.
}

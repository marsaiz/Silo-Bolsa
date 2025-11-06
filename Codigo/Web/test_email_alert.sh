#!/bin/bash

# Script para probar el envío de emails de alertas
# El sistema envía email automáticamente cuando detecta condiciones extremas

# Configuración
API_URL="https://remarkable-healing-production.up.railway.app"
ID_CAJA="066cd7cc-0cc7-4800-af0b-290a86639117"  # Caja del silo de trigo

# Límites del grano TRIGO (idGrano: 1):
# - Temperatura: 5°C a 50°C
# - Humedad: 5% a 50%
# - CO2: 400 ppm a 800 ppm

echo "════════════════════════════════════════════════════════════"
echo "🧪 TEST 1: Lectura NORMAL (NO debería enviar email)"
echo "════════════════════════════════════════════════════════════"
echo "Valores dentro de rango: Temp=25°C, Humedad=30%, CO2=600ppm"
echo ""

curl -X POST "$API_URL/api/lecturas" \
  -H "Content-Type: application/json" \
  -d '{
    "fechaHoraLectura": "'"$(date -u +%Y-%m-%dT%H:%M:%S)Z"'",
    "temp": 25,
    "humedad": 30,
    "dioxidoDeCarbono": 600,
    "idCaja": "'"$ID_CAJA"'"
  }' && echo -e "\n✅ Lectura normal enviada\n" || echo -e "\n❌ Error\n"

sleep 2

echo "════════════════════════════════════════════════════════════"
echo "🚨 TEST 2: TEMPERATURA ALTA (SÍ debería enviar email)"
echo "════════════════════════════════════════════════════════════"
echo "Temperatura: 55°C (máximo: 50°C) ⚠️"
echo ""

curl -X POST "$API_URL/api/lecturas" \
  -H "Content-Type: application/json" \
  -d '{
    "fechaHoraLectura": "'"$(date -u +%Y-%m-%dT%H:%M:%S)Z"'",
    "temp": 55,
    "humedad": 30,
    "dioxidoDeCarbono": 600,
    "idCaja": "'"$ID_CAJA"'"
  }' && echo -e "\n✅ Alerta de temperatura enviada\n" || echo -e "\n❌ Error\n"

sleep 2

echo "════════════════════════════════════════════════════════════"
echo "🚨 TEST 3: HUMEDAD ALTA (SÍ debería enviar email)"
echo "════════════════════════════════════════════════════════════"
echo "Humedad: 65% (máximo: 50%) ⚠️"
echo ""

curl -X POST "$API_URL/api/lecturas" \
  -H "Content-Type: application/json" \
  -d '{
    "fechaHoraLectura": "'"$(date -u +%Y-%m-%dT%H:%M:%S)Z"'",
    "temp": 25,
    "humedad": 65,
    "dioxidoDeCarbono": 600,
    "idCaja": "'"$ID_CAJA"'"
  }' && echo -e "\n✅ Alerta de humedad enviada\n" || echo -e "\n❌ Error\n"

sleep 2

echo "════════════════════════════════════════════════════════════"
echo "🚨 TEST 4: TEMPERATURA BAJA (SÍ debería enviar email)"
echo "════════════════════════════════════════════════════════════"
echo "Temperatura: 2°C (mínimo: 5°C) ⚠️"
echo ""

curl -X POST "$API_URL/api/lecturas" \
  -H "Content-Type: application/json" \
  -d '{
    "fechaHoraLectura": "'"$(date -u +%Y-%m-%dT%H:%M:%S)Z"'",
    "temp": 2,
    "humedad": 30,
    "dioxidoDeCarbono": 600,
    "idCaja": "'"$ID_CAJA"'"
  }' && echo -e "\n✅ Alerta de temperatura baja enviada\n" || echo -e "\n❌ Error\n"

sleep 2

echo "════════════════════════════════════════════════════════════"
echo "🚨 TEST 5: MÚLTIPLES CONDICIONES EXTREMAS"
echo "════════════════════════════════════════════════════════════"
echo "Temp: 60°C, Humedad: 70%, CO2: 600ppm ⚠️⚠️"
echo ""

curl -X POST "$API_URL/api/lecturas" \
  -H "Content-Type: application/json" \
  -d '{
    "fechaHoraLectura": "'"$(date -u +%Y-%m-%dT%H:%M:%S)Z"'",
    "temp": 60,
    "humedad": 70,
    "dioxidoDeCarbono": 600,
    "idCaja": "'"$ID_CAJA"'"
  }' && echo -e "\n✅ Alerta múltiple enviada\n" || echo -e "\n❌ Error\n"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "📊 RESUMEN"
echo "════════════════════════════════════════════════════════════"
echo "Test 1: Lectura normal - NO alerta"
echo "Test 2-5: Condiciones extremas - SÍ alertas"
echo ""
echo "📧 Revisa el email: marcelosaizestudio@gmail.com"
echo "📋 Verifica alertas en:"
echo "   $API_URL/api/alertas"
echo ""
echo "💡 Nota: Solo se envía 1 email por silo hasta que"
echo "   las condiciones vuelvan a la normalidad."
echo "════════════════════════════════════════════════════════════"

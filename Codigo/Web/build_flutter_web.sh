#!/bin/bash

# Script para compilar Flutter Web y copiar a wwwroot
# Uso: ./build_flutter_web.sh

set -e  # Salir si hay errores

echo "🚀 Compilando Flutter Web con base-href /flutter/..."
cd ../Flutter/silo_bolsa_flutter
flutter build web --release --base-href /flutter/

echo "📦 Copiando archivos a wwwroot/flutter..."
cd ../../Web
rm -rf SiloBolsa.Api/wwwroot/flutter
cp -r ../Flutter/silo_bolsa_flutter/build/web SiloBolsa.Api/wwwroot/flutter

echo "✅ Flutter Web compilado y copiado exitosamente!"
echo "📍 Accesible en: http://localhost:8080/flutter/index.html"

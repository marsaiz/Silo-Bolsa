#!/bin/bash

# Script para compilar Flutter Web y copiar a wwwroot
# Uso: ./build_flutter_web.sh

set -e  # Salir si hay errores

echo "🚀 Compilando Flutter Web..."
cd ../Flutter/silo_bolsa_flutter
flutter build web --release

echo "📦 Copiando archivos a wwwroot/flutter..."
cd ../../Web
mkdir -p SiloBolsa.Api/wwwroot/flutter
cp -r ../Flutter/silo_bolsa_flutter/build/web/* SiloBolsa.Api/wwwroot/flutter/

echo "✅ Flutter Web compilado y copiado exitosamente!"
echo "📍 Accesible en: http://localhost:8080/flutter/index.html"

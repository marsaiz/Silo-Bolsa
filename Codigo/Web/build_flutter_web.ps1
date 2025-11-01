# Compilar Flutter Web y copiarlo a wwwroot/flutter (Windows PowerShell)
# Uso: powershell -NoProfile -ExecutionPolicy Bypass -File .\Codigo\Web\build_flutter_web.ps1

$ErrorActionPreference = 'Stop'

# Rutas
$flutterProject = Join-Path $PSScriptRoot '..\Flutter\silo_bolsa_flutter'
$flutterBuild = Join-Path $flutterProject 'build\web'
$apiFlutterDst = Join-Path $PSScriptRoot 'SiloBolsa.Api\wwwroot\flutter'

Write-Host "🚀 Compilando Flutter Web con base-href /flutter/..."
Push-Location $flutterProject
flutter build web --release --base-href /flutter/
Pop-Location

Write-Host "📦 Copiando archivos a wwwroot/flutter..."
if (Test-Path $apiFlutterDst) {
  Remove-Item -Recurse -Force $apiFlutterDst
}
New-Item -ItemType Directory -Path $apiFlutterDst | Out-Null
Copy-Item -Recurse -Force (Join-Path $flutterBuild '*') $apiFlutterDst

Write-Host "✅ Flutter Web compilado y copiado exitosamente!"
Write-Host "📍 Accesible en: /flutter/index.html"

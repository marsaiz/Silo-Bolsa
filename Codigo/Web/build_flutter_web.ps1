# Compilar Flutter Web y copiarlo a wwwroot/flutter (Windows PowerShell)
# Uso: powershell -NoProfile -ExecutionPolicy Bypass -File .\Codigo\Web\build_flutter_web.ps1

$ErrorActionPreference = 'Stop'

# Rutas
$flutterProject = Join-Path $PSScriptRoot '..\Flutter\silo_bolsa_flutter'
$flutterBuild = Join-Path $flutterProject 'build\web'
$apiFlutterDst = Join-Path $PSScriptRoot 'SiloBolsa.Api\wwwroot\flutter'

Write-Host "Compilando Flutter Web con base-href /flutter/..." -ForegroundColor Cyan
Push-Location $flutterProject
flutter build web --release --base-href /flutter/
Pop-Location

Write-Host "Copiando archivos a wwwroot/flutter..." -ForegroundColor Cyan
if (Test-Path $apiFlutterDst) {
  Remove-Item -Recurse -Force $apiFlutterDst
}
New-Item -ItemType Directory -Path $apiFlutterDst -Force | Out-Null
Copy-Item -Path "$flutterBuild\*" -Destination $apiFlutterDst -Recurse -Force

Write-Host "Flutter Web compilado y copiado exitosamente!" -ForegroundColor Green
Write-Host "Accesible en: /flutter/index.html" -ForegroundColor Green

# 🚀 Flutter Web - Despliegue en Railway

## 📋 Descripción
Este proyecto Flutter se compila a Web y se sirve desde la API ASP.NET Core en Railway.

## 🛠️ Desarrollo Local

### Compilar Flutter Web manualmente:
```bash
cd Codigo/Flutter/silo_bolsa_flutter
flutter build web --release
```

### Usar el script automatizado:
```bash
cd Codigo/Web
./build_flutter_web.sh
```

Este script:
1. Compila Flutter Web en modo release
2. Copia los archivos a `wwwroot/flutter/`
3. Los archivos quedan disponibles en `http://localhost:8080/flutter/index.html`

## 🚢 Despliegue en Railway

El Dockerfile está configurado para:
1. **Instalar Flutter SDK** durante el build
2. **Compilar automáticamente** Flutter Web (`flutter build web --release`)
3. **Copiar los archivos** compilados a `wwwroot/flutter/`

### Railway compilará y desplegará automáticamente cuando hagas push de:
- Archivos `.dart` en `Codigo/Flutter/`
- Archivos `.cs` en `Codigo/Web/`
- `pubspec.yaml` (dependencias de Flutter)
- `Dockerfile`

## 🌐 URLs de Acceso

### Local:
- Dashboard original: `http://localhost:8080/`
- Flutter Web: `http://localhost:8080/flutter/index.html`

### Producción (Railway):
- Dashboard original: `https://tu-app.railway.app/`
- Flutter Web: `https://tu-app.railway.app/flutter/index.html`

## 📦 Archivos Ignorados

Los siguientes archivos NO se suben a Git (ver `.gitignore`):
- `build/web/` - Archivos compilados de Flutter
- `wwwroot/flutter/` - Archivos servidos desde la API

**¿Por qué?** Se generan automáticamente en cada build (local o Railway).

## 🔧 Configuración de la API

El servidor .NET ya está configurado para servir archivos estáticos desde `wwwroot/`:

```csharp
app.UseDefaultFiles();
app.UseStaticFiles();
```

Esto permite acceder a:
- `/flutter/index.html` → Aplicación Flutter
- `/flutter/assets/` → Assets de Flutter
- Cualquier archivo en `wwwroot/`

## 🐛 Troubleshooting

### Error: "Failed to load Flutter Web"
1. Verificar que Flutter Web se compiló: `ls Codigo/Flutter/silo_bolsa_flutter/build/web/`
2. Verificar archivos en wwwroot: `ls Codigo/Web/SiloBolsa.Api/wwwroot/flutter/`
3. Recompilar: `./build_flutter_web.sh`

### Railway no sirve Flutter:
1. Verificar logs de Railway para errores de compilación de Flutter
2. Asegurar que el Dockerfile instala Flutter correctamente
3. Verificar que `COPY --from=build` en Dockerfile incluye `/wwwroot/flutter`

## 📚 Dependencias Flutter

Ver `pubspec.yaml` para todas las dependencias. Principales:
- `fl_chart` - Gráficos interactivos
- `http` - Llamadas a la API
- `intl` - Formateo de fechas

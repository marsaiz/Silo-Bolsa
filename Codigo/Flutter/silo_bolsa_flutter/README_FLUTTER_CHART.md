# Flutter Web y fl_chart - Guía de Aprendizaje

## 📱 ¿Qué es Flutter Web?

Flutter Web es una extensión de Flutter que permite crear aplicaciones web usando el mismo código que usarías para aplicaciones móviles. En lugar de compilar a código nativo iOS/Android, Flutter Web compila tu código Dart a JavaScript optimizado que corre en el navegador.

### Ventajas de Flutter Web

- **Un solo código base**: El mismo código Dart funciona en web, iOS, Android, Windows, macOS y Linux
- **Hot Reload**: Recarga instantánea durante el desarrollo
- **Widgets**: Usa los mismos widgets que en móvil
- **Rendimiento**: Compila a JavaScript optimizado (o WebAssembly con --wasm)

### Cómo funciona este proyecto

```bash
# Compilar para web (desde el directorio del proyecto Flutter)
flutter build web --release --base-href /flutter/

# El resultado se genera en: build/web/
# Luego se copia a: Codigo/Web/SiloBolsa.Api/wwwroot/flutter/
```

**Importante**: El parámetro `--base-href /flutter/` le dice a Flutter que la app se servirá desde `/flutter/` en lugar de la raíz del sitio. Esto es necesario porque nuestra API ASP.NET Core sirve la web desde esa ruta.

---

## 📊 fl_chart - Librería de Gráficos

`fl_chart` es una librería de Flutter para crear gráficos hermosos y animados. Es 100% Dart/Flutter (no usa librerías nativas).

### Instalación

En `pubspec.yaml`:
```yaml
dependencies:
  fl_chart: ^0.69.2
```

### Tipos de Gráficos Soportados

- **LineChart**: Gráfico de líneas (el que usamos)
- **BarChart**: Gráfico de barras
- **PieChart**: Gráfico circular/torta
- **ScatterChart**: Gráfico de dispersión
- **RadarChart**: Gráfico de radar

---

## 🎯 LineChart - Nuestro Caso de Uso

### Estructura Básica

```dart
import 'package:fl_chart/fl_chart.dart';

LineChart(
  LineChartData(
    // Configuración de títulos de ejes
    titlesData: FlTitlesData(...),
    
    // Límites del gráfico
    minX: 0,
    maxX: 10,
    minY: 0,
    maxY: 100,
    
    // Grid (cuadrícula de fondo)
    gridData: FlGridData(show: true),
    
    // Series de datos (las líneas)
    lineBarsData: [
      LineChartBarData(...),
      LineChartBarData(...),
    ],
  ),
)
```

### FlSpot - Puntos de Datos

Cada punto en el gráfico es un `FlSpot(x, y)`:

```dart
List<FlSpot> temperatureData = [
  FlSpot(0, 25.5),  // x=0, y=25.5°C
  FlSpot(1, 26.2),  // x=1, y=26.2°C
  FlSpot(2, 24.8),  // x=2, y=24.8°C
];
```

En nuestro proyecto:
- **X**: Índice de la lectura (0, 1, 2, 3...)
- **Y**: Valor del sensor (temperatura, humedad)

### LineChartBarData - Serie de Datos

Cada línea en el gráfico es un `LineChartBarData`:

```dart
LineChartBarData(
  spots: temperatureData,     // Puntos de la línea
  isCurved: true,              // Línea curva vs. recta
  color: Colors.red,           // Color de la línea
  barWidth: 3,                 // Grosor de la línea
  dotData: FlDotData(show: false), // No mostrar puntos individuales
  belowBarData: BarAreaData(show: false), // Sin área bajo la línea
)
```

---

## 🔧 Configuración de Ejes

### Eje X (bottomTitles)

```dart
bottomTitles: AxisTitles(
  sideTitles: SideTitles(
    showTitles: true,
    reservedSize: 40,           // Espacio reservado para etiquetas
    interval: 5,                 // Mostrar etiqueta cada 5 puntos
    getTitlesWidget: (value, meta) {
      // Función que genera el widget de etiqueta
      return Text('${value.toInt()}');
    },
  ),
),
```

En nuestro proyecto usamos `getTitlesWidget` para mostrar horas en lugar de números:

```dart
getTitlesWidget: (value, meta) {
  final index = value.toInt();
  final dateTime = timestamps[index];
  final formattedTime = DateFormat('HH:mm').format(dateTime);
  return Text(formattedTime);
}
```

### Eje Y (leftTitles)

Similar al eje X pero para valores verticales:

```dart
leftTitles: AxisTitles(
  sideTitles: SideTitles(
    showTitles: true,
    reservedSize: 42,
    interval: 20,  // Etiqueta cada 20 unidades
    getTitlesWidget: (value, meta) {
      return Text(value.toStringAsFixed(0));
    },
  ),
),
```

---

## 📐 Cómo Ajustamos la Escala del Gráfico

### Problema Original

Los sensores tienen valores muy diferentes:
- Temperatura: 0-50°C
- Humedad: 0-100%
- CO2: 400-2000 PPM ⚠️

Si incluimos CO2, el gráfico se "aplasta" porque la escala se ajusta a 2000:

```
2000 |           🟢 (CO2 muy alto)
1500 |         
1000 |       
 500 |     
   0 |🔴🔵_______________ (Temp y Humedad casi no se ven)
```

### Solución Aplicada

1. **Excluir CO2 del cálculo de escala**:
```dart
double _calculateMaxY(List<Lectura> lecturas) {
  double maxTemp = lecturas.map((l) => l.temp).reduce((a, b) => a > b ? a : b);
  double maxHumedad = lecturas.map((l) => l.humedad).reduce((a, b) => a > b ? a : b);
  
  // Solo considerar temp y humedad (NO CO2)
  double overallMax = maxTemp > maxHumedad ? maxTemp : maxHumedad;
  
  // Limitar a 120 máximo
  double limitedMax = overallMax > 120 ? 120.0 : overallMax;
  
  return limitedMax < 50 ? 50.0 : limitedMax;
}
```

2. **Remover CO2 del gráfico** (se ve solo en la tabla)

Resultado:
```
120 |                    
100 |     🔵🔵🔵🔵 (Humedad)
 50 |  🔴🔴🔴🔴 (Temperatura)
  0 |_____________________
```

---

## 🎨 Personalización Visual

### Colores

```dart
LineChartBarData(
  color: Colors.red,           // Color sólido
  // O gradiente:
  gradient: LinearGradient(
    colors: [Colors.red, Colors.orange],
  ),
)
```

### Curvas vs. Líneas Rectas

```dart
isCurved: true,   // Línea suave/curva
isCurved: false,  // Línea recta entre puntos
```

### Puntos de Datos

```dart
dotData: FlDotData(
  show: true,               // Mostrar puntos
  getDotPainter: (spot, percent, barData, index) {
    return FlDotCirclePainter(
      radius: 4,
      color: Colors.blue,
      strokeWidth: 2,
      strokeColor: Colors.white,
    );
  },
)
```

### Área Bajo la Línea

```dart
belowBarData: BarAreaData(
  show: true,
  color: Colors.blue.withOpacity(0.3), // Semi-transparente
)
```

---

## 🌐 Integración con API REST

### Flujo de Datos en Nuestro Proyecto

1. **API devuelve JSON**:
```json
[
  {
    "fechaHoraLectura": "2025-11-03T10:30:00Z",
    "temp": 25.5,
    "humedad": 65.0,
    "dioxidoDeCarbono": 450.0
  }
]
```

2. **Modelo Dart** (`lectura_model.dart`):
```dart
class Lectura {
  final DateTime fechaHoraLectura;
  final double temp;
  final double humedad;
  final double dioxidoDeCarbono;

  factory Lectura.fromJson(Map<String, dynamic> json) {
    return Lectura(
      fechaHoraLectura: DateTime.parse(json['fechaHoraLectura']),
      temp: (json['temp'] as num).toDouble(),
      humedad: (json['humedad'] as num).toDouble(),
      dioxidoDeCarbono: (json['dioxidoDeCarbono'] as num).toDouble(),
    );
  }
}
```

3. **Servicio API** (`api_service.dart`):
```dart
Future<List<Lectura>> fetchLecturas() async {
  final response = await http.get(Uri.parse('$baseUrl/api/lecturas/silo/$idSilo'));
  
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Lectura.fromJson(json)).toList();
  } else {
    throw Exception('Error al cargar lecturas');
  }
}
```

4. **Convertir a FlSpot**:
```dart
List<FlSpot> _getSpotsForType(List<Lectura> lecturas, String type) {
  final sorted = [...lecturas]
    ..sort((a, b) => a.fechaHoraLectura.compareTo(b.fechaHoraLectura));

  return sorted.asMap().entries.map((entry) {
    final index = entry.key;
    final lectura = entry.value;
    double value = type == 'temp' ? lectura.temp : lectura.humedad;
    
    return FlSpot(index.toDouble(), value);
  }).toList();
}
```

5. **Usar FutureBuilder**:
```dart
FutureBuilder<List<Lectura>>(
  future: _futureLecturas,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    
    final lecturas = snapshot.data!;
    final tempSpots = _getSpotsForType(lecturas, 'temp');
    final humedadSpots = _getSpotsForType(lecturas, 'humedad');
    
    return LineChart(...);
  },
)
```

---

## 📱 Responsive Design

### Scroll Horizontal para Muchos Datos

```dart
final double screenWidth = MediaQuery.of(context).size.width;
final double requiredWidth = (lecturas.length * 50.0) + 32.0;
final double chartWidth = requiredWidth > screenWidth 
    ? requiredWidth 
    : screenWidth - 32;

SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: SizedBox(
    width: chartWidth,
    child: LineChart(...),
  ),
)
```

### AspectRatio para Mantener Proporciones

```dart
AspectRatio(
  aspectRatio: 2.7,  // Ancho / Alto = 2.7
  child: LineChart(...),
)
```

---

## 🛠️ Debugging y Consejos

### Ver los Datos en Consola

```dart
print('Temp spots: ${tempSpots.map((s) => '(${s.x}, ${s.y})').join(', ')}');
```

### Validar Límites

```dart
// Asegurar que maxX y maxY sean válidos
assert(maxX >= 0);
assert(maxY > 0);
assert(tempSpots.isNotEmpty);
```

### Hot Reload en Web

Durante desarrollo, en lugar de `flutter build web`, usa:

```bash
flutter run -d chrome
```

Esto te permite ver cambios instantáneamente con Hot Reload (R en la terminal).

### Chrome DevTools

En Chrome, presiona F12 para ver:
- Errores de JavaScript
- Network (llamadas a la API)
- Performance (rendimiento del gráfico)

---

## 📚 Recursos Adicionales

### Documentación Oficial

- **Flutter Web**: https://docs.flutter.dev/platform-integration/web
- **fl_chart**: https://pub.dev/packages/fl_chart
- **fl_chart ejemplos**: https://github.com/imaNNeo/fl_chart/tree/main/example

### Tutoriales Recomendados

1. **Flutter Web Tutorial**: https://www.youtube.com/watch?v=_wFVRzvydI8
2. **fl_chart Complete Guide**: https://medium.com/@info_67212/flutter-charts-with-fl-chart-5c7a9d9c4d4e

### Packages Relacionados

- **http**: Para llamadas a API REST
- **intl**: Para formatear fechas/números
- **provider**: State management (alternativa a setState)

---

## 🎯 Próximos Pasos para Aprender Más

1. **Experimenta con otros tipos de gráficos**:
   ```dart
   import 'package:fl_chart/fl_chart.dart';
   
   BarChart(...) // Gráfico de barras
   PieChart(...) // Gráfico circular
   ```

2. **Añade interactividad**:
   ```dart
   LineTouchData(
     enabled: true,
     touchTooltipData: LineTouchTooltipData(
       tooltipBgColor: Colors.blueAccent,
       getTooltipItems: (touchedSpots) {
         return touchedSpots.map((spot) {
           return LineTooltipItem(
             '${spot.y.toStringAsFixed(1)}°C',
             TextStyle(color: Colors.white),
           );
         }).toList();
       },
     ),
   )
   ```

3. **Agrega animaciones**:
   ```dart
   LineChart(
     sampleData,
     duration: Duration(milliseconds: 250),
     curve: Curves.easeInOut,
   )
   ```

4. **Crea gráficos personalizados**: Extiende `CustomPainter` para gráficos completamente personalizados.

---

## 💡 Preguntas Frecuentes

**P: ¿Por qué mi gráfico se ve vacío?**  
R: Verifica que `maxX` y `maxY` sean mayores que 0 y que tus `FlSpot` tengan valores válidos.

**P: ¿Cómo hago zoom en el gráfico?**  
R: Usa `InteractiveViewer` alrededor del `LineChart` o implementa `LineTouchData` con gestos personalizados.

**P: ¿Puedo usar fl_chart en producción?**  
R: Sí, fl_chart es estable y se usa en muchas apps de producción.

**P: ¿Cómo actualizo el gráfico en tiempo real?**  
R: Usa `StreamBuilder` en lugar de `FutureBuilder` y conecta a un WebSocket o usa polling con `Timer.periodic`.

---

¡Esperamos que esta guía te ayude a entender mejor Flutter Web y fl_chart! 🚀

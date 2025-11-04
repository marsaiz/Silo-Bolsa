// Archivo: lib/line_chart_widget.dart (Version actualizada)

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SensorLineChart extends StatelessWidget {
  final List<FlSpot> tempSpots;
  final List<FlSpot> humedadSpots;
  final double maxX;
  final double maxY;
  final List<DateTime> timestamps; // Nueva lista de marcas de tiempo

  const SensorLineChart({
    super.key,
    required this.tempSpots,
    required this.humedadSpots,
    required this.maxX,
    required this.maxY,
    required this.timestamps, // Recibe las marcas de tiempo
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      // Gráfico más bajo para que quepa sin scroll vertical
      aspectRatio: 2.5,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12, // Dar más espacio para la etiqueta rotada
        ),
        child: LineChart(
          sensorData(), // Llama a la función con los datos reales
        ),
      ),
    );
  }

  LineChartData sensorData() {
    return LineChartData(
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        // Configuración Eje X (inferior)
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40, // Más espacio para la rotación
            // Mostrar más etiquetas: cada 3 puntos en lugar de cada 5
            interval: (maxX / 20).ceilToDouble().clamp(1.0, double.infinity), 
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        // Configuración Eje Y (izquierdo)
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            // Usamos maxY para calcular el intervalo (ej. 5 divisiones)
            interval: (maxY / 5).ceilToDouble(), 
            reservedSize: 42,
            getTitlesWidget: leftTitleWidgets,
          ),
        ),
      ),
      
      // Ajustar límites de la gráfica al número de lecturas
      minX: 0,
      maxX: maxX, 
      minY: 0,
      maxY: maxY, // <--- Usa el valor dinámico recibido
      
      gridData: const FlGridData(show: false), 

      // **Series de Datos: Solo Temperatura y Humedad**
      lineBarsData: [
        LineChartBarData(
          spots: tempSpots,
          isCurved: true, 
          color: Colors.red,
          barWidth: 3,
          dotData: FlDotData(
            show: true,
            checkToShowDot: (spot, barData) {
              // Mostrar punto solo en primero, último, máximo y mínimo
              return _shouldShowDot(spot, tempSpots);
            },
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 5,
                color: Colors.red,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          // Mostrar etiquetas con valores en puntos clave
          showingIndicators: _getIndicatorsIndexes(tempSpots),
        ),
        LineChartBarData(
          spots: humedadSpots,
          isCurved: true,
          color: Colors.blue,
          barWidth: 3,
          dotData: FlDotData(
            show: true,
            checkToShowDot: (spot, barData) {
              return _shouldShowDot(spot, humedadSpots);
            },
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 5,
                color: Colors.blue,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          showingIndicators: _getIndicatorsIndexes(humedadSpots),
        ),
      ],
      
      // Configurar tooltips con valores
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final isTempLine = spot.barIndex == 0;
              final label = isTempLine ? 'Temp' : 'Hum';
              final unit = isTempLine ? '°C' : '%';
              
              return LineTooltipItem(
                '$label: ${spot.y.toStringAsFixed(1)}$unit',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                children: [
                  TextSpan(
                    text: '\n${DateFormat('HH:mm').format(timestamps[spot.x.toInt()])}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
    );
  }

  // EJE X: Muestra las marcas de tiempo
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 10);
    Widget text = const Text(''); // Inicializar por defecto como vacío

    // Convertir el índice (value) a entero
    final index = value.toInt();

   // Solo mostramos etiquetas en los intervalos definidos por meta.sideTitles.interval
   if (index >= 0 && index < timestamps.length && index % meta.sideTitles.interval!.toInt() == 0) {
    final dateTime = timestamps[index];
      
    // Formatear la hora (HH:mm)
    final formattedTime = DateFormat('HH:mm').format(dateTime);

    // Si es el primer o último punto, mostrar también la fecha
    if (index == 0 || index == maxX.toInt()) {
      final formattedDate = DateFormat('dd/MM\nHH:mm').format(dateTime);
      text = Text(formattedDate, style: style, textAlign: TextAlign.center);
    } else {
      text = Text(formattedTime, style: style, textAlign: TextAlign.center);
    }
   }

    return SideTitleWidget(
        meta: meta, 
        // Rotar el texto 60 grados para evitar superposición
        angle: 60 * 3.14159 / 180,
        child: text, 
    );
  }

  // EJE Y: Muestra los valores de los sensores
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    
    // Solo muestra títulos si el valor es un múltiplo del intervalo (evita demasiadas etiquetas)
    if (value % meta.sideTitles.interval! != 0) {
      return Container();
    }

    String text = value.toStringAsFixed(0); // Mostrar valor sin decimales
    
    return SideTitleWidget(
        meta: meta,
        child: Text(text, style: style, textAlign: TextAlign.left), 
    );
  }

  // Determinar si mostrar punto (primero, último, máximo, mínimo)
  bool _shouldShowDot(FlSpot spot, List<FlSpot> spots) {
    if (spots.isEmpty) return false;
    
    final index = spot.x.toInt();
    final firstIndex = spots.first.x.toInt();
    final lastIndex = spots.last.x.toInt();
    
    // Encontrar índices de máximo y mínimo
    double maxValue = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    double minValue = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    
    int maxIndex = spots.indexWhere((s) => s.y == maxValue);
    int minIndex = spots.indexWhere((s) => s.y == minValue);
    
    // Mostrar punto si es primero, último, máximo o mínimo
    return index == firstIndex || 
           index == lastIndex || 
           index == maxIndex || 
           index == minIndex;
  }

  // Obtener índices para mostrar indicadores (líneas verticales en puntos clave)
  List<int> _getIndicatorsIndexes(List<FlSpot> spots) {
    if (spots.isEmpty) return [];
    
    List<int> indexes = [];
    
    // Primero y último
    indexes.add(spots.first.x.toInt());
    indexes.add(spots.last.x.toInt());
    
    // Máximo y mínimo
    double maxValue = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    double minValue = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    
    int maxIndex = spots.indexWhere((s) => s.y == maxValue);
    int minIndex = spots.indexWhere((s) => s.y == minValue);
    
    if (!indexes.contains(maxIndex)) indexes.add(maxIndex);
    if (!indexes.contains(minIndex)) indexes.add(minIndex);
    
    return indexes;
  }
}
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
      // Usar AspectRatio para mantener la proporción, lo que ayuda a la adaptabilidad
      aspectRatio: 2.7,
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
            // Intervalo: muestra una etiqueta cada 1/5 del total de puntos (ej. cada 5 puntos)
            interval: (maxX / 5).ceilToDouble(), 
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
          dotData: const FlDotData(show: false),
        ),
        LineChartBarData(
          spots: humedadSpots,
          isCurved: true,
          color: Colors.blue,
          barWidth: 3,
          dotData: const FlDotData(show: false),
        ),
      ],
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
        child: text,
        meta: meta, 
        // Rotar el texto 60 grados para evitar superposición
        angle: 60 * 3.14159 / 180, 
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
        child: Text(text, style: style, textAlign: TextAlign.left),
        meta: meta, 
    );
  }
}
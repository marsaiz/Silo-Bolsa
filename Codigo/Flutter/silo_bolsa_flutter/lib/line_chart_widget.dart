// Archivo: lib/line_chart_widget.dart (con soporte de zoom/pan)

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SensorLineChart extends StatefulWidget {
  final List<FlSpot> tempSpots;
  final List<FlSpot> humedadSpots;
  final double maxX;
  final double maxY;
  final List<DateTime> timestamps; // Marcas de tiempo alineadas con X

  const SensorLineChart({
    super.key,
    required this.tempSpots,
    required this.humedadSpots,
    required this.maxX,
    required this.maxY,
    required this.timestamps,
  });

  @override
  State<SensorLineChart> createState() => _SensorLineChartState();
}

class _SensorLineChartState extends State<SensorLineChart> {
  // Control del zoom/pan
  final TransformationController _tx = TransformationController();

  static const double _minScale = 0.9;
  static const double _maxScale = 6.0;

  void _resetZoom() {
    _tx.value = Matrix4.identity();
    setState(() {});
  }

  @override
  void dispose() {
    _tx.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.5,
      child: Stack(
        children: [
          // Doble click/tap para resetear zoom rápido
          GestureDetector(
            onDoubleTap: _resetZoom,
            child: InteractiveViewer(
              transformationController: _tx,
              minScale: _minScale,
              maxScale: _maxScale,
              panEnabled: true,
              scaleEnabled: true,
              boundaryMargin: const EdgeInsets.all(48),
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 18,
                  left: 12,
                  top: 24,
                  bottom: 12,
                ),
                child: LineChart(sensorData()),
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: Material(
              color: Colors.black45,
              shape: const StadiumBorder(),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _resetZoom,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.zoom_out_map, size: 16, color: Colors.white),
                      SizedBox(width: 6),
                      Text('Reset', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData sensorData() {
    return LineChartData(
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: (widget.maxX / 20).ceilToDouble().clamp(1.0, double.infinity),
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: (widget.maxY / 5).ceilToDouble(),
            reservedSize: 42,
            getTitlesWidget: leftTitleWidgets,
          ),
        ),
      ),
      minX: 0,
      maxX: widget.maxX,
      minY: 0,
      maxY: widget.maxY,
      gridData: const FlGridData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: widget.tempSpots,
          isCurved: true,
          color: Colors.red,
          barWidth: 3,
          dotData: FlDotData(
            show: true,
            checkToShowDot: (spot, barData) => _shouldShowDot(spot, widget.tempSpots),
            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
              radius: 5,
              color: Colors.red,
              strokeWidth: 2,
              strokeColor: Colors.white,
            ),
          ),
          showingIndicators: _getIndicatorsIndexes(widget.tempSpots),
        ),
        LineChartBarData(
          spots: widget.humedadSpots,
          isCurved: true,
          color: Colors.blue,
          barWidth: 3,
          dotData: FlDotData(
            show: true,
            checkToShowDot: (spot, barData) => _shouldShowDot(spot, widget.humedadSpots),
            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
              radius: 5,
              color: Colors.blue,
              strokeWidth: 2,
              strokeColor: Colors.white,
            ),
          ),
          showingIndicators: _getIndicatorsIndexes(widget.humedadSpots),
        ),
      ],
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
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                children: [
                  TextSpan(
                    text: '\n${DateFormat('HH:mm').format(widget.timestamps[spot.x.toInt()])}',
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
    );
  }

  // Eje X: tiempo
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 10);
    Widget text = const Text('');

    final index = value.toInt();
    if (index >= 0 && index < widget.timestamps.length && index % meta.sideTitles.interval!.toInt() == 0) {
      final dateTime = widget.timestamps[index];
      final formattedTime = DateFormat('HH:mm').format(dateTime);
      if (index == 0 || index == widget.maxX.toInt()) {
        final formattedDate = DateFormat('dd/MM\nHH:mm').format(dateTime);
        text = Text(formattedDate, style: style, textAlign: TextAlign.center);
      } else {
        text = Text(formattedTime, style: style, textAlign: TextAlign.center);
      }
    }

    return SideTitleWidget(
      meta: meta,
      angle: 60 * 3.14159 / 180,
      child: text,
    );
  }

  // Eje Y: valores
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    if (value % meta.sideTitles.interval! != 0) {
      return const SizedBox.shrink();
    }
    final text = value.toStringAsFixed(0);
    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style, textAlign: TextAlign.left),
    );
  }

  bool _shouldShowDot(FlSpot spot, List<FlSpot> spots) {
    if (spots.isEmpty) return false;
    final index = spot.x.toInt();
    final firstIndex = spots.first.x.toInt();
    final lastIndex = spots.last.x.toInt();

    final maxValue = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final minValue = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxIndex = spots.indexWhere((s) => s.y == maxValue);
    final minIndex = spots.indexWhere((s) => s.y == minValue);

    return index == firstIndex || index == lastIndex || index == maxIndex || index == minIndex;
  }

  List<int> _getIndicatorsIndexes(List<FlSpot> spots) {
    if (spots.isEmpty) return [];
    final indexes = <int>[];
    indexes.add(spots.first.x.toInt());
    indexes.add(spots.last.x.toInt());
    final maxValue = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final minValue = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxIndex = spots.indexWhere((s) => s.y == maxValue);
    final minIndex = spots.indexWhere((s) => s.y == minValue);
    if (!indexes.contains(maxIndex)) indexes.add(maxIndex);
    if (!indexes.contains(minIndex)) indexes.add(minIndex);
    return indexes;
  }
}
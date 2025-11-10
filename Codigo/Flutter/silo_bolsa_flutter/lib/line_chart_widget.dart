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
  // NUEVO: Umbrales como constantes estáticas
  static const double temperaturaUmbral = 35.0;
  static const double humedadUmbral = 55.0;

  // Control del zoom/pan
  final TransformationController _tx = TransformationController();

  static const double _minScale = 0.9;
  static const double _maxScale = 6.0;

  // Ventana de datos visibles (zoom por dominio X)
  late int _windowStart;
  late int _windowSize;

  // Datos visibles recalculados
  List<FlSpot> _visTemp = [];
  List<FlSpot> _visHum = [];
  List<DateTime> _visTs = [];
  double _vMaxX = 0;
  double _vMaxY = 100;

  void _resetZoom() {
    _tx.value = Matrix4.identity();
    // Resetear ventana al total
    _windowStart = 0;
    _windowSize = widget.timestamps.length;
    _recomputeWindow();
    setState(() {});
  }

  @override
  void dispose() {
    _tx.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final total = widget.timestamps.length;
    _windowStart = 0;
    // Por defecto mostrar hasta 60 puntos o todo si hay menos
    _windowSize = total < 60 ? total : 60;
    _recomputeWindow();
  }

  void _recomputeWindow() {
    final total = widget.timestamps.length;
    if (total == 0) {
      _visTemp = [];
      _visHum = [];
      _visTs = [];
      _vMaxX = 0;
      _vMaxY = widget.maxY;
      return;
    }
    // Limitar ventana a rango válido
    if (_windowStart < 0) _windowStart = 0;
    if (_windowStart >= total) _windowStart = total - 1;
    if (_windowSize < 5) _windowSize = 5; // mínimo 5 puntos
    if (_windowStart + _windowSize > total) {
      _windowStart = (total - _windowSize).clamp(0, total - 1);
    }

    final end = (_windowStart + _windowSize).clamp(0, total);
    // Recortar y reindexar X a 0..N-1
    _visTemp = widget.tempSpots
        .where((s) => s.x >= _windowStart && s.x < end)
        .map((s) => FlSpot(s.x - _windowStart, s.y))
        .toList();
    _visHum = widget.humedadSpots
        .where((s) => s.x >= _windowStart && s.x < end)
        .map((s) => FlSpot(s.x - _windowStart, s.y))
        .toList();
    _visTs = widget.timestamps.sublist(_windowStart, end);

    _vMaxX = (_visTs.length > 0) ? (_visTs.length - 1).toDouble() : 0;
    // Calcular maxY visible dinámicamente (entre ambas series)
    final allY = [..._visTemp.map((e) => e.y), ..._visHum.map((e) => e.y)];
    allY.add(temperaturaUmbral);
    allY.add(humedadUmbral);

    final maxY = allY.isEmpty
        ? widget.maxY
        : allY.reduce((a, b) => a > b ? a : b);
    // margen 10%
    _vMaxY = (maxY == 0 ? 1 : maxY) * 1.1;
  }

  void _zoomIn() {
    if (_windowSize <= 5) return;
    setState(() {
      _windowSize = (_windowSize * 0.8).round().clamp(
        5,
        widget.timestamps.length,
      );
      _recomputeWindow();
    });
  }

  void _zoomOut() {
    setState(() {
      _windowSize = (_windowSize * 1.25).round().clamp(
        5,
        widget.timestamps.length,
      );
      _recomputeWindow();
    });
  }

  void _panLeft() {
    setState(() {
      final delta = (_windowSize * 0.3).round();
      _windowStart = (_windowStart - delta).clamp(
        0,
        (widget.timestamps.length - _windowSize).clamp(
          0,
          widget.timestamps.length,
        ),
      );
      _recomputeWindow();
    });
  }

  void _panRight() {
    setState(() {
      final delta = (_windowSize * 0.3).round();
      final maxStart = (widget.timestamps.length - _windowSize).clamp(
        0,
        widget.timestamps.length,
      );
      _windowStart = (_windowStart + delta).clamp(0, maxStart);
      _recomputeWindow();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      // Proporción del gráfico
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
                      Text(
                        'Reset',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: Material(
              color: Colors.black45,
              shape: const StadiumBorder(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: _panLeft,
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: _zoomOut,
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: _zoomIn,
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: _panRight,
                    icon: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData sensorData() {
    // ==================================================================
    // ------------------- INICIO: BLOQUE PARA UMBRALES -------------------
    // ==================================================================
    List<HorizontalLine> umbralLines = [];

    umbralLines.add(
      HorizontalLine(
        y: temperaturaUmbral,
        color: Colors.red.shade700.withOpacity(0.6), // Color para Temp
        strokeWidth: 2,
        dashArray: [5, 5],
        label: HorizontalLineLabel(
          show: true,
          alignment: Alignment.topRight,
          padding: const EdgeInsets.only(right: 5, bottom: 2),
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          labelResolver: (line) => 'UMBRAL TEMPERATURA: ${line.y.toStringAsFixed(0)}°C',
        ),
      ),
    );

    umbralLines.add(
      HorizontalLine(
        y: humedadUmbral,
        color: Colors.blue.shade700.withOpacity(0.6), // Color para Humedad
        strokeWidth: 2,
        dashArray: [5, 5],
        label: HorizontalLineLabel(
          show: true,
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.only(right: 5, top: 2),
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          labelResolver: (line) => 'UMBRAL HUMEDAD: ${line.y.toStringAsFixed(0)}%',
        ),
      ),
    );
    // ==================================================================
    // ------------------- FIN: BLOQUE PARA UMBRALES ----------------------
    // ==================================================================

    return LineChartData(
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: (_vMaxX / 8).ceilToDouble().clamp(1.0, double.infinity),
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: (_vMaxY / 5).ceilToDouble(),
            reservedSize: 42,
            getTitlesWidget: leftTitleWidgets,
          ),
        ),
      ),
      minX: 0,
      maxX: _vMaxX,
      minY: 0,
      maxY: _vMaxY,
      gridData: const FlGridData(show: false),
      extraLinesData: ExtraLinesData(
        horizontalLines: umbralLines,
      ),
      lineBarsData: [
        LineChartBarData(
          spots: _visTemp,
          isCurved: true,
          color: Colors.red,
          barWidth: 3,
          dotData: FlDotData(
            show: true,
            checkToShowDot: (spot, barData) => _shouldShowDot(spot, _visTemp),
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
                  radius: 5,
                  color: Colors.red,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
          ),
          showingIndicators: _getIndicatorsIndexes(_visTemp),
        ),
        LineChartBarData(
          spots: _visHum,
          isCurved: true,
          color: Colors.blue,
          barWidth: 3,
          dotData: FlDotData(
            show: true,
            checkToShowDot: (spot, barData) => _shouldShowDot(spot, _visHum),
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
                  radius: 5,
                  color: Colors.blue,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
          ),
          showingIndicators: _getIndicatorsIndexes(_visHum),
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
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                children: [
                  TextSpan(
                    text:
                        '\n${DateFormat('HH:mm').format(_visTs.isEmpty ? DateTime.now() : _visTs[spot.x.toInt().clamp(0, _visTs.length - 1)])}',
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
    if (index >= 0 &&
        index < _visTs.length &&
        index % meta.sideTitles.interval!.toInt() == 0) {
      final dateTime = _visTs[index];
      final formattedTime = DateFormat('HH:mm').format(dateTime);
      if (index == 0 || index == _vMaxX.toInt()) {
        final formattedDate = DateFormat('dd/MM\nHH:mm').format(dateTime);
        text = Text(formattedDate, style: style, textAlign: TextAlign.center);
      } else {
        text = Text(formattedTime, style: style, textAlign: TextAlign.center);
      }
    }

    return SideTitleWidget(meta: meta, angle: 60 * 3.14159 / 180, child: text);
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

    return index == firstIndex ||
        index == lastIndex ||
        index == maxIndex ||
        index == minIndex;
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

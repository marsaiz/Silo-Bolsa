import 'package:flutter/material.dart';
// Importa el widget que acabamos de crear
import 'line_chart_widget.dart';
import 'api_service.dart';
import 'lectura_model.dart';
import 'package:fl_chart/fl_chart.dart'; // Necesario para FlSpot
import 'package:intl/intl.dart'; // Necesario para formatear la fecha

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Lectura>> _futureLecturas;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _futureLecturas = _apiService.fetchLecturas();
  }

  // 1. FUNCIÓN: Calcula el valor máximo de todos los sensores para el eje Y
  double _calculateMaxY(List<Lectura> lecturas) {
    if (lecturas.isEmpty) return 100;

    double maxTemp = lecturas.map((l) => l.temp).reduce((a, b) => a > b ? a : b);
    double maxHumedad = lecturas.map((l) => l.humedad).reduce((a, b) => a > b ? a : b);
    double maxCO2 = lecturas.map((l) => l.dioxidoDeCarbono).reduce((a, b) => a > b ? a : b);

    // Encuentra el máximo entre los tres sensores
    double overallMax = [maxTemp, maxHumedad, maxCO2].reduce((a, b) => a > b ? a : b);

    // Aplicar un margen de 10%
    double withMargin = overallMax * 1.1;

    // Redondear al múltiplo de 10 superior más cercano
    double roundedMax = (withMargin / 10).ceil() * 10;
    
    // Asegurarse de que el mínimo para Y sea al menos 50 o 100 si los datos son bajos
    return roundedMax < 50 ? 50.0 : roundedMax.toDouble();
  }

  // 2. FUNCIÓN: Convierte la lista de Lectura a datos FlSpot
  List<FlSpot> _getSpotsForType(List<Lectura> lecturas, String type) {
    // La clave es ordenar los datos por tiempo para que el eje X tenga sentido
    lecturas.sort((a, b) => a.fechaHoraLectura.compareTo(b.fechaHoraLectura));

    return lecturas.asMap().entries.map((entry) {
      final index = entry.key; // El índice será nuestra posición en el Eje X
      final lectura = entry.value;
      double value;

      switch (type) {
        case 'temp':
          value = lectura.temp;
          break;
        case 'humedad':
          value = lectura.humedad;
          break;
        case 'co2':
          value = lectura.dioxidoDeCarbono;
          break;
        default:
          value = 0;
      }
      // X = Índice (orden cronológico) | Y = Valor del sensor
      return FlSpot(index.toDouble(), value);
    }).toList();
  }

  // 3. NUEVA FUNCIÓN: Construye la tabla de lecturas
  Widget _buildLecturasTable(List<Lectura> lecturas) {
    // Tomar solo las últimas 10 lecturas
    final latestLecturas = lecturas.length > 10 
        ? lecturas.sublist(lecturas.length - 10).reversed.toList()
        : lecturas.reversed.toList();
    
    // Formateador de fecha
    final dateFormat = DateFormat('dd/MM HH:mm');

    // Estilo de celda para los encabezados
    const headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    // Estilo de celda para los datos
    const dataStyle = TextStyle(fontSize: 13);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Valores Exactos de las Últimas Lecturas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        
        // El widget DataTable
        DataTable(
          columnSpacing: 16,
          dataRowMinHeight: 30,
          dataRowMaxHeight: 40,
          headingRowColor: MaterialStateProperty.resolveWith((states) => Colors.grey.shade200),
          columns: const [
            DataColumn(label: Text('Hora', style: headerStyle)),
            DataColumn(label: Text('Temp (°C)', style: headerStyle), numeric: true),
            DataColumn(label: Text('Hum (%)', style: headerStyle), numeric: true),
            DataColumn(label: Text('CO2 (PPM)', style: headerStyle), numeric: true),
          ],
          rows: latestLecturas.map((lectura) {
            return DataRow(
              cells: [
                // Celda de Hora
                DataCell(
                  Text(dateFormat.format(lectura.fechaHoraLectura.toLocal()), style: dataStyle),
                ),
                // Celda de Temperatura
                DataCell(
                  Text(lectura.temp.toStringAsFixed(1), style: dataStyle),
                ),
                // Celda de Humedad
                DataCell(
                  Text(lectura.humedad.toStringAsFixed(1), style: dataStyle),
                ),
                // Celda de CO2
                DataCell(
                  Text(lectura.dioxidoDeCarbono.toStringAsFixed(1), style: dataStyle),
                ),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 20), // Espacio al final de la tabla
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Dashboard de Sensores', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Gráfico Histórico de Lecturas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // **Uso de FutureBuilder para cargar el gráfico y la tabla**
            FutureBuilder<List<Lectura>>(
              future: _futureLecturas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Muestra el error de la API
                  return Center(
                    child: Text('Error al cargar datos: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No hay datos de lectura disponibles.'),
                  );
                } else {
                  // **¡Datos listos! Mapear y mostrar el gráfico.**
                  final lecturas = snapshot.data!;
                  final double maxX = lecturas.length.toDouble() - 1;
                  final double maxY = _calculateMaxY(lecturas); // Calcular maxY dinámico

                  // Nuevo: Extraer las marcas de tiempo de las lecturas ordenadas
                  final List<DateTime> timestamps = lecturas
                      .map((l) => l.fechaHoraLectura)
                      .toList();

                  final tempSpots = _getSpotsForType(lecturas, 'temp');
                  final humedadSpots = _getSpotsForType(lecturas, 'humedad');
                  final co2Spots = _getSpotsForType(lecturas, 'co2');

                  // Lógica para la adaptabilidad horizontal (scrolling)
                  final double screenWidth = MediaQuery.of(context).size.width;
                  // Asignar 50 píxeles por punto + 32 de padding. Si es menor que la pantalla, usar el ancho de la pantalla.
                  final double requiredWidth = (lecturas.length * 50.0) + 32.0;
                  final double chartWidth = requiredWidth > screenWidth ? requiredWidth : screenWidth - 32;

                  return Column(
                    children: [
                      // --- GRÁFICO ---
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: chartWidth, // Aplicar el ancho dinámico/forzado
                            child: SensorLineChart(
                              tempSpots: tempSpots,
                              humedadSpots: humedadSpots,
                              co2Spots: co2Spots,
                              maxX: maxX,
                              maxY: maxY, // Pasar el valor máximo dinámico
                              timestamps: timestamps, // Pasar las marcas de tiempo
                            ),
                          ),
                        ),
                      ),
                      
                      // --- TABLA DE LECTURAS (NUEVO) ---
                      _buildLecturasTable(lecturas),
                    ],
                  );
                }
              },
            ),

            const SizedBox(height: 30),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  // 4. FUNCIÓN: Leyenda
  Widget _buildLegend() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _LegendItem(color: Colors.red, label: 'Temperatura'),
        _LegendItem(color: Colors.blue, label: 'Humedad'),
        _LegendItem(color: Colors.green, label: 'CO2'),
      ],
    );
  }
}

// 5. CLASE: Ítem de Leyenda (no necesita cambios)
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

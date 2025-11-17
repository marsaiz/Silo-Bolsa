// Archivo: lib/main.dart

import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/silos_screen.dart';
import 'screens/granos_screen.dart';
import 'screens/alertas_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Silo Bolsa - Monitoreo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // Lista de pantallas
  final List<Widget> _screens = [
    const DashboardScreen(),
    const SilosScreen(),
    const GranosScreen(),
    const AlertasScreen(),
  ];

  // Títulos de las pantallas
  final List<String> _titles = [
    'Dashboard de Sensores',
    'Silos',
    'Granos',
    'Alertas',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _titles[_selectedIndex],
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 2),
            const Text(
              'Marcelo A. Saiz — ITES · EPET Nº 10',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ],
        ),
        flexibleSpace: Stack(
          children: [
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Opacity(
                opacity: 0.18,
                child: Image.asset(
                  'assets/images/molino_tranquera.png',
                  fit: BoxFit.contain,
                  height: kToolbarHeight * 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/molino_tranquera.png'),
            fit: BoxFit.contain, // Mostrar la imagen completa sin recortar
            opacity: 0.3,
          ),
        ),
        child: _screens[_selectedIndex],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.inventory_2,
                    size: 48,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Silo Bolsa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Sistema de Monitoreo',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              selected: _selectedIndex == 0,
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context); // Cerrar el drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2),
              title: const Text('Silos'),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.grass),
              title: const Text('Granos'),
              selected: _selectedIndex == 2,
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning),
              title: const Text('Alertas'),
              selected: _selectedIndex == 3,
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Acerca de'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'Silo Bolsa',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(Icons.inventory_2, size: 48),
                  children: [
                    const Text('Sistema de monitoreo de condiciones en silos bolsa.'),
                    const SizedBox(height: 8),
                    const Text('Sensores: Temperatura, Humedad, CO2'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

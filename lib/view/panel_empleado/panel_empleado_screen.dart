import 'package:flutter/material.dart';
import 'package:client_service/models/empleado.dart';
import 'package:client_service/view/calendar/calendario_screen.dart';
import 'package:client_service/view/asistencia/asistencia_screen.dart';

class PanelEmpleadoScreen extends StatefulWidget {
  final Empleado empleado;
  const PanelEmpleadoScreen({super.key, required this.empleado});

  @override
  State<PanelEmpleadoScreen> createState() => _PanelEmpleadoScreenState();
}

class _PanelEmpleadoScreenState extends State<PanelEmpleadoScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  List<Widget> get _screens => [
        CalendarioScreen(empleado: widget.empleado),
        AsistenciaScreen(empleado: widget.empleado),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Servicios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Asistencia',
          ),
        ],
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

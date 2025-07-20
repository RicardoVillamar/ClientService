import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:client_service/view/asistencia/asistencia_screen.dart';

import 'firebase_test_setup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:client_service/models/empleado.dart';

void main() {
  setUpAll(() {
    setupFirebaseMocks();
  });

  testWidgets('AsistenciaScreen muestra botones de entrada y salida',
      (WidgetTester tester) async {
    // Initialize Firebase before running the widget
    await Firebase.initializeApp();
    await tester.pumpWidget(MaterialApp(
      home: AsistenciaScreen(
        empleado: Empleado(
          id: '1',
          nombre: 'Test',
          apellido: 'User',
          cedula: '123',
          direccion: '',
          telefono: '',
          correo: '',
          cargo: CargoEmpleado.administrador,
          fechaContratacion: DateTime.now(),
          password: '',
        ),
      ),
    ));
    expect(find.text('Marcar Entrada'), findsOneWidget);
    expect(find.text('Marcar Salida'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:client_service/view/service/camara/register_camara.dart';
import '../test_setup.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es', null);
  });

  setUp(() {
    setupTestDependencies();
  });

  tearDown(() {
    tearDownTestDependencies();
  });

  testWidgets('Registro de cámara - pantalla se carga correctamente',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegistroCamara()));

    // Esperar a que se carguen los empleados
    await tester.pumpAndSettle();

    // Verificar que la pantalla se carga con los elementos principales
    expect(find.text('Mantenimiento de Camara'), findsOneWidget);
    expect(find.text('Nombre comercial del cliente*'), findsOneWidget);
    expect(find.text('Dirección de instalación*'), findsOneWidget);
    expect(find.text('Descripcion*'), findsOneWidget);
    expect(find.text('Costo de mantenimiento*'), findsOneWidget);
    expect(find.text('Tecnico'), findsOneWidget);
    expect(find.text('Tipo'), findsOneWidget);
    expect(find.text('Registrar'), findsOneWidget);
  });
}

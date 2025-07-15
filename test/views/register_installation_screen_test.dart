import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:client_service/view/service/installation/register_installation.dart';
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

  testWidgets('Registro de instalación - pantalla se carga correctamente',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegistroInstalacion()));
    await tester.pumpAndSettle();

    // Verificar que la pantalla se carga con los elementos principales
    expect(find.text('Nueva Instalación'), findsOneWidget);
    expect(find.text('Guardar'), findsOneWidget);
    expect(find.text('Fecha de instalación'), findsOneWidget);
    expect(find.text('Numero de cedula*'), findsOneWidget);
    expect(find.text('Nombre comercial*'), findsOneWidget);
    expect(find.text('Direccion de instalacion*'), findsOneWidget);
    expect(find.text('Item*'), findsOneWidget);
    expect(find.text('Descripcion*'), findsOneWidget);
    expect(find.text('Hora de inicio'), findsOneWidget);
    expect(find.text('Hora de finalizacion'), findsOneWidget);
    expect(find.text('Tipo'), findsOneWidget);
    expect(find.text('Observaciones'), findsOneWidget);
    expect(find.text('Cargo o Puesto'), findsOneWidget);
    expect(find.text('Telefono*'), findsOneWidget);
    expect(find.text('Numero de tarea'), findsOneWidget);
    expect(find.text('Datos del trabajo'), findsOneWidget);
  });
}

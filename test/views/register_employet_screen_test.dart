import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:client_service/view/registers/employet/register_employet.dart';
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

  testWidgets('Registro de empleado - pantalla se carga correctamente',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegistroEmpleadoPage()));
    await tester.pumpAndSettle();

    // Verificar que la pantalla se carga con los elementos principales
    expect(find.text('Nuevo Empleado'), findsOneWidget);
    expect(find.text('Registrar'), findsOneWidget);
    expect(find.text('Nombres*'), findsOneWidget);
    expect(find.text('Apellidos*'), findsOneWidget);
    expect(find.text('Numero de Cedula*'), findsOneWidget);
    expect(find.text('Direccion*'), findsOneWidget);
    expect(find.text('Telefono*'), findsOneWidget);
    expect(find.text('Correo Electronico*'), findsOneWidget);
    expect(find.text('Cargo o Puesto'), findsOneWidget);
    expect(find.text('Fecha de contratación*'), findsOneWidget);
  });
}

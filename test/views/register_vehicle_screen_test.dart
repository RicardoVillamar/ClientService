import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:client_service/view/service/vehicle_rental/register_vehicle.dart';
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

  testWidgets('Registro de vehículo - pantalla se carga correctamente',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegistroAlquiler()));
    await tester.pumpAndSettle();

    // Verificar que la pantalla se carga con los elementos principales
    expect(find.text('Alquiler de vehiculo'), findsOneWidget);
    expect(find.text('Nombre comercial*'), findsOneWidget);
    expect(find.text('Direccion*'), findsOneWidget);
    expect(find.text('Telefono*'), findsOneWidget);
    expect(find.text('Correo electronico*'), findsOneWidget);
    expect(find.text('Monto alquiler*'), findsOneWidget);
    expect(find.text('Fecha de reserva'), findsOneWidget);
    expect(find.text('Fecha de trabajo'), findsOneWidget);
    expect(find.text('Registro'), findsOneWidget);
  });
}

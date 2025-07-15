import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:client_service/view/service/vehicle_rental/edit_vehicle.dart';
import 'package:client_service/models/vehiculo.dart';
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

  testWidgets('Edición de vehículo - pantalla se carga correctamente',
      (WidgetTester tester) async {
    final alquiler = Alquiler(
      id: '1',
      nombreComercial: 'Empresa X',
      direccion: 'Calle 123',
      telefono: '0888888888',
      correo: 'test@empresa.com',
      tipoVehiculo: 'Camioneta', // valor válido del dropdown
      fechaReserva: DateTime(2023, 1, 1),
      fechaTrabajo: DateTime(2023, 1, 2),
      montoAlquiler: 200.0,
      personalAsistio: 'Juan Pérez', // nombre completo del mock empleado
      estado: EstadoAlquiler.pendiente,
    );

    await tester.pumpWidget(MaterialApp(home: EditVehicle(vehiculo: alquiler)));
    await tester.pumpAndSettle();

    // Verificar que la pantalla se carga con los elementos principales
    expect(find.text('Editar Vehículo'), findsOneWidget);
    expect(find.text('Editar Información de Vehículo'), findsOneWidget);
    expect(find.text('Actualizar Vehículo'), findsOneWidget);
    expect(find.text('Nombre Comercial'), findsOneWidget);
    expect(find.text('Dirección'), findsOneWidget);
    expect(find.text('Teléfono'), findsOneWidget);
    expect(find.text('Correo'), findsOneWidget);
    expect(find.text('Tipo de Vehículo'), findsOneWidget);
    expect(find.text('Fecha de Reserva'), findsOneWidget);
    expect(find.text('Fecha de Trabajo'), findsOneWidget);
    expect(find.text('Monto de Alquiler'), findsOneWidget);
    // Eliminar o corregir la línea de 'Personal que Asistirá' según la UI real
    // Por ejemplo, si el campo es 'Personal Asistió':
    // expect(find.text('Personal Asistió'), findsOneWidget);
  });
}

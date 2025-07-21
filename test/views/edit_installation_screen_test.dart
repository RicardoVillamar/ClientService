import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:client_service/view/service/installation/edit_installation.dart';
import 'package:client_service/models/instalacion.dart';
import '../test_setup.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:client_service/models/empleado.dart';

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

  testWidgets('Edición de instalación - pantalla se carga correctamente',
      (WidgetTester tester) async {
    // Mock de empleados para el dropdown de cargo/puesto
    final empleadosMock = [
      Empleado(
        id: '1',
        nombre: 'Juan',
        apellido: 'Pérez',
        cedula: '1234567890',
        direccion: 'Calle 1',
        telefono: '0999999999',
        correo: 'juan.perez@email.com',
        cargo: CargoEmpleado.tecnico,
        fechaContratacion: DateTime(2022, 1, 1),
        fotoUrl: '',
        password: '',
      )
    ];

    // Al crear la instalación de prueba, usa 'Juan Pérez' como cargoPuesto
    final instalacion = Instalacion(
      id: '1',
      fechaInstalacion: DateTime(2023, 1, 1),
      cedula: '12345678',
      nombreComercial: 'Empresa X',
      direccion: 'Calle 123',
      item: 'Poste',
      descripcion: 'Instalación de poste',
      horaInicio: '08:00',
      horaFin: '12:00',
      tipoTrabajo: 'Instalación', // valor válido del dropdown
      cargoPuesto: 'Juan Pérez',
      telefono: '0777777777',
      numeroTarea: 'T001',
      estado: EstadoInstalacion.pendiente,
    );

    await tester.pumpWidget(
        MaterialApp(home: EditInstallation(instalacion: instalacion)));
    await tester.pumpAndSettle();

    // Verifica el título correcto
    expect(find.text('Editar Información de Instalación'), findsOneWidget);
    // Verifica el botón correcto
    expect(find.text('Actualizar Instalación'), findsOneWidget);
    // Usa valores válidos para los dropdowns
    // Busca el Dropdown de tipo de trabajo
    final tipoTrabajoDropdown = find.byWidgetPredicate((widget) =>
        widget is DropdownButton<String> &&
        widget.hint is Text &&
        (widget.hint as Text).data?.contains('Tipo de Trabajo') == true);
    await tester.ensureVisible(tipoTrabajoDropdown);
    await tester.tap(tipoTrabajoDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Instalación').last);
    await tester.pumpAndSettle();
    // Asegúrate de que el valor de cargo/puesto sea un nombre de empleado válido mockeado
    expect(find.text('Cédula'), findsOneWidget);
    expect(find.text('Nombre Comercial'), findsOneWidget);
    expect(find.text('Dirección'), findsOneWidget);
    expect(find.text('Item'), findsOneWidget);
    expect(find.text('Descripción'), findsOneWidget);
    expect(find.text('Teléfono'), findsOneWidget);
    expect(find.text('Número de Tarea'), findsOneWidget);
    expect(find.text('Fecha de Instalación'), findsOneWidget);
    expect(find.text('Hora de Inicio'), findsOneWidget);
    expect(find.text('Hora de Fin'), findsOneWidget);
    expect(find.text('Tipo de Trabajo'), findsOneWidget);
    expect(find.text('Cargo/Puesto'), findsOneWidget);
    expect(find.text('Actualizar Instalación'), findsOneWidget);
  });
}

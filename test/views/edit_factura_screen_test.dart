import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:client_service/view/billing/edit_factura.dart';
import 'package:client_service/models/factura.dart';
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

  testWidgets('Edición de factura - flujo básico', (WidgetTester tester) async {
    // Mock de empleados para el dropdown de creadoPor
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
    final factura = Factura(
      id: '1',
      numeroFactura: 'F001',
      fechaEmision: DateTime(2023, 1, 1),
      fechaVencimiento: DateTime(2023, 1, 31),
      clienteId: '1',
      nombreCliente: 'Empresa Test',
      direccionCliente: 'Dirección Test',
      telefonoCliente: '0999999999',
      correoCliente: 'test@empresa.com',
      tipoServicio: TipoServicio.camara,
      servicioId: 'serv1',
      items: [
        ItemFactura(descripcion: 'Servicio', cantidad: 1, precioUnitario: 100.0)
      ],
      impuesto: 13.0,
      estado: EstadoFactura.pendiente,
      fechaCreacion: DateTime(2023, 1, 1),
      creadoPor: 'Juan Pérez',
    );
    await tester.pumpWidget(MaterialApp(home: EditFactura(factura: factura)));
    await tester.pumpAndSettle();

    // Verifica el título correcto
    expect(find.text('Información de la Factura'), findsOneWidget);
    expect(find.text('Actualizar Factura'), findsOneWidget);
    expect(find.text('Cliente'), findsOneWidget);
    expect(find.text('Fecha de Emisión'), findsOneWidget);
    expect(find.text('Fecha de Vencimiento'), findsOneWidget);
    expect(find.text('Impuesto (%)'), findsOneWidget);
    // Usa valores válidos para los dropdowns
    // Busca el DropdownButtonFormField de tipo de servicio y haz tap en él
    final tipoServicioDropdown = find.byWidgetPredicate((widget) =>
        widget is DropdownButtonFormField &&
        widget.decoration.labelText == 'Tipo de Servicio');
    await tester.ensureVisible(tipoServicioDropdown);
    await tester.tap(tipoServicioDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Instalación').last);
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Impuesto (%)'), '13.0');
    await tester.ensureVisible(find.text('Actualizar Factura'));
    await tester.tap(find.text('Actualizar Factura'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));
    expect(find.textContaining('actualizada'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  });
}

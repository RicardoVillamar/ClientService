import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:client_service/view/service/camara/edit_camara.dart';
import 'package:client_service/models/camara.dart';
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

  testWidgets('Edición de cámara - pantalla se carga correctamente',
      (WidgetTester tester) async {
    final camara = Camara(
      id: '1',
      nombreComercial: 'Empresa X',
      fechaMantenimiento: DateTime(2023, 1, 1),
      direccion: 'Calle 123',
      tecnico: 'Juan Pérez', // nombre completo del mock empleado
      tipo: 'Tipo 1', // valor válido del dropdown
      descripcion: 'Cámara de seguridad',
      costo: 100.0,
      estado: EstadoCamara.pendiente,
    );

    await tester.pumpWidget(MaterialApp(home: EditCamara(camara: camara)));
    await tester.pumpAndSettle();

    // Verificar que la pantalla se carga con los elementos principales
    expect(find.text('Editar Información de Cámara'), findsOneWidget);
    expect(find.text('Actualizar Cámara'), findsOneWidget);
    expect(find.text('Nombre Comercial'), findsOneWidget);
    expect(find.text('Dirección'), findsOneWidget);
    expect(find.text('Fecha de Mantenimiento'), findsOneWidget);
    expect(find.text('Técnico'), findsOneWidget);
    expect(find.text('Tipo'), findsOneWidget);
    expect(find.text('Observaciones'), findsOneWidget);
    expect(find.text('Costo'), findsOneWidget);

    // Verificar que los campos están prellenados con los datos de la cámara
    expect(find.text('Empresa X'), findsOneWidget);
    expect(find.text('Calle 123'), findsOneWidget);
    expect(find.text('Cámara de seguridad'), findsOneWidget);
    expect(find.text('100.0'), findsOneWidget);
  });
}

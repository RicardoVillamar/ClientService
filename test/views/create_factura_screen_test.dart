import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:client_service/view/billing/create_factura.dart';
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

  testWidgets('Crear factura - flujo básico', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CreateFactura()));
    await tester.pumpAndSettle();

    // Verificar que la pantalla se carga con los elementos principales
    expect(find.text('Información de la Factura'),
        findsOneWidget); // Ajusta si hay un título específico
    expect(find.text('Crear Factura'), findsOneWidget);
    expect(find.text('Cliente'), findsOneWidget);
    expect(find.text('Fecha de Emisión'), findsOneWidget);
    expect(find.text('Fecha de Vencimiento'), findsOneWidget);
    expect(find.text('Impuesto (%)'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:client_service/view/billing/anular_facturas.dart';
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

  testWidgets('Anular factura - flujo básico', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AnularFacturas()));
    await tester.pumpAndSettle();

    // Verificar que la pantalla se carga con los elementos principales
    expect(find.text('Anular Facturas'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget); // Barra de búsqueda
    // Puedes agregar más asserts según los textos visibles en la UI
  });
}

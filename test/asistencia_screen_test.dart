import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:client_service/view/asistencia/asistencia_screen.dart';

void main() {
  testWidgets('AsistenciaScreen muestra botones de entrada y salida',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AsistenciaScreen()));
    expect(find.text('Marcar Entrada'), findsOneWidget);
    expect(find.text('Marcar Salida'), findsOneWidget);
  });
}

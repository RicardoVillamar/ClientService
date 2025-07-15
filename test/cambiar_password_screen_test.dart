import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:client_service/view/auth/cambiar_password_screen.dart';

void main() {
  testWidgets('CambiarPasswordScreen muestra campos y botón',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        const MaterialApp(home: CambiarPasswordScreen(cedula: '1234567890')));
    expect(find.text('Nueva Contraseña'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Confirmar'), findsOneWidget);
  });
}

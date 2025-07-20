import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:client_service/view/auth/login_empleado_screen.dart';

void main() {
  testWidgets('LoginEmpleadoScreen muestra campos y botón',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginEmpleadoScreen()));
    expect(find.text('Ingresar'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Ingresar'), findsOneWidget);
  });
}

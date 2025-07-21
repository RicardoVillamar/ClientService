import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:client_service/view/auth/login_admin_screen.dart';

void main() {
  testWidgets('LoginAdminScreen muestra campos y botón',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginAdminScreen()));
    expect(find.text('Ingresar'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Ingresar'), findsOneWidget);
  });
}

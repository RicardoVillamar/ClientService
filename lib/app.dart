import 'package:client_service/view/inicio/home.dart';
import 'package:client_service/services/navigation_service.dart';
import 'package:client_service/routes.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Client Service',
      navigatorKey: NavigationService.navigatorKey,
      home: const HomePage(),
      routes: routes,
    );
  }
}

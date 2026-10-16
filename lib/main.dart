import 'package:flutter/material.dart';
import 'screens/login_screens.dart';
import 'dependencias.dart';
void main() {
  configurarDependencias();
  dependenciasInventario();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
  



}

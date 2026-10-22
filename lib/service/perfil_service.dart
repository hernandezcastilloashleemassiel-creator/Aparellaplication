// lib/service/profile_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/perfil_data.dart';
    
class ProfileService {
  Future<UserProfile> getUserProfile() async {
    try {
      final url = Uri.parse('http://10.0.2.2:5294/api/profile');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserProfile(
          nombre: data['nombre'] ?? '',
          correo: data['correo'] ?? '',
          telefono: data['telefono'] ?? '',
          rol: data['rol'] ?? '',
        );
      } else {
        // Si la API responde con un código de error (ej. 404 o 500), usamos datos locales de respaldo
        return _obtenerDatosDeRespaldo();
      }
    } catch (e) {
      print('Error conectando a la API, usando datos locales: $e');
      // Si falla la red por completo, devolvemos datos locales para que la pantalla no falle
      return _obtenerDatosDeRespaldo();
    }
  }

  // Datos locales de respaldo para que la pantalla cargue sí o sí
  UserProfile _obtenerDatosDeRespaldo() {
    return const UserProfile(
      nombre: 'Massiel Hernández (Local)',
      correo: 'Masiel@gmail.com',
      telefono: '+505 8888 1234',
      rol: 'Administrador',
    );
  }
}
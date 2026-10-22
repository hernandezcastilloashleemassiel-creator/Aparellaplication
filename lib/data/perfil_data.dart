import 'dart:convert';
import 'package:http/http.dart' as http;

class UserProfile {
  final String nombre;
  final String correo;
  final String telefono;
  final String rol;

  const UserProfile({
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.rol,
  });

  // 1. Constructor para convertir el JSON en objeto
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nombre: json['nombre'] ?? '',
      correo: json['correo'] ?? '',
      telefono: json['telefono'] ?? '',
      rol: json['rol'] ?? '',
    );
  }

  // 2. Método para conectar la API directamente aquí
  static Future<UserProfile> obtenerPerfil() async {
    // Cambia esta URL por la de tu API real
    final url = Uri.parse('http://10.0.2.2:5294/api');
    
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserProfile.fromJson(data);
    } else {
      throw Exception('Error al cargar el perfil desde la API');
    }
  }
}
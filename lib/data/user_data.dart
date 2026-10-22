import 'dart:convert';
import 'package:http/http.dart' as http;

class UsuarioData {
  final String baseUrl;

  UsuarioData(this.baseUrl);

  Future<http.Response> obtenerUsuarios(String token) async {
    final url = Uri.parse('$baseUrl/api/Usuario/Lista');

    return http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 15));
  }

  Future<http.Response> crearUsuario({
    required String token,
    required String nombre,
    required String correo,
    required String cargo,
    required bool activo,
  }) async {
    final url = Uri.parse('$baseUrl/api/Usuario/Crear');

    return http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'nombre': nombre,
        'correo': correo,
        'cargo': cargo,
        'activo': activo,
      }),
    ).timeout(const Duration(seconds: 15));
  }
}

class Usuario {
  final int id;
  final String nombre;
  final String cargo;
  final String correo;
  final bool activo;

  Usuario({
    required this.id,
    required this.nombre,
    required this.cargo,
    required this.correo,
    required this.activo,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    final estado = json['activo'] ?? json['Activo'];

    return Usuario(
      id: int.tryParse(
            '${json['usuarioId'] ?? json['id'] ?? json['idUsuario'] ?? 0}',
          ) ??
          0,
      nombre: '${json['nombre'] ?? json['userName'] ?? json['username'] ?? ''}',
      cargo: '${json['cargo'] ?? json['rol'] ?? json['role'] ?? ''}',
      correo: '${json['correo'] ?? json['email'] ?? ''}',
      activo: estado == true ||
          estado == 1 ||
          '$estado'.toLowerCase() == 'true',
    );
  }
}
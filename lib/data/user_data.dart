
import 'package:http/http.dart' as http;

class UsuarioData {
  final String baseUrl;

  UsuarioData(this.baseUrl);

  Future<http.Response> obtenerUsuarios(String token) async {
    final url = Uri.parse('$baseUrl/api/Usuario/Lista');

    return await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
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
    return Usuario(
      id: int.tryParse(
            (json['usuarioId'] ?? json['id'] ?? 0).toString(),
          ) ??
          0,
      nombre: (json['nombre'] ??
              json['userName'] ??
              json['username'] ??
              '')
          .toString(),
      cargo: (json['cargo'] ??
              json['rol'] ??
              json['role'] ??
              '')
          .toString(),
      correo: (json['correo'] ??
              json['email'] ??
              '')
          .toString(),
      activo: json['activo'] == true ||
          json['activo'] == 1 ||
          json['activo'] == 'true',
    );
  }
}

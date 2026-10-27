import 'dart:convert';

import '../data/user_data.dart';

class UsuarioService {
  final UsuarioData usuarioData;

  UsuarioService(this.usuarioData);

  Future<List<Usuario>> obtenerUsuarios(String token) async {
    final response = await usuarioData.obtenerUsuarios(token);

    if (response.statusCode == 200) {
      final dynamic jsonResponse = jsonDecode(response.body);

      
      if (jsonResponse is List) {
        return jsonResponse.map((item) {
          return Usuario.fromJson(
            Map<String, dynamic>.from(item as Map),
          );
        }).toList();
      }

      
      if (jsonResponse is Map<String, dynamic> &&
          jsonResponse['data'] is List) {
        final List<dynamic> datos = jsonResponse['data'];

        return datos.map((item) {
          return Usuario.fromJson(
            Map<String, dynamic>.from(item as Map),
          );
        }).toList();
      }

      throw Exception(
        'La respuesta de la API no contiene una lista de usuarios.',
      );
    }

    throw Exception(
      'Error al obtener usuarios: '
      '${response.statusCode} - ${response.body}',
    );
  }

  
  List<Usuario> filtrar(List<Usuario> usuarios, String busqueda) {
    final texto = busqueda.toLowerCase().trim();

    return usuarios.where((u) {
      return u.nombre.toLowerCase().contains(texto) ||
          u.correo.toLowerCase().contains(texto) ||
          u.cargo.toLowerCase().contains(texto);
    }).toList();
  }
}
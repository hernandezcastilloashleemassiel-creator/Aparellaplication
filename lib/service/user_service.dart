<<<<<<< HEAD

import 'dart:convert';

=======
import 'dart:convert';
>>>>>>> Fernanda-Narvaez
import '../data/user_data.dart';

class UsuarioService {
  final UsuarioData usuarioData;

  UsuarioService(this.usuarioData);

  Future<List<Usuario>> obtenerUsuarios(String token) async {
<<<<<<< HEAD
    final response = await usuarioData.obtenerUsuarios(token);

    if (response.statusCode == 200) {
      final dynamic jsonResponse = jsonDecode(response.body);

      // La API devuelve una lista directamente.
      if (jsonResponse is List) {
        return jsonResponse.map((item) {
          return Usuario.fromJson(
            Map<String, dynamic>.from(item as Map),
          );
        }).toList();
      }

      // También admite una lista dentro de la propiedad "data".
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
}
=======
    final respuesta = await usuarioData.obtenerUsuarios(token);

    if (respuesta.statusCode == 200) {
      final datos = jsonDecode(respuesta.body);
      dynamic lista = datos;

      if (datos is Map<String, dynamic>) {
        lista = datos['data'] ??
            datos['usuarios'] ??
            datos['lista'] ??
            datos['result'];
      }

      if (lista is! List) {
        throw Exception('La respuesta de la API no contiene una lista.');
      }

      return lista
          .whereType<Map<String, dynamic>>()
          .map((json) => Usuario.fromJson(json))
          .toList();
    }

    if (respuesta.statusCode == 401 ||
        respuesta.statusCode == 403) {
      throw Exception('La sesión no es válida o no tienes permiso.');
    }

    throw Exception(
      'Error al consultar usuarios: ${respuesta.statusCode}',
    );
  }

  Future<void> crearUsuario({
    required String token,
    required String nombre,
    required String correo,
    required String cargo,
    required bool activo,
  }) async {
    final respuesta = await usuarioData.crearUsuario(
      token: token,
      nombre: nombre,
      correo: correo,
      cargo: cargo,
      activo: activo,
    );

    if (respuesta.statusCode == 200 ||
        respuesta.statusCode == 201 ||
        respuesta.statusCode == 204) {
      return;
    }

    throw Exception(
      'No se pudo guardar el usuario. '
      'Código: ${respuesta.statusCode}. ${respuesta.body}',
    );
  }
}
>>>>>>> Fernanda-Narvaez

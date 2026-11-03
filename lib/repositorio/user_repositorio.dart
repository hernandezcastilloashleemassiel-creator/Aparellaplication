import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/config.dart';
import '../core/token.dart';
import '../modelo/user_modelo.dart';

class UserRepositorio {
  final TokenStorage tokenStorage;

  UserRepositorio({required this.tokenStorage});

  Future<Map<String, String>> get headers async {
    final token = await tokenStorage.read();

    if (token == null || token.isEmpty) {
      throw Exception('No se encontró el token de autenticación');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // LISTAR USUARIOS
  Future<List<User>> listarUsuarios() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/Usuario/Lista'),
      headers: await headers,
    ).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final datos = jsonDecode(response.body) as List;

      return datos
          .map((item) => User.fromJson(item))
          .toList();
    }

    throw Exception(
      'Error al listar usuarios: ${response.body}',
    );
  }

  // OBTENER USUARIO
  Future<User> obtenerUsuario(String id) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/Usuario/Obtener/$id'),
      headers: await headers,
    ).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      'Error al obtener usuario: ${response.body}',
    );
  }

  // REGISTRAR USUARIO
  Future<bool> registrarUsuario({
    required String nombre,
    required String correo,
    required String password,
    required String cargo,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/Usuario/Registrar'),
      headers: await headers,
      body: jsonEncode({
        'NombreUsuario': nombre,
        'CorreoUsuario': correo,
        'CargoUsuario': cargo,
        'Email': correo,
        'Password': password,
        'ContraseñaUsuario': password,
      }),
    ).timeout(ApiConfig.timeout);

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return true;
    }

    throw Exception(
      'Error al registrar usuario: ${response.body}',
    );
  }

  // ACTUALIZAR USUARIO
  Future<bool> actualizarUsuario({
    required String id,
    required String nombre,
    required String correo,
    required String cargo,
  }) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/Usuario/Actualizar/$id'),
      headers: await headers,
      body: jsonEncode({
        'NombreUsuario': nombre,
        'CorreoUsuario': correo,
        'CargoUsuario': cargo,
        'Email': correo,
        'Password': '',
        'ContraseñaUsuario': '',
      }),
    ).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception(
      'Error al actualizar usuario: ${response.body}',
    );
  }

  // ELIMINAR USUARIO
  Future<bool> eliminarUsuario(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/Usuario/Eliminar/$id'),
      headers: await headers,
    ).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception(
      'Error al eliminar usuario: ${response.body}',
    );
  }
}
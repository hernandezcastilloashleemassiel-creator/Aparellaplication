// ignore_for_file: unused_local_variable

import 'dart:convert';
import '../data/login_data.dart';

class AuthService {
  final LoginData _data;

  AuthService(this._data);
  Future<String?> login(String email, String password) async {
    try {
      final respuesta = await _data
          .login(email, password)
          .timeout(const Duration(seconds: 10));

      if (respuesta.statusCode == 200) {
        final json = jsonDecode(respuesta.body);
        final token = json['token'];
        final usuario = json['userName'];
        final roles = json['roles'];
        return null;
      }

      if (respuesta.statusCode == 400) {
        return respuesta.body;
      }

      return 'Error del servidor (${respuesta.statusCode})';
    } catch (e) {
      return 'No se pudo conectar con el servidor';
    }
  }
}
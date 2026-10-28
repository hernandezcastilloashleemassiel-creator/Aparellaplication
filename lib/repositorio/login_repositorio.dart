import 'dart:convert';
import '../core/token.dart';
import '../data/login_data.dart';
import '../modelo/login_modelo.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthRepository {
  final LoginData _data;
  final TokenStorage _tokenStorage;

  AuthRepository(this._data, this._tokenStorage);

  Future<LoginResponse> login(String email, String password) async {
    final respuesta = await _data.login(email, password);

    if (respuesta.statusCode == 200) {
      final login = LoginResponse.fromJson(jsonDecode(respuesta.body));
      await _tokenStorage.save(login.token);
      return login;
    }

    if (respuesta.statusCode == 400) {
      throw AuthException(respuesta.body);
    }

    throw AuthException('Error del servidor (${respuesta.statusCode})');
  }

  Future<void> logout() => _tokenStorage.clear();
}
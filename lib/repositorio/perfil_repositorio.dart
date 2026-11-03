import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/config.dart';
import '../core/token.dart';
import '../modelo/perfil_modelo.dart';

class PerfilException implements Exception {
  final String message;
  final int? statusCode;
  PerfilException(this.message, {this.statusCode});

  bool get esNoAutorizado => statusCode == 401;

  @override
  String toString() => message;
}

class PerfilRepositorio {
  final TokenStorage _tokenStorage;
  PerfilRepositorio(this._tokenStorage);

  Future<Map<String, String>> _headers() async {
    final token = await _tokenStorage.read();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
Uri _url(String ruta) => Uri.parse('${ApiConfig.baseUrl}/Usuario$ruta');
// Lee el correo del usuario desde el token JWT
Future<String?> _correoDelToken() async {
  final token = await _tokenStorage.read();
  if (token == null) return null;

  try {
    final partes = token.split('.');
    if (partes.length != 3) return null;

    final payload = utf8.decode(
      base64Url.decode(base64Url.normalize(partes[1])),
    );
    final datos = jsonDecode(payload) as Map<String, dynamic>;

    final correo = datos['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'] ??
        datos['email'] ??
        datos['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'];

    return correo?.toString();
  } catch (_) {
    return null;
  }
}
// Saca el "message" del JSON de la API; si no hay, devuelve un texto genérico
String _mensajeDe(http.Response res) {
  try {
    final body = jsonDecode(utf8.decode(res.bodyBytes));
    if (body is Map && body['message'] != null) {
      return body['message'].toString();
    }
  } catch (_) {}
  return 'Error del servidor (${res.statusCode})';
}
Future<PerfilResponse> obtenerPerfil() async {
  try {
    final correo = await _correoDelToken();
    if (correo == null) {
      throw PerfilException('No se pudo identificar al usuario', statusCode: 401);
    }

    final res = await http
        .get(_url('/Lista'), headers: await _headers())
        .timeout(ApiConfig.timeout);

    if (kDebugMode) debugPrint('GET perfil: ${res.statusCode} ${res.body}');

    if (res.statusCode != 200) {
      throw PerfilException(_mensajeDe(res), statusCode: res.statusCode);
    }

    final lista = jsonDecode(utf8.decode(res.bodyBytes)) as List;

    // Busca el usuario cuyo correo coincide con el del token
    final usuario = lista.firstWhere(
      (u) => (u as Map).values.any(
        (v) => v is String && v.toLowerCase() == correo.toLowerCase(),
      ),
      orElse: () => null,
    );

    if (usuario == null) {
      throw PerfilException('No se encontró el usuario');
    }

    return PerfilResponse.fromJson(usuario as Map<String, dynamic>);
  } on TimeoutException {
    throw PerfilException('El servidor tardó demasiado en responder');
  } on SocketException {
    throw PerfilException('Sin conexión a internet');
  }
}
}
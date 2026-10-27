import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config.dart';

class LoginData {
  Future<http.Response> login(String email, String password) {
    return http
        .post(
          Uri.parse('${ApiConfig.baseUrl}/Usuario/Login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(ApiConfig.timeout);
  }
}
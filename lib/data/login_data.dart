import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginData {
  final String baseUrl = 'http://10.0.2.2:5294/api';

  Future<http.Response> login(String email, String password) {
    return http.post(
      Uri.parse('$baseUrl/Usuario/Login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
  }
}
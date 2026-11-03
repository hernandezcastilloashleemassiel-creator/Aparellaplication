import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config.dart';
import '../core/token.dart';
import '../modelo/producto_modelo.dart';
import 'package:flutter/foundation.dart';

class ProductoRepositorio {
  final TokenStorage _tokenStorage;
  ProductoRepositorio(this._tokenStorage);

  Future<Map<String, String>> _headers() async {
    final token = await _tokenStorage.read();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Uri _url([String ruta = '']) => Uri.parse('${ApiConfig.baseUrl}/Producto$ruta');

 Future<List<ProductoModel>> obtenerTodos() async {
  final res = await http
      .get(_url(), headers: await _headers())
      .timeout(ApiConfig.timeout);
      
  debugPrint('GET body completo: ${res.body}'); // <-- Agrega esto para ver qué trae exactamente el servidor
  
  if (res.statusCode != 200) throw Exception('Error ${res.statusCode}');
  final lista = jsonDecode(res.body) as List;
  debugPrint('GET productos: ${lista.length}');
  return lista.map((j) => ProductoModel.fromJson(j)).toList();
}

  // La API responde { "message": "..." }, no devuelve el producto
 Future<void> crear(ProductoModel p) async {
    final res = await http
        .post(_url(), headers: await _headers(), body: jsonEncode(p.toJson()))
        .timeout(ApiConfig.timeout);

       debugPrint('POST status: ${res.statusCode}');
    debugPrint('POST body: ${res.body}');
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Error ${res.statusCode}: ${res.body}');
    }
  }

  Future<void> actualizar(ProductoModel p) async {
    final res = await http
        .put(_url('/${p.id}'), headers: await _headers(), body: jsonEncode(p.toJson()))
        .timeout(ApiConfig.timeout);
    if (res.statusCode != 200) {
      throw Exception('Error ${res.statusCode}: ${res.body}');
    }
  }

  Future<void> eliminar(int id) async {
    final res = await http
        .delete(_url('/$id'), headers: await _headers())
        .timeout(ApiConfig.timeout);
    if (res.statusCode != 200) {
      throw Exception('Error ${res.statusCode}: ${res.body}');
    }
  }
}
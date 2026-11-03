import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config.dart';
import '../core/token.dart';
import '../modelo/factura_modelo.dart';
import 'package:flutter/foundation.dart';

class FacturaRepositorio {
  final TokenStorage _tokenStorage;
  FacturaRepositorio(this._tokenStorage);

  Future<Map<String, String>> _headers() async {
    final token = await _tokenStorage.read();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
  
  Uri _url([String ruta = '']) => Uri.parse('${ApiConfig.baseUrl}/Factura$ruta');

  Future<List<FacturaModel>> obtenerTodas() async {
    final res = await http
        .get(_url(), headers: await _headers())
        .timeout(ApiConfig.timeout);

    debugPrint('GET Facturas status: ${res.statusCode}');
    debugPrint('GET Facturas body: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('Error al cargar facturas: ${res.statusCode} - ${res.body}');
    }

    final lista = jsonDecode(res.body) as List;
    return lista.map((j) => FacturaModel.fromJson(j)).toList();
  }

  // Método para procesar y guardar una nueva venta/factura
  Future<void> procesarVenta(FacturaModel venta) async {
    final res = await http
        .post(
          _url(),
          headers: await _headers(),
          body: jsonEncode(venta.toJson()),
        )
        .timeout(ApiConfig.timeout);

    debugPrint('POST Factura status: ${res.statusCode}');
    debugPrint('POST Factura body: ${res.body}');

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Error al procesar la factura: ${res.statusCode} - ${res.body}');
    }
  }
}

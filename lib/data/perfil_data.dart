import 'package:http/http.dart' as http;
import '../core/config.dart';
import '../core/token.dart';

class PerfilData {
  final TokenStorage _tokenStorage;

  PerfilData(this._tokenStorage);

  Future<http.Response> obtenerPerfil() async {
    final token = await _tokenStorage.getToken();
    final respuesta = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/Usuario/Perfil'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(ApiConfig.timeout);
      return respuesta;
  }

}

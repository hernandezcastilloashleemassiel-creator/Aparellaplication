import 'dart:convert';
import '../modelo/user_modelo.dart';

class UserData {
  List<User> obtenerUsuarios(String respuesta) {
    final List<dynamic> datos = jsonDecode(respuesta);

    return datos.map((item) => User.fromJson(item)).toList();
  }

  User obtenerUsuario(String respuesta) {
    final Map<String, dynamic> datos = jsonDecode(respuesta);

    return User.fromJson(datos);
  }
}

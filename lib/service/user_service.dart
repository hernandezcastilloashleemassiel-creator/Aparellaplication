import '../modelo/user_modelo.dart';
import '../repositorio/user_repositorio.dart';

class UserServicio {
  final UserRepositorio repositorio;

  UserServicio({required this.repositorio});

  Future<List<User>> listarUsuarios() {
    return repositorio.listarUsuarios();
  }

  Future<User> obtenerUsuario(String id) {
    return repositorio.obtenerUsuario(id);
  }

  Future<bool> registrarUsuario({
    required String nombre,
    required String correo,
    required String password,
    required String cargo,
  }) {
    return repositorio.registrarUsuario(
      nombre: nombre,
      correo: correo,
      password: password,
      cargo: cargo,
    );
  }

  Future<bool> actualizarUsuario({
    required String id,
    required String nombre,
    required String correo,
    required String cargo,
  }) {
    return repositorio.actualizarUsuario(
      id: id,
      nombre: nombre,
      correo: correo,
      cargo: cargo,
    );
  }

  Future<bool> eliminarUsuario(String id) {
    return repositorio.eliminarUsuario(id);
  }
}
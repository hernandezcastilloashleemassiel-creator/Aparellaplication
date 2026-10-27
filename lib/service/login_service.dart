import '../repositorio/login_repositorio.dart';

class AuthService {
  final AuthRepository _repo;

  AuthService(this._repo);

  /// Devuelve null si el login fue exitoso, o el mensaje de error.
  Future<String?> login(String email, String password) async {
    if (email.trim().isEmpty || password.isEmpty) {
      return 'Completa todos los campos';
    }

    try {
      final usuario = await _repo.login(email.trim(), password);

      if (usuario.roles.isEmpty) {
        await _repo.logout();
        return 'El usuario no tiene roles asignados';
      }

      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'No se pudo conectar con el servidor';
    }
  }
}
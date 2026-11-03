
import '../repositorio/login_repositorio.dart';
import '../modelo/login_modelo.dart';

class AuthService {
  final AuthRepository _repo;

  AuthService(this._repo);

  Future<LoginResponse> login(
    String email,
    String password,
  ) async {
    if (email.trim().isEmpty || password.isEmpty) {
      throw AuthException('Completa todos los campos');
    }

    final usuario = await _repo.login(
      email.trim(),
      password,
    );

    if (usuario.roles.isEmpty) {
      await _repo.logout();

      throw AuthException(
        'El usuario no tiene roles asignados',
      );
    }

    final rolesValidos = usuario.roles.any(
      (rol) =>
          rol.trim().toUpperCase() == 'ADMINISTRADOR' ||
          rol.trim().toUpperCase() == 'VENDEDOR',
    );

    if (!rolesValidos) {
      await _repo.logout();

      throw AuthException(
        'El usuario no tiene un rol autorizado',
      );
    }

    return usuario;
  }
}

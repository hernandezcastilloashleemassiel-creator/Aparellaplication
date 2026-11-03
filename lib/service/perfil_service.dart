import '../modelo/perfil_modelo.dart';
import '../repositorio/perfil_repositorio.dart';

class PerfilService {
  final PerfilRepositorio _repositorio;

  PerfilService(this._repositorio);

  Future<PerfilResponse> obtenerPerfil() {
    return _repositorio.obtenerPerfil();
  }
}
class Permisos {
  static bool esAdministrador(List<String> roles) {
    return roles.any(
      (rol) => rol.trim().toUpperCase() == 'ADMINISTRADOR',
    );
  }

  static bool esVendedor(List<String> roles) {
    return roles.any(
      (rol) => rol.trim().toUpperCase() == 'VENDEDOR',
    );
  }

  static bool puedeCrear(List<String> roles) {
    return esAdministrador(roles);
  }

  static bool puedeEditar(List<String> roles) {
    return esAdministrador(roles);
  }

  static bool puedeEliminar(List<String> roles) {
    return esAdministrador(roles);
  }

  static bool puedeConsultar(List<String> roles) {
    return esAdministrador(roles) || esVendedor(roles);
  }

  static bool puedeAdministrarUsuarios(List<String> roles) {
    return esAdministrador(roles);
  }
}
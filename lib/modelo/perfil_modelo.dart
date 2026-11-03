class PerfilResponse {
  final String nombre;
  final String correo;
  final String telefono;
  final String rol;

  PerfilResponse({
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.rol,
  });

  factory PerfilResponse.fromJson(Map<String, dynamic> json) {
    return PerfilResponse(
      nombre: (json['nombreUsuario'] ?? json['nombre'] ?? '').toString(),
      correo: (json['correoUsuario'] ?? json['correo'] ?? '').toString(),
      telefono: (json['telefonoUsuario'] ?? json['telefono'] ?? '').toString(),
      rol: (json['cargoUsuario'] ?? json['rol'] ?? '').toString(),
    );
  }
}
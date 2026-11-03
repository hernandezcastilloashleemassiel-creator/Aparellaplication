class User {
  final String id;
  final String nombreUsuario;
  final String correoUsuario;
  final String cargoUsuario;

  User({
    required this.id,
    required this.nombreUsuario,
    required this.correoUsuario,
    required this.cargoUsuario,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['Id'] ?? json['id'] ?? '').toString(),
      nombreUsuario:
          (json['NombreUsuario'] ?? json['nombreUsuario'] ?? '').toString(),
      correoUsuario:
          (json['CorreoUsuario'] ?? json['correoUsuario'] ?? '').toString(),
      cargoUsuario:
          (json['CargoUsuario'] ?? json['cargoUsuario'] ?? 'Sin cargo')
              .toString(),
    );
  }
}
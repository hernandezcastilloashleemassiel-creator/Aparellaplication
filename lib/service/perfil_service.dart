// lib/service/profile_service.dart

import '../data/perfil_data.dart';

class ProfileService {
  Future<UserProfile> getUserProfile() async {
    // Simula una pequeña latencia de red (puedes cambiarlo por tu lógica real con Firebase o API)
    await Future.delayed(const Duration(milliseconds: 300));

    return const UserProfile(
      nombre: 'Massiel Hernández',
      correo: 'admin@apparel.com',
      telefono: '+505 8888 1234',
      rol: 'Administrador',
    );
  }
}
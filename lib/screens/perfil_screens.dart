import 'package:apparel/modelo/perfil_modelo.dart';
import 'package:flutter/material.dart';

import '../service/perfil_service.dart';
import '../widgets/perfil_widgets.dart';
import '../widgets/boton_nav.dart';
import '../widgets/barra_sup.dart';
import '../core/dependencias.dart';
import '../screens/login_screens.dart';
import '../core/token.dart';

class ProfileScreen extends StatefulWidget {
  final List<String> roles;

  const ProfileScreen({
    super.key,
    this.roles = const [],
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  late final PerfilService _perfilService =
      getIt<PerfilService>();

  late Future<PerfilResponse> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _perfilService.obtenerPerfil();
  }

  Future<void> _cerrarSesion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Cerrar la sesión de tu cuenta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    await getIt<TokenStorage>().clear();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2F3),

      appBar: const BarraSuperior(
        titulo: 'Perfil',
        mostrarAtras: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: FutureBuilder<PerfilResponse>(
          future: _profileFuture,

          builder: (context, snapshot) {

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF12A2DB),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text('No se encontró información del perfil'),
              );
            }

            final user = snapshot.data!;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20, 24, 20, 16,
                ),

                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 420,
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [

                      const CircleAvatar(
                        radius: 48,
                        backgroundColor: Color(0xFF17506F),
                        child: Icon(
                          Icons.person,
                          size: 54,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        user.nombre,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B4F6C),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),

                        decoration: BoxDecoration(
                          color: const Color(0xFF12A2DB),
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Text(
                          user.rol,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      Container(
                        width: double.infinity,

                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),

                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0B4F6C)
                                  .withValues(alpha: 0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),

                        child: Column(
                          children: [

                            InfoTile(
                              icon: Icons.email_outlined,
                              label: 'Correo electrónico',
                              value: user.correo,
                            ),

                            InfoTile(
                              icon: Icons.phone_outlined,
                              label: 'Teléfono',
                              value: user.telefono,
                            ),

                            InfoTile(
                              icon: Icons.verified_user_outlined,
                              label: 'Rol',
                              value: user.rol,
                              isLast: true,
                            ),

                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton.icon(
                          onPressed: _cerrarSesion,

                          icon: const Icon(Icons.logout),

                          label: const Text('Cerrar sesión'),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),

      // IMPORTANTE: conservar los roles en la navegación.
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        roles: widget.roles,
      ),
    );
  }
}
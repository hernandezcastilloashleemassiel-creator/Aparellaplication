import 'package:flutter/material.dart';
import '../core/permisos.dart';
import '../screens/dashboard_screens.dart';
import '../screens/producto_screens.dart';
import '../screens/facturacion_screens.dart';
import '../screens/perfil_screens.dart';
import '../screens/user_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final List<String> roles;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    this.roles = const [],
  });

  // Verificar si el usuario es administrador
  bool get esAdmin => Permisos.esAdministrador(roles);

  // Navegación entre pantallas
  void _onItemTapped(BuildContext context, int index) {
    final opciones = [
      0,
      1,
      2,
      if (esAdmin) 3,
      4,
    ];

    if (index < 0 || index >= opciones.length) return;

    final opcionSeleccionada = opciones[index];

    if (opcionSeleccionada == currentIndex) return;

    Widget targetScreen;

    switch (opcionSeleccionada) {
      // Dashboard
      case 0:
        targetScreen = DashboardScreen(
          roles: roles,
        );
        break;

      // Inventario
      case 1:
        targetScreen = InventarioScreen(
          roles: roles,
        );
        break;

      // Facturación
      case 2:
        targetScreen = FacturacionScreen(
          roles: roles,
        );
        break;

      // Usuarios (solo administrador)
      case 3:
        targetScreen = UserScreen(
          roles: roles,
        );
        break;

      // Perfil
      case 4:
        targetScreen = ProfileScreen(
          roles: roles,
        );
        break;

      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            targetScreen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final opciones = <Map<String, dynamic>>[
      {
        'index': 0,
        'item': const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Dashboard',
        ),
      },
      {
        'index': 1,
        'item': const BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          label: 'Inventario',
        ),
      },
      {
        'index': 2,
        'item': const BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Factura',
        ),
      },

      // Mostrar Usuarios únicamente si es administrador
      if (esAdmin)
        {
          'index': 3,
          'item': const BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: 'Usuarios',
          ),
        },

      {
        'index': 4,
        'item': const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      },
    ];

    // Obtener el índice visible según el rol
    final indiceVisible = opciones.indexWhere(
      (opcion) => opcion['index'] == currentIndex,
    );

    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0F4C6B),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: indiceVisible >= 0 ? indiceVisible : 0,
      onTap: (index) => _onItemTapped(context, index),
      items: opciones
          .map<BottomNavigationBarItem>(
            (opcion) => opcion['item'] as BottomNavigationBarItem,
          )
          .toList(),
    );
  }
}
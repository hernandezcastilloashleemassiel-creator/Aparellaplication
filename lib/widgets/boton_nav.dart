import 'package:flutter/material.dart';
import '../screens/dashboard_screens.dart';
import '../screens/producto_screens.dart';
import '../screens/facturacion_screens.dart';
import '../screens/perfil_screens.dart';
import '../screens/user_screen.dart';


class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;
    Widget targetScreen;
    switch (index) {
      case 0:
        targetScreen = const DashboardScreen();
        break;
      case 1:
      targetScreen = const InventarioScreen(); 
       break; 
      case 2:
       targetScreen = const FacturacionScreen();
       break;
      case 3:
       targetScreen = const UserScreen(token: '');
       break;
      case 4:
      targetScreen = const ProfileScreen();
         break;

      default:
        return;
    }
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => targetScreen,
        transitionDuration: Duration.zero, // Sin animación de retraso para que parezca una pestaña
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0F4C6B),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Inventario'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Productos'),
        BottomNavigationBarItem(icon: Icon(Icons.people_alt_outlined), label: 'Usuarios'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}
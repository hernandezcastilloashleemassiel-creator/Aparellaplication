import 'package:flutter/material.dart';
import '../widgets/dashboard_widgets.dart';
import '../widgets/boton_nav.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenstate();
}

class DashboardScreenstate extends State<DashboardScreen> {
  final String totalStock = '300';
  final String totalUsuarios = '4';
  final String ventasHoy = 'C\$5,000';

  final List<Map<String, String>> stockBajo = [
    {'nombre': 'Vestido', 'quedan': '1'},
  ];

  final List<Map<String, String>> ultimasVentas = [
    {'nombre': 'Camisa polo', 'hora': 'Hoy, 10:30 AM', 'precio': 'C\$450'},
    {'nombre': 'Pantalon Jeans', 'hora': 'Hoy, 9:15 AM', 'precio': 'C\$520'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF1F3),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0F4C6B),
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('APPAREL',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('Dashboard', style: TextStyle(fontSize: 14)),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFF0F4C6B)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('BIENVENIDOS',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F4C6B))),
            const Text('Resumen de tu negocio',
                style: TextStyle(fontSize: 15, color: Color(0xFF0F4C6B))),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ResumenCardWidget(
                    icono: Icons.inventory_2_outlined,
                    titulo: 'Productos en stock',
                    valor: totalStock,
                    colorFondo: const Color(0xFF0F4C6B),
                    colorCirculo: const Color(0xFF12A4D9),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ResumenCardWidget(
                    icono: Icons.people_alt_outlined,
                    titulo: 'Total de usuarios',
                    valor: totalUsuarios,
                    colorFondo: const Color(0xFF12A4D9),
                    colorCirculo: const Color(0xFF0F4C6B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.attach_money,
                      size: 36, color: Color(0xFF12A4D9)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ventas de hoy',
                          style: TextStyle(
                              color: Color(0xFF0F4C6B), fontSize: 14)),
                      Text(ventasHoy,
                          style: const TextStyle(
                              color: Color(0xFF0F4C6B),
                              fontSize: 26,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 20),
            const Text('Stock bajo',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD9382B))),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (var p in stockBajo)
                  Container(
                    width: 150,
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9382B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.checkroom,
                            size: 44, color: Colors.white),
                        const SizedBox(height: 8),
                        Text(p['nombre']!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Quedan: ${p['quedan']}',
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            const Text('Últimas ventas',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F4C6B))),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < ultimasVentas.length; i++)
                    VentaRowWidget(
                      nombre: ultimasVentas[i]['nombre']!,
                      hora: ultimasVentas[i]['hora']!,
                      precio: ultimasVentas[i]['precio']!,
                      mostrarLinea: i != ultimasVentas.length - 1,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }
}
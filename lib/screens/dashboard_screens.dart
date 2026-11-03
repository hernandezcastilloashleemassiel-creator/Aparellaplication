
import 'package:flutter/material.dart';
import '../core/permisos.dart';
import '../widgets/dashboard_widgets.dart';
import '../widgets/boton_nav.dart';
import '../widgets/barra_sup.dart';

class DashboardScreen extends StatefulWidget {
  final List<String> roles;

  const DashboardScreen({
    super.key,
    required this.roles,
  });

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final String totalStock = '300';
  final String totalUsuarios = '4';
  final String ventasHoy = 'C\$5,000';

  bool get esAdmin =>
      Permisos.esAdministrador(widget.roles);

  bool get esVendedor =>
      Permisos.esVendedor(widget.roles);

  String get nombreRol {
    if (esAdmin) return 'ADMINISTRADOR';
    if (esVendedor) return 'VENDEDOR';
    return 'USUARIO';
  }

  final List<Map<String, String>> stockBajo = [
    {'nombre': 'Vestido', 'quedan': '1'},
  ];

  final List<Map<String, String>> ultimasVentas = [
    {
      'nombre': 'Camisa polo',
      'hora': 'Hoy, 10:30 AM',
      'precio': 'C\$450',
    },
    {
      'nombre': 'Pantalon Jeans',
      'hora': 'Hoy, 9:15 AM',
      'precio': 'C\$520',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BarraSuperior(
        titulo: 'Dashboard',
        mostrarAtras: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'BIENVENIDOS',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F4C6B),
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Resumen de tu negocio',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF0F4C6B),
              ),
            ),

            const SizedBox(height: 14),

            // IDENTIFICACION DEL ROL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE5F0F5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    esAdmin
                        ? Icons.admin_panel_settings
                        : Icons.person_outline,
                    color: const Color(0xFF0F4C6B),
                    size: 28,
                  ),

                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sesión iniciada como',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF5F6F7A),
                        ),
                      ),
                      Text(
                        nombreRol,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F4C6B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // RESUMEN DE STOCK Y USUARIOS
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

                if (esAdmin) ...[
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
              ],
            ),

            const SizedBox(height: 12),

            // VENTAS DEL DIA
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.attach_money,
                    size: 36,
                    color: Color(0xFF12A4D9),
                  ),

                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ventas de hoy',
                        style: TextStyle(
                          color: Color(0xFF0F4C6B),
                          fontSize: 14,
                        ),
                      ),

                      Text(
                        ventasHoy,
                        style: const TextStyle(
                          color: Color(0xFF0F4C6B),
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // STOCK BAJO
            const Text(
              'Stock bajo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD9382B),
              ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (var p in stockBajo)
                  Container(
                    width: 150,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9382B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.checkroom,
                          size: 44,
                          color: Colors.white,
                        ),

                        const SizedBox(height: 8),

                        Text(
                          p['nombre']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          'Quedan: ${p['quedan']}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // ULTIMAS VENTAS
            const Text(
              'Últimas ventas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F4C6B),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  for (
                    int i = 0;
                    i < ultimasVentas.length;
                    i++
                  )
                    VentaRowWidget(
                      nombre:
                          ultimasVentas[i]['nombre']!,
                      hora:
                          ultimasVentas[i]['hora']!,
                      precio:
                          ultimasVentas[i]['precio']!,
                      mostrarLinea:
                          i != ultimasVentas.length - 1,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        roles: widget.roles,
      ),
    );
  }
}

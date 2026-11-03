import 'package:apparel/repositorio/factura_repositorio.dart';
import 'package:flutter/material.dart';

import '../core/dependencias.dart';
import '../modelo/factura_modelo.dart';
import '../widgets/barra_busq.dart';
import '../widgets/barra_sup.dart';
import '../widgets/widgets_com.dart';
import '../widgets/boton_nav.dart';
import 'detalle_factura_screens.dart';

class FacturacionScreen extends StatefulWidget {
  final List<String> roles;

  const FacturacionScreen({
    super.key,
    required this.roles,
  });

  @override
  State<FacturacionScreen> createState() =>
      _FacturacionScreenState();
}

class _FacturacionScreenState extends State<FacturacionScreen> {
  final FacturaRepositorio servicio =
      getIt<FacturaRepositorio>();

  String busqueda = '';

  List<FacturaModel> _filtrarFacturas(
      List<FacturaModel> facturas) {
    if (busqueda.isEmpty) return facturas;

    return facturas.where((f) {
      return f.id.toString().contains(busqueda) ||
          f.clienteId.toString().contains(busqueda);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2F3),

      appBar: const BarraSuperior(
        titulo: 'Facturacion',
        mostrarAtras: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BarraBusqueda(
              hint: 'Buscar Factura...',
              onChanged: (v) {
                setState(() {
                  busqueda = v;
                });
              },
            ),

            const SizedBox(height: 14),

            Expanded(
              child: FutureBuilder<List<FacturaModel>>(
                future: servicio.obtenerTodas(),

                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error al cargar facturas:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    );
                  }

                  final todasLasFacturas =
                      snapshot.data ?? [];

                  final lista =
                      _filtrarFacturas(todasLasFacturas);

                  if (lista.isEmpty) {
                    return const EstadoVacio(
                      icono: Icons.receipt_long_outlined,
                      mensaje: 'No hay facturas para mostrar',
                    );
                  }

                  return ListView.separated(
                    itemCount: lista.length,

                    separatorBuilder: (_, _) =>
                        const SizedBox(height: 12),

                    itemBuilder: (_, i) {
                      final f = lista[i];

                      final double totalFactura = f.total;

                      return TarjetaItem(
                        leading: const Icon(
                          Icons.receipt_long_outlined,
                          color: Color(0xFF1F5C7A),
                          size: 36,
                        ),

                        titulo: 'Factura #${f.id}',

                        subtitulo:
                            '${f.fecha.length >= 10 ? f.fecha.substring(0, 10) : f.fecha}    C\$ ${totalFactura.toStringAsFixed(2)}',

                        etiqueta: 'Cliente #${f.clienteId}',

                        colorEtiqueta:
                            const Color(0xFF1F5C7A),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetalleFacturaScreen(
                                factura: f,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // IMPORTANTE: Se envían los roles a la navegación.
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        roles: widget.roles,
      ),
    );
  }
}
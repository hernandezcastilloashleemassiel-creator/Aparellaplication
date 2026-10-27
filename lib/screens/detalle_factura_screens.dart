import 'package:flutter/material.dart';

import '../data/factura_data.dart';
import '../widgets/barra_sup.dart';
import '../widgets/factura_widgets.dart';

class DetalleFacturaScreen extends StatelessWidget {
  final Factura factura;

  const DetalleFacturaScreen({super.key, required this.factura});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F6),
      appBar: const BarraSuperior(titulo: 'Detalle de Factura'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CabeceraFactura(factura: factura),
            const SizedBox(height: 12),
            ProductosFactura(productos: factura.productos),
            const SizedBox(height: 12),
            TotalesFactura(subtotal: factura.total, total: factura.total),
          ],
        ),
      ),
    );
  }
}
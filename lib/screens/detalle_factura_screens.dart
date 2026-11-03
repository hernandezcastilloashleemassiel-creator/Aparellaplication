import 'package:apparel/modelo/factura_modelo.dart';
import 'package:flutter/material.dart';
import '../widgets/barra_sup.dart';
import '../widgets/factura_widgets.dart';

class DetalleFacturaScreen extends StatelessWidget {
  final FacturaModel factura;

  const DetalleFacturaScreen({super.key, required this.factura});

  @override
  Widget build(BuildContext context) {
    
    double subtotal = factura.detalleFacturaDTOs.fold(
      0.0,
      (sum, item) => sum + (item.cantidad * item.precioUnitario - item.descuento),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F2F3),
      appBar: const BarraSuperior(titulo: 'Detalle de Factura'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Corregido: Muestra el ID o número de la factura correctamente
                    Text('Factura #${factura.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Fecha: ${factura.fecha}'),
                    Text('Cliente ID: ${factura.clienteId}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Productos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: factura.detalleFacturaDTOs.length,
              itemBuilder: (context, index) {
                final detalle = factura.detalleFacturaDTOs[index];
                double totalItem = (detalle.cantidad * detalle.precioUnitario) - detalle.descuento;
                
                return ListTile(
                  title: Text(
                    detalle.nombre, 
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Cantidad: ${detalle.cantidad} x C\$ ${detalle.precioUnitario}'),
                  trailing: Text('C\$ ${totalItem.toStringAsFixed(2)}'),
                );
              },
            ),
            const SizedBox(height: 12),
            
            // Totales
            TotalesFactura(
              subtotal: subtotal,
              total: subtotal,
            ),
          ],
        ),
      ),
    );
  }
}
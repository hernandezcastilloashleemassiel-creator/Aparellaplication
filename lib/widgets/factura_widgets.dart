import 'package:flutter/material.dart';

import '../data/factura_data.dart';

/// Texto y color de la etiqueta según el estado de la factura
(String, Color) estadoVisual(EstadoFactura estado) {
  return switch (estado) {
    EstadoFactura.pagada => ('Pagada', const Color(0xFF8CE67A)),
    EstadoFactura.pendiente => ('Pendiente', const Color(0xFFF08080)),
    EstadoFactura.cancelada => ('Cancelada', const Color(0xFFF08080)),
  };
}

// ---------------------------------------------------------------
// ETIQUETA DE ESTADO (Pagada, Pendiente, Cancelada)
// ---------------------------------------------------------------
class EtiquetaEstado extends StatelessWidget {
  final String texto;
  final Color color;

  const EtiquetaEstado({super.key, required this.texto, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black26),
      ),
      child: Text(
        texto,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
      ),
    );
  }
}

// ---------------------------------------------------------------
// TARJETA BLANCA (contenedor de cada sección del detalle)
// ---------------------------------------------------------------
class TarjetaBlanca extends StatelessWidget {
  final Widget child;

  const TarjetaBlanca({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: child,
    );
  }
}

// ---------------------------------------------------------------
// CABECERA: código, fecha, estado, cliente, método de pago y total
// ---------------------------------------------------------------
class CabeceraFactura extends StatelessWidget {
  final Factura factura;

  const CabeceraFactura({super.key, required this.factura});

  Widget _dato(String titulo, String valor, CrossAxisAlignment alineacion) {
    return Column(
      crossAxisAlignment: alineacion,
      children: [
        Text(titulo,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(valor,
            style: const TextStyle(
                color: Color(0xFF1F5C7A),
                fontSize: 13,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final (texto, color) = estadoVisual(factura.estado);

    return TarjetaBlanca(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_outlined,
                  size: 40, color: Color(0xFF1F5C7A)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(factura.codigo,
                        style: const TextStyle(
                            color: Color(0xFF1F5C7A),
                            fontSize: 16,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 2),
                    Text('${factura.fechaTexto}   ${factura.horaTexto}',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              EtiquetaEstado(texto: texto, color: color),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dato('Cliente', factura.cliente, CrossAxisAlignment.start),
              _dato('Método de Pago', factura.metodoPago, CrossAxisAlignment.end),
            ],
          ),
          const SizedBox(height: 12),
          Text('TOTAL:  ${formatoMoneda(factura.total)}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// LISTA DE PRODUCTOS DE LA FACTURA
// ---------------------------------------------------------------
class ProductosFactura extends StatelessWidget {
  final List<ItemFactura> productos;

  const ProductosFactura({super.key, required this.productos});

  @override
  Widget build(BuildContext context) {
    return TarjetaBlanca(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Productos:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final p in productos)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.checkroom_outlined,
                      size: 34, color: Color(0xFF1F5C7A)),
                  Expanded(
                    child: Column(
                      children: [
                        Text(p.nombre,
                            style: const TextStyle(
                                color: Color(0xFF1F5C7A),
                                fontSize: 15,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 2),
                        Text('X${p.cantidad}',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Text(formatoMoneda(p.subtotal),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// SUBTOTAL Y TOTAL
// ---------------------------------------------------------------
class TotalesFactura extends StatelessWidget {
  final double subtotal;
  final double total;

  const TotalesFactura({
    super.key,
    required this.subtotal,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return TarjetaBlanca(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text(formatoMoneda(subtotal),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1F5C7A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TOTAL:',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                Text(formatoMoneda(total),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
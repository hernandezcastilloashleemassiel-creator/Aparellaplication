import 'package:flutter/material.dart';

class ResumenCardWidget extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String valor;
  final Color colorFondo;
  final Color colorCirculo;

  const ResumenCardWidget({
    super.key,
    required this.icono,
    required this.titulo,
    required this.valor,
    required this.colorFondo,
    required this.colorCirculo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorCirculo,
              shape: BoxShape.circle,
            ),
            child: Icon(icono, size: 24, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(titulo,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Text(valor,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
class VentaRowWidget extends StatelessWidget {
  final String nombre;
  final String hora;
  final String precio;
  final bool mostrarLinea;

  const VentaRowWidget({
    super.key,
    required this.nombre,
    required this.hora,
    required this.precio,
    this.mostrarLinea = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: mostrarLinea
            ? const Border(bottom: BorderSide(color: Color(0xFFD5DEE3)))
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFE3F3FA),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.checkroom,
                size: 20, color: Color(0xFF0F4C6B)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nombre,
                    style: const TextStyle(
                        color: Color(0xFF0F4C6B),
                        fontWeight: FontWeight.bold)),
                Text(hora,
                    style: const TextStyle(
                        color: Color(0xFF6B8594), fontSize: 12)),
              ],
            ),
          ),
          Text(precio,
              style: const TextStyle(
                  color: Color(0xFF0F4C6B),
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
        ],
      ),
    );
  }
}
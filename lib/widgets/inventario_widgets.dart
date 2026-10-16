import 'package:flutter/material.dart';

import '../data/colores_data.dart';
import '../data/productos_data.dart';

// ---------------------------------------------------------------
// BUSCADOR
// ---------------------------------------------------------------
class Buscador extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const Buscador({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFB8C7E6), width: 2),
            ),
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(color: kAzul, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: 'Buscar Producto...',
                hintStyle:
                    TextStyle(color: kAzul, fontWeight: FontWeight.bold),
                prefixIcon: Icon(Icons.search, color: Color(0xFF3F6FD1)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Icon(Icons.filter_alt_outlined, color: kAzul, size: 28),
      ],
    );
  }
}

// ---------------------------------------------------------------
// CHIPS DE FILTRO
// ---------------------------------------------------------------
class FiltroChips extends StatelessWidget {
  final int seleccionado;
  final ValueChanged<int> onSelected;
  const FiltroChips(
      {super.key, required this.seleccionado, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    const etiquetas = ['Todos', 'Stock Bajo', 'Agotados'];
    return Row(
      children: List.generate(etiquetas.length, (i) {
        final activo = seleccionado == i;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () => onSelected(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              decoration: BoxDecoration(
                color: activo ? kAzul : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12),
              ),
              child: Text(
                etiquetas[i],
                style: TextStyle(
                  color: activo ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------
// TARJETA DE RESUMEN
// ---------------------------------------------------------------
class ResumenCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final Color color;

  const ResumenCard({
    super.key,
    required this.titulo,
    required this.valor,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(titulo,
              style: const TextStyle(
                  color: kAzul, fontSize: 11, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(valor,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 26,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// TARJETA DE PRODUCTO
// ---------------------------------------------------------------
class ProductoCard extends StatelessWidget {
  final Producto producto;
  const ProductoCard({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    final (texto, color) = switch (producto.estado) {
      Estado.disponible => ('Disponible', kVerde),
      Estado.stockBajo => ('Stock Bajo', kRojo),
      Estado.agotado => ('Agotado', kRojo),
    };

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: Image.asset(
              producto.imagen,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image, color: Colors.grey, size: 40),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(producto.nombre,
                    style: const TextStyle(
                        color: kAzul,
                        fontSize: 15,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('Stock: ${producto.stock}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black26),
            ),
            child: Text(texto,
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w800)),
          ),
          const Icon(Icons.chevron_right, color: Colors.black87),
        ],
      ),
    );
  }
}
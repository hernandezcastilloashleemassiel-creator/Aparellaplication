import 'package:flutter/material.dart';

class BarraBusqueda extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback? onFiltro;

  const BarraBusqueda({
    super.key,
    required this.onChanged,
    this.hint = 'Buscar...',
    this.onFiltro,
  });

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
              style: const TextStyle(color: Color(0xFF1F5C7A), fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle:
                    const TextStyle(color: Color(0xFF1F5C7A), fontWeight: FontWeight.bold),
                prefixIcon:
                    const Icon(Icons.search, color: Color(0xFF3F6FD1)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onFiltro,
          child: Icon(Icons.filter_alt_outlined, color: const Color(0xFF1F5C7A), size: 28),
        ),
      ],
    );
  }
}

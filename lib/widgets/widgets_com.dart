import 'package:flutter/material.dart';
class FiltroChips extends StatelessWidget {
  final List<String> etiquetas;
  final int seleccionado;
  final ValueChanged<int> onSelected;

  const FiltroChips({
    super.key,
    required this.etiquetas,
    required this.seleccionado,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(etiquetas.length, (i) {
          final activo = seleccionado == i;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => onSelected(i),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                decoration: BoxDecoration(
                  color: activo ? const Color(0xFF1F5C7A) : Colors.white,
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
      ),
    );
  }
}


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
                  color: Color(0xFF1F5C7A), fontSize: 11, fontWeight: FontWeight.w800)),
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


class TarjetaItem extends StatelessWidget {
  final Widget leading; 
  final String titulo;
  final String subtitulo;
  final String etiqueta; 
  final Color colorEtiqueta;
  final bool centrado;
  final VoidCallback? onTap;

  const TarjetaItem({
    super.key,
    required this.leading,
    required this.titulo,
    required this.subtitulo,
    required this.etiqueta,
    required this.colorEtiqueta,
    this.centrado = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            SizedBox(width: 52, height: 52, child: leading),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: centrado
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  Text(titulo,
                      style: const TextStyle(
                          color: Color(0xFF1F5C7A),
                          fontSize: 15,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(subtitulo,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: colorEtiqueta,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black26),
              ),
              child: Text(etiqueta,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w800)),
            ),
                            
          ],
        ),
      ),
    );
  }
}


class EstadoVacio extends StatelessWidget {
  final IconData icono;
  final String mensaje;

  const EstadoVacio({
    super.key,
    required this.icono,
    required this.mensaje,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 56, color: const Color(0x991F5C7A)),
          const SizedBox(height: 8),
          Text(
            mensaje,
            style: const TextStyle(
              color: Color(0xFF1F5C7A),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}


Future<(int, int)?> mostrarHojaFiltros(
  BuildContext context, {
  required List<String> estados,
  required List<String> ordenes,
  required int estadoActual,
  required int ordenActual,
}) {
  return showModalBottomSheet<(int, int)>(
    context: context,
    backgroundColor: const Color(0xFFF2EBDC),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _HojaFiltros(
      estados: estados,
      ordenes: ordenes,
      estadoActual: estadoActual,
      ordenActual: ordenActual,
    ),
  );
}

class _HojaFiltros extends StatefulWidget {
  final List<String> estados;
  final List<String> ordenes;
  final int estadoActual;
  final int ordenActual;

  const _HojaFiltros({
    required this.estados,
    required this.ordenes,
    required this.estadoActual,
    required this.ordenActual,
  });

  @override
  State<_HojaFiltros> createState() => _HojaFiltrosState();
}

class _HojaFiltrosState extends State<_HojaFiltros> {
  late int estado = widget.estadoActual;
  late int orden = widget.ordenActual;

  Widget _opciones(List<String> etiquetas, int seleccionado,
      ValueChanged<int> onTap) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(etiquetas.length, (i) {
        final activo = seleccionado == i;
        return GestureDetector(
          onTap: () => setState(() => onTap(i)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: activo ? const Color(0xFF1F5C7A) : Colors.white,
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
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtrar',
              style: TextStyle(
                color: Color(0xFF1F5C7A),
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Estado',
                style: TextStyle(
                    color: Color(0xFF1F5C7A), fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _opciones(widget.estados, estado, (i) => estado = i),
            const SizedBox(height: 16),
            const Text('Ordenar por',
                style: TextStyle(
                    color: Color(0xFF1F5C7A), fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _opciones(widget.ordenes, orden, (i) => orden = i),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() {
                      estado = 0;
                      orden = 0;
                    }),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1F5C7A),
                      side: const BorderSide(color: Color(0xFF1F5C7A)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Limpiar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, (estado, orden)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F5C7A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Aplicar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

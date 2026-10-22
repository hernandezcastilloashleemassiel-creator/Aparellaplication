import 'package:flutter/material.dart';

import '../data/productos_data.dart';
import '../dependencias.dart';
import '../service/inventario_service.dart';
import '../widgets/barra_busq.dart';
import '../widgets/barra_sup.dart';
import '../widgets/widgets_com.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});
  
  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  final InventarioService servicio = getIt<InventarioService>();

  int filtro = 0; // 0 Todos, 1 Stock Bajo, 2 Agotados, 3 Disponibles
  int orden = 0; // 0 Sin orden, 1 Nombre, 2 Stock menor, 3 Stock mayor
  String busqueda = '';

  Future<void> _abrirFiltros() async {
    final r = await mostrarHojaFiltros(
      context,
      estados: const ['Todos', 'Stock Bajo', 'Agotados', 'Disponibles'],
      ordenes: const [
        'Sin orden',
        'Nombre (A-Z)',
        'Stock: menor a mayor',
        'Stock: mayor a menor',
      ],
      estadoActual: filtro,
      ordenActual: orden,
    );

    if (r != null) {
      setState(() {
        filtro = r.$1;
        orden = r.$2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lista = servicio.filtrar(
      filtro: filtro,
      busqueda: busqueda,
      orden: orden,
    );
    

    return Scaffold(
      backgroundColor: const Color(0xFFF2EBDC),
      appBar: const BarraSuperior(titulo: 'INVENTARIO', mostrarAtras: false),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BarraBusqueda(
              hint: 'Buscar Producto...',
              onChanged: (v) => setState(() => busqueda = v),
              onFiltro: _abrirFiltros,
            ),
            const SizedBox(height: 12),
            FiltroChips(
              etiquetas: const ['Todos', 'Stock Bajo', 'Agotados'],
              seleccionado: filtro,
              onSelected: (i) => setState(() => filtro = i),
            ),
            const SizedBox(height: 14),
            
            const SizedBox(height: 14),
            Expanded(
              child: lista.isEmpty
                  ? const EstadoVacio(
                      icono: Icons.inventory_2_outlined,
                      mensaje: 'No hay productos para mostrar',
                    )
                  : ListView.separated(
                      itemCount: lista.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final p = lista[i];
                        final (texto, color) = switch (p.estado) {
                          Estado.disponible =>
                            ('Disponible', const Color(0xFF8CE67A)),
                          Estado.stockBajo =>
                            ('Stock Bajo', const Color(0xFFF08080)),
                          Estado.agotado =>
                            ('Agotado', const Color(0xFFF08080)),
                        };

                        return TarjetaItem(
                          leading: const Icon(
                            Icons.checkroom_outlined,
                            color: Color(0xFF1F5C7A),
                            size: 36,
                          ),
                          titulo: p.nombre,
                          subtitulo: 'Stock: ${p.stock}',
                          etiqueta: texto,
                          colorEtiqueta: color,
                          centrado: true,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

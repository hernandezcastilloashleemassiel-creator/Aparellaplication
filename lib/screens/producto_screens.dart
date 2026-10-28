import 'package:flutter/material.dart';
import '../data/productos_data.dart';
import '../core/dependencias.dart';
import '../service/producto_service.dart';
import '../widgets/barra_busq.dart';
import '../widgets/barra_sup.dart';
import '../widgets/widgets_com.dart';
import '../widgets/boton_nav.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  final InventarioServicio servicio = getIt<InventarioServicio>();

  int filtro = 0;
  int orden = 0;
  String busqueda = '';

  bool cargando = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      cargando = true;
      error = null;
    });

    String? mensajeError;
    try {
      await servicio.cargar();
    } catch (e) {
      mensajeError = 'No se pudo cargar el inventario';
    }

    if (!mounted) return;
    setState(() {
      error = mensajeError;
      cargando = false;
    });
  }

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

  Widget _contenido(List<Producto> lista) {
    if (cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error!),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _cargar,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (lista.isEmpty) {
      return const EstadoVacio(
        icono: Icons.inventory_2_outlined,
        mensaje: 'No hay productos para mostrar',
      );
    }

    return RefreshIndicator(
      onRefresh: _cargar,
      child: ListView.separated(
        itemCount: lista.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final p = lista[i];
          final (texto, color) = switch (p.estado) {
            Estado.disponible => ('Disponible', const Color(0xFF8CE67A)),
            Estado.stockBajo => ('Stock Bajo', const Color(0xFFF08080)),
            Estado.agotado => ('Agotado', const Color(0xFFF08080)),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final lista = servicio.filtrar(
      filtro: filtro,
      busqueda: busqueda,
      orden: orden,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F2F3),
      appBar: const BarraSuperior(titulo: 'Inventario', mostrarAtras: false),
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
            Expanded(child: _contenido(lista)),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}
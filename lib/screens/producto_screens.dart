import 'package:flutter/material.dart';

import '../data/productos_data.dart';
import '../core/dependencias.dart';
import '../service/producto_service.dart';
import '../widgets/barra_busq.dart';
import '../widgets/barra_sup.dart';
import '../widgets/widgets_com.dart';
import '../widgets/boton_nav.dart';

class InventarioScreen extends StatefulWidget {
  final List<String> roles;

  const InventarioScreen({
    super.key,
    this.roles = const [],
  });

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  final InventarioServicio servicio =
      getIt<InventarioServicio>();

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
      estados: const [
        'Todos',
        'Stock Bajo',
        'Agotados',
        'Disponibles'
      ],
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

  bool _estaGuardandoEnProceso = false;

  Future<void> _abrirAgregar() async {
    final nombreCtrl = TextEditingController();
    final descripcionCtrl = TextEditingController();
    final precioCtrl = TextEditingController();
    final stockCtrl = TextEditingController();

    final guardado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (ctx) {
        bool guardandoLocal = false;
        String? errorModal;

        return StatefulBuilder(
          builder: (ctx, setModal) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Agregar producto',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F5C7A),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: nombreCtrl,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: descripcionCtrl,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Descripción (Opcional)',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: precioCtrl,
                    textInputAction: TextInputAction.next,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Precio (C\$)',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: stockCtrl,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Stock',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  if (errorModal != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      errorModal!,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1F5C7A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),

                      onPressed:
                          (guardandoLocal || _estaGuardandoEnProceso)
                              ? null
                              : () async {
                                  if (_estaGuardandoEnProceso) {
                                    return;
                                  }

                                  _estaGuardandoEnProceso = true;

                                  final nombre =
                                      nombreCtrl.text.trim();

                                  final descripcion =
                                      descripcionCtrl.text.trim();

                                  final precio =
                                      double.tryParse(precioCtrl.text);

                                  final stock =
                                      int.tryParse(stockCtrl.text);

                                  if (nombre.isEmpty ||
                                      precio == null ||
                                      stock == null) {
                                    _estaGuardandoEnProceso = false;

                                    setModal(() {
                                      errorModal =
                                          'Completa nombre, precio y stock';
                                    });

                                    return;
                                  }

                                  setModal(() {
                                    guardandoLocal = true;
                                    errorModal = null;
                                  });

                                  try {
                                    await servicio.agregar(
                                      nombre,
                                      stock,
                                      precio,
                                      1009,
                                      descripcion.isEmpty
                                          ? null
                                          : descripcion,
                                    );

                                    if (ctx.mounted) {
                                      Navigator.pop(ctx, true);
                                    }
                                  } catch (e) {
                                    _estaGuardandoEnProceso = false;

                                    setModal(() {
                                      guardandoLocal = false;
                                      errorModal = e
                                          .toString()
                                          .replaceFirst(
                                            'Exception: ',
                                            '',
                                          );
                                    });
                                  }
                                },

                      child: Text(
                        guardandoLocal
                            ? 'Guardando...'
                            : 'Guardar',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    _estaGuardandoEnProceso = false;

    if (guardado == true) {
      await _cargar();
    }

    nombreCtrl.dispose();
    descripcionCtrl.dispose();
    precioCtrl.dispose();
    stockCtrl.dispose();
  }

  Widget _contenido(List<Producto> lista) {
    if (cargando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
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

        separatorBuilder: (_, _) =>
            const SizedBox(height: 12),

        itemBuilder: (_, i) {
          final p = lista[i];

          final (texto, color) = switch (p.estado) {
            Estado.disponible => (
                'Disponible',
                const Color(0xFF8CE67A)
              ),
            Estado.stockBajo => (
                'Stock Bajo',
                const Color(0xFFF08080)
              ),
            Estado.agotado => (
                'Agotado',
                const Color(0xFFF08080)
              ),
          };

          return TarjetaItem(
            leading: const Icon(
              Icons.checkroom_outlined,
              color: Color(0xFF1F5C7A),
              size: 36,
            ),

            titulo: p.nombre,

            subtitulo:
                'Stock: ${p.stock}\nC\$ ${p.precio.toStringAsFixed(2)}',

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

      appBar: const BarraSuperior(
        titulo: 'Inventario',
        mostrarAtras: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            BarraBusqueda(
              hint: 'Buscar Producto...',
              onChanged: (v) {
                setState(() {
                  busqueda = v;
                });
              },
              onFiltro: _abrirFiltros,
            ),

            const SizedBox(height: 14),

            Expanded(
              child: _contenido(lista),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1F5C7A),
        onPressed: _abrirAgregar,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      // Se conservan los roles del usuario.
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        roles: widget.roles,
      ),
    );
  }
}
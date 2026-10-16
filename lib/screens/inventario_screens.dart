import 'package:flutter/material.dart';

import '../data/colores_data.dart';
import '../dependencias.dart';
import '../service/inventario_service.dart';
import '../widgets/inventario_widgets.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  // Se obtiene el servicio desde get_it
  final InventarioService servicio = getIt<InventarioService>();

  int filtro = 0;
  String busqueda = '';

  @override
  Widget build(BuildContext context) {
    final lista = servicio.filtrar(filtro: filtro, busqueda: busqueda);
    final resumen = servicio.obtenerResumen();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back, color: kAzul, size: 28),
                  ),
                  const Text(
                    'INVENTARIO',
                    style: TextStyle(
                      color: kAzul,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Buscador(onChanged: (v) => setState(() => busqueda = v)),
              const SizedBox(height: 12),
              FiltroChips(
                seleccionado: filtro,
                onSelected: (i) => setState(() => filtro = i),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ResumenCard(
                        titulo: 'Total Productos', valor: '${resumen.total}'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ResumenCard(
                        titulo: 'Stock Bajo', valor: '${resumen.stockBajo}'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ResumenCard(
                      titulo: 'Agotado',
                      valor: '${resumen.agotados}',
                      color: kRojo,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView.separated(
                  itemCount: lista.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => ProductoCard(producto: lista[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
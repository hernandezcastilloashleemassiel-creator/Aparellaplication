import 'package:flutter/material.dart';
import '../data/factura_data.dart';
import '../core/dependencias.dart';
import '../service/factura_service.dart';
import '../widgets/barra_busq.dart';
import '../widgets/barra_sup.dart';
import '../widgets/widgets_com.dart';
import '../widgets/factura_widgets.dart';
import 'detalle_factura_screens.dart';
import '../widgets/boton_nav.dart';

class FacturacionScreen extends StatefulWidget {
  const FacturacionScreen({super.key});

  @override
  State<FacturacionScreen> createState() => _FacturacionScreenState();
}

class _FacturacionScreenState extends State<FacturacionScreen> {
  final FacturaService servicio = getIt<FacturaService>();

  int filtro = 0; // 0 Todas, 1 Pagadas, 2 Pendientes, 3 Canceladas
  int orden = 0; // 0 Sin orden, 1 Recientes, 2 Antiguas, 3 Total mayor, 4 Total menor
  String busqueda = '';

  Future<void> _abrirFiltros() async {
    final r = await mostrarHojaFiltros(
      context,
      estados: const ['Todas', 'Pagadas', 'Pendientes', 'Canceladas'],
      ordenes: const [
        'Sin orden',
        'Más recientes',
        'Más antiguas',
        'Total: mayor a menor',
        'Total: menor a mayor',
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
      backgroundColor:const Color(0xFFEEF2F6),
      appBar: const BarraSuperior(titulo: 'Facturacion', mostrarAtras: false),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BarraBusqueda(
              hint: 'Buscar Usuario...',
              onChanged: (v) => setState(() => busqueda = v),
              onFiltro: _abrirFiltros,
            ),
            const SizedBox(height: 14),
            Expanded(
              child: lista.isEmpty
                  ? const EstadoVacio(
                      icono: Icons.receipt_long_outlined,
                      mensaje: 'No hay facturas para mostrar',
                    )
                  : ListView.separated(
                      itemCount: lista.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final f = lista[i];
                        final (texto, color) = estadoVisual(f.estado);

                        return TarjetaItem(
                          leading: const Icon(
                            Icons.receipt_long_outlined,
                            color: Color(0xFF1F5C7A),
                            size: 36,
                          ),
                          titulo: f.codigo,
                          subtitulo:
                              '${f.fechaTexto}   ${formatoMoneda(f.total)}',
                          etiqueta: texto,
                          colorEtiqueta: color,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetalleFacturaScreen(factura: f),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }
}
import '../data/productos_data.dart';

class InventarioService {
  final InventarioData data;

  InventarioService(this.data);

  /// filtro: 0 = Todos, 1 = Stock Bajo, 2 = Agotados
  List<Producto> filtrar({int filtro = 0, String busqueda = ''}) {
    return data.productos.where((p) {
      final coincide = p.nombre.toLowerCase().contains(busqueda.toLowerCase());
      final cumple = filtro == 0 ||
          (filtro == 1 && p.estado == Estado.stockBajo) ||
          (filtro == 2 && p.estado == Estado.agotado);
      return coincide && cumple;
    }).toList();
  }

  ResumenInventario obtenerResumen() => data.resumen;
}
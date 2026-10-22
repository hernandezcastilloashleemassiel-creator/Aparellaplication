import '../data/productos_data.dart';

class InventarioService {
  final InventarioData data;

  InventarioService(this.data);

 
  List<Producto> filtrar({
    int filtro = 0,
    String busqueda = '',
    int orden = 0,
  }) {
    final lista = data.productos.where((p) {
      final coincide = p.nombre.toLowerCase().contains(busqueda.toLowerCase());
      final cumple = filtro == 0 ||
          (filtro == 1 && p.estado == Estado.stockBajo) ||
          (filtro == 2 && p.estado == Estado.agotado) ||
          (filtro == 3 && p.estado == Estado.disponible);
      return coincide && cumple;
    }).toList();

    switch (orden) {
      case 1:
        lista.sort(
            (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
      case 2:
        lista.sort((a, b) => a.stock.compareTo(b.stock));
      case 3:
        lista.sort((a, b) => b.stock.compareTo(a.stock));
    }
    return lista;
  }

  
  ResumenInventario obtenerResumen() {
    final productos = data.productos;
    return ResumenInventario(
      productos.length,
      productos.where((p) => p.estado == Estado.stockBajo).length,
      productos.where((p) => p.estado == Estado.agotado).length,
    );
  }
}

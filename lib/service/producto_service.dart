import '../data/productos_data.dart';
import '../modelo/producto_modelo.dart';
import '../repositorio/producto_repositorio.dart';

class InventarioServicio {
  final ProductoRepositorio _repo;
  final InventarioData data;
  InventarioServicio(this._repo, this.data);

  static const int limiteStockBajo = 5; // tu regla de "stock bajo"

  Future<void> cargar() async {
    final modelos = await _repo.obtenerTodos();
    final productos = modelos
        .map(_aProducto)
        .toList();

    data.productos = productos;
    data.resumen = ResumenInventario(
      productos.length,
      productos.where((p) => p.estado == Estado.stockBajo).length,
      productos.where((p) => p.estado == Estado.agotado).length,
    );
  }

  Producto _aProducto(ProductoModel m) =>
      Producto(m.id, m.nombre, m.stock, m.precio, _calcularEstado(m.stock));

  Estado _calcularEstado(int stock) {
    if (stock <= 0) return Estado.agotado;
    if (stock <= limiteStockBajo) return Estado.stockBajo;
    return Estado.disponible;
  }

  List<Producto> filtrar({
    required int filtro,
    required String busqueda,
    required int orden,
  }) {
    var lista = data.productos.where((p) {
      final coincide = p.nombre.toLowerCase().contains(busqueda.toLowerCase());
      final estadoOk = switch (filtro) {
        1 => p.estado == Estado.stockBajo,
        2 => p.estado == Estado.agotado,
        3 => p.estado == Estado.disponible,
        _ => true,
      };
      return coincide && estadoOk;
    }).toList();

    switch (orden) {
      case 1:
        lista.sort((a, b) => a.nombre.compareTo(b.nombre));
      case 2:
        lista.sort((a, b) => a.stock.compareTo(b.stock));
      case 3:
        lista.sort((a, b) => b.stock.compareTo(a.stock));
    }
    return lista;
  }

  Future<void> agregar(
    String nombre,
    int stock,
    double precio,
    int categoriaId,
    String? descripcion,
  ) async {
    if (nombre.trim().isEmpty) {
      throw Exception('El nombre es obligatorio');
    }

    if (stock < 0) {
      throw Exception('El stock no puede ser negativo');
    }

    if (precio <= 0) {
      throw Exception('El precio debe ser mayor a 0');
    }

    final producto = ProductoModel(
      id: 0,
      categoriaId: categoriaId,
      nombre: nombre.trim(),
      descripcion: descripcion?.trim() ?? '',
      precio: precio,
      stock: stock,
      activo: true,
    );
    
    // Se ejecuta una sola vez para evitar duplicados
    await _repo.crear(producto);

    await cargar();
  }

  Future<void> eliminar(int id) async {
    await _repo.eliminar(id);
    await cargar();
  }
}
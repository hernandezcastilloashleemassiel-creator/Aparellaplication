enum Estado { disponible, stockBajo, agotado }

class Producto {
  final int id;
  final String nombre;
  final int stock;
  final double precio;
  final Estado estado;

  const Producto(this.id, this.nombre, this.stock, this.precio, this.estado);
}

class ResumenInventario {
  final int total;
  final int stockBajo;
  final int agotados;

  const ResumenInventario(this.total, this.stockBajo, this.agotados);
}

class InventarioData {
  List<Producto> productos = [];
  ResumenInventario resumen = const ResumenInventario(0, 0, 0);
}
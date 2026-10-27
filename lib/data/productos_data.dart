enum Estado { disponible, stockBajo, agotado }

class Producto {
  final String nombre;
  final int stock;
  final Estado estado;

  const Producto(this.nombre, this.stock, this.estado);
}

class ResumenInventario {
  final int total;
  final int stockBajo;
  final int agotados;

  const ResumenInventario(this.total, this.stockBajo, this.agotados);
}

class InventarioData {
  List<Producto> productos = [];

  
}

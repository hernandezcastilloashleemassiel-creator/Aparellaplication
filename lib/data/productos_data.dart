enum Estado { disponible, stockBajo, agotado }

class Producto {
  final String nombre;
  final int stock;
  final Estado estado;
  final String imagen; // ruta en assets

  const Producto(this.nombre, this.stock, this.estado, this.imagen);
}

class ResumenInventario {
  final int total;
  final int stockBajo;
  final int agotados;

  const ResumenInventario(this.total, this.stockBajo, this.agotados);
}
   class InventarioData {
     final ResumenInventario resumen = const ResumenInventario(248, 12, 3);

     final List<Producto> productos = const [
       Producto('Camisa oversize', 6, Estado.stockBajo, 'assets/camisa.png'),
       Producto('Pantalon', 5, Estado.disponible, 'assets/pantalon.png'),
       Producto('Gorra Nike', 4, Estado.agotado, 'assets/gorra.png'),
       Producto('Vestido', 7, Estado.disponible, 'assets/vestido.png'),
       Producto('Tennis Nike', 2, Estado.disponible, 'assets/tennis.png'),
       Producto('Chaqueta', 4, Estado.disponible, 'assets/chaqueta.png'),
     ];
   }
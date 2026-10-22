enum EstadoFactura { pagada, pendiente, cancelada }

class ItemFactura {
  final String nombre;
  final int cantidad;
  final double precio; 

  const ItemFactura(this.nombre, this.cantidad, this.precio);

  double get subtotal => cantidad * precio;
}

class Factura {
  final String codigo;
  final DateTime fecha;
  final String cliente;
  final String metodoPago;
  final EstadoFactura estado;
  final List<ItemFactura> productos;

  const Factura({
    required this.codigo,
    required this.fecha,
    required this.cliente,
    required this.metodoPago,
    required this.estado,
    required this.productos,
  });

  
  double get total => productos.fold(0.0, (suma, p) => suma + p.subtotal);

  String get fechaTexto {
    final d = fecha.day.toString().padLeft(2, '0');
    final m = fecha.month.toString().padLeft(2, '0');
    return '$d/$m/${fecha.year}';
  }

  String get horaTexto {
    final h = fecha.hour % 12 == 0 ? 12 : fecha.hour % 12;
    final min = fecha.minute.toString().padLeft(2, '0');
    return '$h:$min${fecha.hour >= 12 ? 'pm' : 'am'}';
  }
}


class FacturaData {
  List<Factura> facturas = [];

  
}

String formatoMoneda(double valor) {
  final texto = valor.toStringAsFixed(valor % 1 == 0 ? 0 : 2);
  final partes = texto.split('.');
  final digitos = partes[0];
  final buffer = StringBuffer();
  for (var i = 0; i < digitos.length; i++) {
    if (i > 0 && (digitos.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digitos[i]);
  }
  final decimales = partes.length > 1 ? '.${partes[1]}' : '';
  return r'C$' + buffer.toString() + decimales;
}

class DetalleFacturaModel {
  final int id;
  final int facturaId;
  final int productoId;
  final String descripcion;
  final String nombre;
  final int cantidad;
  final double precioUnitario;
  final double descuento;

  DetalleFacturaModel({
    this.id = 0,
    this.facturaId = 0,
    required this.productoId,
    this.descripcion = '',
    required this.nombre,
    required this.cantidad,
    required this.precioUnitario,
    this.descuento = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'facturaId': facturaId,
      'productoId': productoId,
      'descripcion': descripcion,
      'nombre': nombre,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'descuento': descuento,
    };
  }

  factory DetalleFacturaModel.fromJson(Map<String, dynamic> json) {
    return DetalleFacturaModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,

      facturaId: int.tryParse(
            json['facturaId']?.toString() ?? '',
          ) ??
          0,

      productoId: int.tryParse(
            json['productoId']?.toString() ?? '',
          ) ??
          0,

      // Leer el nombre aunque la API use mayúsculas o minúsculas.
      nombre: (
        json['nombre'] ??
        json['Nombre'] ??
        json['nombreproducto'] ??
        json['nombreProducto'] ??
        json['producto']?['nombre'] ??
        json['producto']?['Nombre'] ??
        'Producto'
      ).toString(),

      descripcion: json['descripcion']?.toString() ?? '',

      cantidad: int.tryParse(
            json['cantidad']?.toString() ?? '',
          ) ??
          0,

      precioUnitario: double.tryParse(
            json['precioUnitario']?.toString() ?? '',
          ) ??
          0.0,

      descuento: double.tryParse(
            json['descuento']?.toString() ?? '',
          ) ??
          0.0,
    );
  }
}

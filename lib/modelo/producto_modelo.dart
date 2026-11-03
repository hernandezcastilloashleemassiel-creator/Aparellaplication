
class ProductoModel {
  final int id;
  final int categoriaId;
  final String nombreCategoria;
  final String nombre;
  final String descripcion;
  final double precio;
  final int stock;
  final bool activo;

  ProductoModel({
    required this.id,
    required this.categoriaId,
    this.nombreCategoria = '',
    required this.nombre,
    this.descripcion = '',
    required this.precio,
    required this.stock,
    required this.activo,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      categoriaId: int.tryParse(
            json['categoriaId']?.toString() ?? '',
          ) ?? 0,
      nombreCategoria: json['nombreCategoria']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      precio: (json['precio'] as num? ?? 0).toDouble(),
      stock: int.tryParse(json['stock']?.toString() ?? '') ?? 0,
      activo: json['activo'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoriaId': categoriaId,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'stock': stock,
      'activo': activo,
    };
  }
}

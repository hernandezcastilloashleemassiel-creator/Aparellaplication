class ProductoModel {
  final int id;
  final int categoriaId;
  final String? nombreCategoria;
  final String nombre;
  final String? descripcion;
  final double precio;
  final int stock;
  final bool activo;

  ProductoModel({
    required this.id,
    required this.categoriaId,
    this.nombreCategoria,
    required this.nombre,
    this.descripcion,
    required this.precio,
    required this.stock,
    required this.activo,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        id: json['id'] as int,
        categoriaId: json['categoriaId'] as int,
        nombreCategoria: json['nombreCategoria'] as String?,
        nombre: json['nombre'] as String,
        descripcion: json['descripcion'] as String?,
        precio: (json['precio'] as num).toDouble(),
        stock: json['stock'] as int,
        activo: json['activo'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoriaId': categoriaId,
        'nombre': nombre,
        'descripcion': descripcion,
        'precio': precio,
        'stock': stock,
        'activo': activo,
      };
}
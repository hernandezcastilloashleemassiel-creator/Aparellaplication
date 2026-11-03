
import 'detallefactura_modelo.dart';

class FacturaModel {
  final int id;
  final int clienteId;
  final String fecha;
  final double total;
  final List<DetalleFacturaModel> detalleFacturaDTOs;

  FacturaModel({
    this.id = 0,
    required this.clienteId,
    required this.fecha,
    this.total = 0.0,
    required this.detalleFacturaDTOs,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clienteId': clienteId,
      'fecha': fecha,
      'total': total,
      'detalleFacturaDTOs':
          detalleFacturaDTOs.map((d) => d.toJson()).toList(),
    };
  }

  factory FacturaModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list =
        json['detalleFacturaDTOs'] ??
        json['DetalleFacturaDTOs'] ??
        [];

    final List<DetalleFacturaModel> detallesList =
        list.map((i) => DetalleFacturaModel.fromJson(i)).toList();

    // Primero intenta obtener el total directamente de la API.
    final dynamic totalJson = json['total'] ?? json['Total'];

    // Si la API no lo devuelve, se calcula usando los detalles.
    final double totalCalculado = detallesList.fold(
      0.0,
      (sum, detalle) =>
          sum +
          (detalle.cantidad * detalle.precioUnitario -
              detalle.descuento),
    );

    final double totalFactura =
        double.tryParse(totalJson?.toString() ?? '') ??
        totalCalculado;

    return FacturaModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,

      clienteId:
          int.tryParse(json['clienteId']?.toString() ?? '') ?? 0,

      fecha: json['fecha']?.toString() ?? '',

      total: totalFactura,

      detalleFacturaDTOs: detallesList,
    );
  }
}

import '../data/factura_data.dart';

class FacturaService {
  final FacturaData data;

  FacturaService(this.data);

  /// filtro: 0 = Todas, 1 = Pagadas, 2 = Pendientes, 3 = Canceladas
  /// orden:  0 = Sin orden, 1 = Más recientes, 2 = Más antiguas,
  ///         3 = Total mayor a menor, 4 = Total menor a mayor
  List<Factura> filtrar({
    int filtro = 0,
    String busqueda = '',
    int orden = 0,
  }) {
    final texto = busqueda.toLowerCase();

    final lista = data.facturas.where((f) {
      final coincide = f.cliente.toLowerCase().contains(texto) ||
          f.codigo.toLowerCase().contains(texto);
      final cumple = filtro == 0 ||
          (filtro == 1 && f.estado == EstadoFactura.pagada) ||
          (filtro == 2 && f.estado == EstadoFactura.pendiente) ||
          (filtro == 3 && f.estado == EstadoFactura.cancelada);
      return coincide && cumple;
    }).toList();

    switch (orden) {
      case 1:
        lista.sort((a, b) => b.fecha.compareTo(a.fecha));
      case 2:
        lista.sort((a, b) => a.fecha.compareTo(b.fecha));
      case 3:
        lista.sort((a, b) => b.total.compareTo(a.total));
      case 4:
        lista.sort((a, b) => a.total.compareTo(b.total));
    }
    return lista;
  }
}
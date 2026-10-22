import 'package:get_it/get_it.dart';

import 'data/login_data.dart';
import 'service/login_service.dart';
import 'data/productos_data.dart';
import 'service/inventario_service.dart';
import 'data/factura_data.dart';
import 'service/factura_service.dart';
<<<<<<< HEAD
=======

>>>>>>> Fernanda-Narvaez

final getIt = GetIt.instance;

void configurarDependencias() {
  // Login
  getIt.registerLazySingleton<LoginData>(() => LoginData());
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(getIt<LoginData>()),
  );

  // Inventario (Registrado una sola vez de forma correcta)
  getIt.registerLazySingleton<InventarioData>(() => InventarioData());
  getIt.registerLazySingleton<InventarioService>(
    () => InventarioService(getIt<InventarioData>()),
  );

  // Factura
  getIt.registerLazySingleton<FacturaData>(() => FacturaData());
  getIt.registerLazySingleton<FacturaService>(
    () => FacturaService(getIt<FacturaData>()),
  );
<<<<<<< HEAD
=======

>>>>>>> Fernanda-Narvaez
}
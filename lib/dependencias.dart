import 'package:get_it/get_it.dart';
import 'data/login_data.dart';
import 'service/login_service.dart';
import 'data/productos_data.dart';
import 'service/inventario_service.dart';

final getIt = GetIt.instance;

void configurarDependencias() {
  getIt.registerLazySingleton<LoginData>(() => LoginData());
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(getIt<LoginData>()),
  );
}
void dependenciasInventario() {
  // Data
  getIt.registerLazySingleton<InventarioData>(() => InventarioData());

  // Service (recibe la data desde get_it)
  getIt.registerLazySingleton<InventarioService>(
    () => InventarioService(getIt<InventarioData>()),
  );
}
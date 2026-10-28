import 'package:get_it/get_it.dart';
import '../data/login_data.dart';
import '../repositorio/login_repositorio.dart';
import '../service/login_service.dart';
import 'token.dart';
import '../data/factura_data.dart';
import '../service/factura_service.dart';
import '../data/productos_data.dart';
import '../service/producto_service.dart';
import '../repositorio/producto_repositorio.dart';

final getIt = GetIt.instance;

void configurarDependencias() {
  getIt.registerLazySingleton<TokenStorage>(() => TokenStorage());

  // Login
  getIt.registerLazySingleton<LoginData>(() => LoginData());
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<LoginData>(), getIt<TokenStorage>()),
  );
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(getIt<AuthRepository>()),
  );

  // Factura
  getIt.registerLazySingleton<FacturaData>(() => FacturaData());
  getIt.registerLazySingleton<FacturaService>(
    () => FacturaService(getIt<FacturaData>()),
  );

  // Inventario
  getIt.registerLazySingleton<InventarioData>(() => InventarioData());
  getIt.registerLazySingleton<ProductoRepositorio>(
    () => ProductoRepositorio(getIt<TokenStorage>()),
  );
  getIt.registerLazySingleton<InventarioServicio>(
    () => InventarioServicio(
      getIt<ProductoRepositorio>(),
      getIt<InventarioData>(),
    ),
  );
}
import 'package:apparel/repositorio/factura_repositorio.dart';
import 'package:get_it/get_it.dart';
// import 'package:http/http.dart';
import '../data/login_data.dart';
import '../repositorio/login_repositorio.dart';
import '../service/login_service.dart';
import 'token.dart';
import '../data/factura_data.dart';
import '../data/productos_data.dart';
import '../service/producto_service.dart';
import '../repositorio/producto_repositorio.dart';
import '../service/perfil_service.dart';
import '../repositorio/perfil_repositorio.dart';
import '../repositorio/user_repositorio.dart';
import '../service/user_service.dart';

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
  getIt.registerLazySingleton<FacturaRepositorio>(
    () => FacturaRepositorio(getIt<TokenStorage>()),
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
  // Perfil
getIt.registerLazySingleton<PerfilRepositorio>(
  () => PerfilRepositorio(getIt<TokenStorage>()),
);
getIt.registerLazySingleton<PerfilService>(
  () => PerfilService(getIt<PerfilRepositorio>()),
);

// Usuarios

  getIt.registerLazySingleton<UserRepositorio>(

    () => UserRepositorio(

      tokenStorage: getIt<TokenStorage>(),

    ),

  );

  getIt.registerLazySingleton<UserServicio>(

    () => UserServicio(

      repositorio: getIt<UserRepositorio>(),

    ),

  );
}
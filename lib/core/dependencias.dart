import 'package:get_it/get_it.dart';
import '../data/login_data.dart';
import '../repositorio/login_repositorio.dart';
import '../service/login_service.dart';
import 'token.dart';

final getIt = GetIt.instance;

void configurarDependencias() {
  // Core
  getIt.registerLazySingleton<TokenStorage>(() => TokenStorage());

  // Login
  getIt.registerLazySingleton<LoginData>(() => LoginData());
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<LoginData>(), getIt<TokenStorage>()),
  );
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(getIt<AuthRepository>()),
  );
}
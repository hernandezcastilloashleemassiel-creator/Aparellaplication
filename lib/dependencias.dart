import 'package:get_it/get_it.dart';
import 'data/login_data.dart';
import 'service/login_service.dart';

final getIt = GetIt.instance;

void configurarDependencias() {
  getIt.registerLazySingleton<LoginData>(() => LoginData());
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(getIt<LoginData>()),
  );
}
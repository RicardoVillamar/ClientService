import 'package:get_it/get_it.dart';
import '../repositories/empleado_repository.dart';
import '../repositories/cliente_repository.dart';
import '../repositories/instalacion_repository.dart';
import '../repositories/camara_repository.dart';
import '../repositories/vehiculo_repository.dart';
import '../viewmodel/empleado_viewmodel.dart';
import '../viewmodel/cliente_viewmodel.dart';
import '../viewmodel/instalacion_viewmodel.dart';
import '../viewmodel/camara_viewmodel.dart';
import '../viewmodel/vehiculo_viewmodel.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Repositories
  sl.registerLazySingleton<EmpleadoRepository>(() => EmpleadoRepository());
  sl.registerLazySingleton<ClienteRepository>(() => ClienteRepository());
  sl.registerLazySingleton<InstalacionRepository>(
      () => InstalacionRepository());
  sl.registerLazySingleton<CamaraRepository>(() => CamaraRepository());
  sl.registerLazySingleton<VehiculoRepository>(() => VehiculoRepository());

  // ViewModels - Factory para crear nuevas instancias cada vez
  sl.registerFactory<EmpleadoViewmodel>(
      () => EmpleadoViewmodel(sl<EmpleadoRepository>()));
  sl.registerFactory<ClienteViewModel>(
      () => ClienteViewModel(sl<ClienteRepository>()));
  sl.registerFactory<InstalacionViewModel>(
      () => InstalacionViewModel(sl<InstalacionRepository>()));
  sl.registerFactory<CamaraViewModel>(
      () => CamaraViewModel(sl<CamaraRepository>()));
  sl.registerFactory<AlquilerViewModel>(
      () => AlquilerViewModel(sl<VehiculoRepository>()));
}

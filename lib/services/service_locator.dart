import 'package:get_it/get_it.dart';
import '../repositories/empleado_repository.dart';
import '../repositories/cliente_repository.dart';
import '../repositories/instalacion_repository.dart';
import '../repositories/camara_repository.dart';
import '../repositories/vehiculo_repository.dart';
import '../repositories/factura_repository.dart';
import '../viewmodel/empleado_viewmodel.dart';
import '../viewmodel/cliente_viewmodel.dart';
import '../viewmodel/instalacion_viewmodel.dart';
import '../viewmodel/camara_viewmodel.dart';
import '../viewmodel/vehiculo_viewmodel.dart';
import '../viewmodel/factura_viewmodel.dart';
import '../services/notificacion_service.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Services
  sl.registerLazySingleton<NotificacionService>(() => NotificacionService());

  // Repositories
  sl.registerLazySingleton<EmpleadoRepository>(() => EmpleadoRepository());
  sl.registerLazySingleton<ClienteRepository>(() => ClienteRepository());
  sl.registerLazySingleton<InstalacionRepository>(
      () => InstalacionRepository());
  sl.registerLazySingleton<CamaraRepository>(() => CamaraRepository());
  sl.registerLazySingleton<VehiculoRepository>(() => VehiculoRepository());
  sl.registerLazySingleton<FacturaRepository>(() => FacturaRepository());

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
  sl.registerFactory<FacturaViewModel>(
      () => FacturaViewModel(sl<FacturaRepository>()));
  // Para usar CalendarioViewModel ahora debes pasar la cédula y el cargo del empleado autenticado:
  // Ejemplo:
  // sl.registerFactory<CalendarioViewModel>(() => CalendarioViewModel(
  //   sl<CamaraRepository>(),
  //   sl<InstalacionRepository>(),
  //   sl<VehiculoRepository>(),
  //   cedulaEmpleado: '1234567890',
  //   cargoEmpleado: CargoEmpleado.tecnico,
  // ));
  //
  // Por lo general, deberás crear la instancia manualmente donde tengas la info del usuario autenticado.

  // Inicializar servicios que lo requieran
  await sl<NotificacionService>().inicializar();
}

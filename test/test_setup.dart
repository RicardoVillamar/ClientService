import 'package:get_it/get_it.dart';
import 'package:client_service/viewmodel/cliente_viewmodel.dart';
import 'package:client_service/viewmodel/empleado_viewmodel.dart';
import 'package:client_service/viewmodel/factura_viewmodel.dart';
import 'package:client_service/viewmodel/camara_viewmodel.dart';
import 'package:client_service/viewmodel/instalacion_viewmodel.dart';
import 'package:client_service/viewmodel/vehiculo_viewmodel.dart';
import 'package:client_service/repositories/cliente_repository.dart';
import 'package:client_service/repositories/empleado_repository.dart';
import 'package:client_service/repositories/factura_repository.dart';
import 'package:client_service/repositories/camara_repository.dart';
import 'package:client_service/repositories/instalacion_repository.dart';
import 'package:client_service/repositories/vehiculo_repository.dart';
import 'package:client_service/models/cliente.dart';
import 'package:client_service/models/empleado.dart';
import 'package:client_service/models/factura.dart';
import 'package:client_service/models/camara.dart';
import 'package:client_service/models/instalacion.dart';
import 'package:client_service/models/vehiculo.dart';
import 'mocks.mocks.dart';
import 'firebase_test_setup.dart';

// Manual mock for ClienteViewModel to avoid mockito issues
class TestClienteViewModel extends ClienteViewModel {
  TestClienteViewModel() : super(MockClienteRepository());

  final List<Cliente> _testClientes = [
    Cliente(
      id: '1',
      nombreComercial: 'Empresa Test',
      ruc: '1234567890',
      direccion: 'Dirección Test',
      telefono: '0999999999',
      correo: 'test@empresa.com',
      personaContacto: 'Contacto Test',
      cedula: '12345678',
    )
  ];

  @override
  Future<List<Cliente>> obtenerClientes() async {
    return _testClientes;
  }

  @override
  List<Cliente> get clientes => _testClientes;

  @override
  bool get isLoading => false;
}

// Manual mock for EmpleadoViewmodel
class TestEmpleadoViewmodel extends EmpleadoViewmodel {
  TestEmpleadoViewmodel() : super(MockEmpleadoRepository());

  final List<Empleado> _testEmpleados = [
    Empleado(
      id: '1',
      nombre: 'Juan',
      apellido: 'Pérez',
      cedula: '1234567890',
      direccion: 'Dirección Test',
      telefono: '0999999999',
      correo: 'juan@empresa.com',
      cargo: CargoEmpleado.tecnico,
      fechaContratacion: DateTime(2023, 1, 1),
      fotoUrl: '',
      password: '',
    )
  ];

  @override
  Future<List<Empleado>> obtenerEmpleados() async {
    return _testEmpleados;
  }

  @override
  List<Empleado> get empleados => _testEmpleados;

  @override
  bool get isLoading => false;
}

// Manual mock for FacturaViewModel
class TestFacturaViewModel extends FacturaViewModel {
  TestFacturaViewModel() : super(MockFacturaRepository());

  final List<Factura> _testFacturas = [
    Factura(
      id: '1',
      numeroFactura: 'F001',
      fechaEmision: DateTime(2023, 1, 1),
      fechaVencimiento: DateTime(2023, 1, 31),
      clienteId: '1',
      nombreCliente: 'Empresa Test',
      direccionCliente: 'Dirección Test',
      telefonoCliente: '0999999999',
      correoCliente: 'test@empresa.com',
      tipoServicio: TipoServicio.camara,
      servicioId: 'serv1',
      items: [
        ItemFactura(descripcion: 'Servicio', cantidad: 1, precioUnitario: 100.0)
      ],
      impuesto: 13.0,
      estado: EstadoFactura.pendiente,
      fechaCreacion: DateTime(2023, 1, 1),
      creadoPor: 'admin',
    )
  ];

  @override
  Future<String> generarNumeroFactura() async => 'F001';

  @override
  Future<void> fetchFacturas() async {}

  @override
  List<Factura> get facturas => _testFacturas;

  @override
  bool get isLoading => false;
}

// Manual mock for CamaraViewModel
class TestCamaraViewModel extends CamaraViewModel {
  TestCamaraViewModel() : super(MockCamaraRepository());

  final List<Camara> _testCamaras = [
    Camara(
      id: '1',
      nombreComercial: 'Empresa Test',
      fechaMantenimiento: DateTime(2023, 1, 1),
      direccion: 'Dirección Test',
      tecnico: 'Técnico Test',
      tipo: 'IP',
      descripcion: 'Cámara de seguridad',
      costo: 100.0,
      estado: EstadoCamara.pendiente,
    )
  ];

  @override
  Future<List<Camara>> obtenerCamaras() async {
    return _testCamaras;
  }

  @override
  List<Camara> get camaras => _testCamaras;

  @override
  bool get isLoading => false;
}

// Manual mock for InstalacionViewModel
class TestInstalacionViewModel extends InstalacionViewModel {
  TestInstalacionViewModel() : super(MockInstalacionRepository());

  final List<Instalacion> _testInstalaciones = [
    Instalacion(
      id: '1',
      fechaInstalacion: DateTime(2023, 1, 1),
      cedula: '12345678',
      nombreComercial: 'Empresa Test',
      direccion: 'Dirección Test',
      item: 'Poste',
      descripcion: 'Instalación de poste',
      horaInicio: '08:00',
      horaFin: '12:00',
      tipoTrabajo: 'Montaje',
      cargoPuesto: 'Técnico',
      telefono: '0777777777',
      numeroTarea: 'T001',
      estado: EstadoInstalacion.pendiente,
    )
  ];

  @override
  Future<List<Instalacion>> obtenerInstalaciones() async {
    return _testInstalaciones;
  }

  @override
  List<Instalacion> get instalaciones => _testInstalaciones;

  @override
  bool get isLoading => false;
}

// Manual mock for AlquilerViewModel
class TestAlquilerViewModel extends AlquilerViewModel {
  TestAlquilerViewModel() : super(MockVehiculoRepository());

  final List<Alquiler> _testAlquileres = [
    Alquiler(
      id: '1',
      nombreComercial: 'Empresa Test',
      direccion: 'Dirección Test',
      telefono: '0888888888',
      correo: 'test@empresa.com',
      tipoVehiculo: 'Camioneta',
      fechaReserva: DateTime(2023, 1, 1),
      fechaTrabajo: DateTime(2023, 1, 2),
      montoAlquiler: 200.0,
      personalAsistio: 'Personal Test',
      estado: EstadoAlquiler.pendiente,
    )
  ];

  @override
  Future<List<Alquiler>> obtenerAlquileres() async {
    return _testAlquileres;
  }

  @override
  List<Alquiler> get alquileres => _testAlquileres;

  @override
  bool get isLoading => false;
}

void setupTestDependencies() {
  // Setup Firebase mocks first
  setupFirebaseMocks();

  final sl = GetIt.instance;

  // Clear any existing registrations
  if (sl.isRegistered<ClienteViewModel>()) {
    sl.unregister<ClienteViewModel>();
  }
  if (sl.isRegistered<EmpleadoViewmodel>()) {
    sl.unregister<EmpleadoViewmodel>();
  }
  if (sl.isRegistered<FacturaViewModel>()) {
    sl.unregister<FacturaViewModel>();
  }
  if (sl.isRegistered<CamaraViewModel>()) {
    sl.unregister<CamaraViewModel>();
  }
  if (sl.isRegistered<InstalacionViewModel>()) {
    sl.unregister<InstalacionViewModel>();
  }
  if (sl.isRegistered<AlquilerViewModel>()) {
    sl.unregister<AlquilerViewModel>();
  }

  // Register mock repositories
  sl.registerLazySingleton<ClienteRepository>(() => MockClienteRepository());
  sl.registerLazySingleton<EmpleadoRepository>(() => MockEmpleadoRepository());
  sl.registerLazySingleton<FacturaRepository>(() => MockFacturaRepository());
  sl.registerLazySingleton<CamaraRepository>(() => MockCamaraRepository());
  sl.registerLazySingleton<InstalacionRepository>(
      () => MockInstalacionRepository());
  sl.registerLazySingleton<VehiculoRepository>(() => MockVehiculoRepository());

  // Create test viewmodels
  final testClienteViewModel = TestClienteViewModel();
  final testEmpleadoViewmodel = TestEmpleadoViewmodel();
  final testFacturaViewModel = TestFacturaViewModel();
  final testCamaraViewModel = TestCamaraViewModel();
  final testInstalacionViewModel = TestInstalacionViewModel();
  final testAlquilerViewModel = TestAlquilerViewModel();

  // Register test viewmodels
  sl.registerSingleton<ClienteViewModel>(testClienteViewModel);
  sl.registerSingleton<EmpleadoViewmodel>(testEmpleadoViewmodel);
  sl.registerSingleton<FacturaViewModel>(testFacturaViewModel);
  sl.registerSingleton<CamaraViewModel>(testCamaraViewModel);
  sl.registerSingleton<InstalacionViewModel>(testInstalacionViewModel);
  sl.registerSingleton<AlquilerViewModel>(testAlquilerViewModel);
}

void tearDownTestDependencies() {
  final sl = GetIt.instance;
  sl.reset();
}

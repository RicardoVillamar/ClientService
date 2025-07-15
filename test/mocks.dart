import 'package:mockito/annotations.dart';
import 'package:client_service/repositories/cliente_repository.dart';
import 'package:client_service/repositories/empleado_repository.dart';
import 'package:client_service/repositories/factura_repository.dart';
import 'package:client_service/repositories/camara_repository.dart';
import 'package:client_service/repositories/vehiculo_repository.dart';
import 'package:client_service/repositories/instalacion_repository.dart';

@GenerateMocks([
  ClienteRepository,
  EmpleadoRepository,
  FacturaRepository,
  CamaraRepository,
  VehiculoRepository,
  InstalacionRepository,
])
void main() {}

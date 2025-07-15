import 'package:flutter_test/flutter_test.dart';
import 'package:client_service/viewmodel/calendario_viewmodel.dart';
import 'package:client_service/utils/events/evento_calendario.dart';
import '../mocks.mocks.dart';

void main() {
  group('CalendarioViewModel', () {
    late CalendarioViewModel viewModel;
    late MockCamaraRepository camaraRepo;
    late MockInstalacionRepository instalacionRepo;
    late MockVehiculoRepository vehiculoRepo;

    setUp(() {
      camaraRepo = MockCamaraRepository();
      instalacionRepo = MockInstalacionRepository();
      vehiculoRepo = MockVehiculoRepository();
      viewModel =
          CalendarioViewModel(camaraRepo, instalacionRepo, vehiculoRepo);
    });

    test('Filtra eventos por técnico/empleado', () async {
      final eventos = [
        EventoCalendario(
          id: '1',
          titulo: 'Servicio 1',
          descripcion: '',
          fecha: DateTime.now(),
          horaInicio: '08:00',
          tipo: TipoServicio.camara,
          estado: 'Pendiente',
          tecnico: '1234567890',
          servicioOriginal: null,
        ),
        EventoCalendario(
          id: '2',
          titulo: 'Servicio 2',
          descripcion: '',
          fecha: DateTime.now(),
          horaInicio: '09:00',
          tipo: TipoServicio.instalacion,
          estado: 'Pendiente',
          tecnico: 'admin@empresa.com',
          servicioOriginal: null,
        ),
      ];
      // Exponer _eventos para test (solo para test)
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      viewModel.eventos.clear();
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      viewModel.eventos.addAll(eventos);
      final filtrados = viewModel.filtrarEventosPorTipo(TipoServicio.camara);
      expect(filtrados.length, 1);
      expect(filtrados.first.tecnico, '1234567890');
    });
  });
}

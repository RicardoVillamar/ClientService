import 'package:client_service/utils/events/evento_calendario.dart';
import 'package:client_service/repositories/camara_repository.dart';
import 'package:client_service/repositories/instalacion_repository.dart';
import 'package:client_service/repositories/vehiculo_repository.dart';
import 'package:client_service/viewmodel/base_viewmodel.dart';

class CalendarioViewModel extends BaseViewModel {
  final CamaraRepository _camaraRepository;
  final InstalacionRepository _instalacionRepository;
  final VehiculoRepository _vehiculoRepository;

  CalendarioViewModel(
    this._camaraRepository,
    this._instalacionRepository,
    this._vehiculoRepository,
  );

  List<EventoCalendario> _eventos = [];
  List<EventoCalendario> get eventos => _eventos;

  Map<DateTime, List<EventoCalendario>> _eventosPorFecha = {};
  Map<DateTime, List<EventoCalendario>> get eventosPorFecha => _eventosPorFecha;

  DateTime _fechaSeleccionada = DateTime.now();
  DateTime get fechaSeleccionada => _fechaSeleccionada;

  List<EventoCalendario> get eventosDelDia {
    final fecha = DateTime(_fechaSeleccionada.year, _fechaSeleccionada.month, _fechaSeleccionada.day);
    return _eventosPorFecha[fecha] ?? [];
  }

  // Cargar todos los eventos
  Future<void> cargarEventos() async {
    try {
      setLoading(true);
      clearError();

      final List<EventoCalendario> todosLosEventos = [];

      // Cargar eventos de cámaras
      final camaras = await _camaraRepository.getAll();
      todosLosEventos.addAll(camaras.map(EventoCalendario.fromCamara));

      // Cargar eventos de instalaciones
      final instalaciones = await _instalacionRepository.getAll();
      todosLosEventos.addAll(instalaciones.map(EventoCalendario.fromInstalacion));

      // Cargar eventos de alquileres
      final alquileres = await _vehiculoRepository.getAll();
      todosLosEventos.addAll(alquileres.map(EventoCalendario.fromAlquiler));

      _eventos = todosLosEventos;
      _organizarEventosPorFecha();
      notifyListeners();
    } catch (e) {
      setError('Error al cargar eventos: $e');
    } finally {
      setLoading(false);
    }
  }

  // Cargar eventos para un rango de fechas específico
  Future<void> cargarEventosPorRango({
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    try {
      setLoading(true);
      clearError();

      final List<EventoCalendario> eventosRango = [];

      // Cargar eventos de cámaras con filtro de fecha
      final camaras = await _camaraRepository.getAllByDateRange(
        startDate: fechaInicio,
        endDate: fechaFin,
      );
      eventosRango.addAll(camaras.map(EventoCalendario.fromCamara));

      // Cargar eventos de instalaciones con filtro de fecha
      final instalaciones = await _instalacionRepository.getAllByDateRange(
        startDate: fechaInicio,
        endDate: fechaFin,
      );
      eventosRango.addAll(instalaciones.map(EventoCalendario.fromInstalacion));

      // Cargar eventos de alquileres con filtro de fecha
      final alquileres = await _vehiculoRepository.getAllByTrabajoDateRange(
        startDate: fechaInicio,
        endDate: fechaFin,
      );
      eventosRango.addAll(alquileres.map(EventoCalendario.fromAlquiler));

      _eventos = eventosRango;
      _organizarEventosPorFecha();
      notifyListeners();
    } catch (e) {
      setError('Error al cargar eventos por rango: $e');
    } finally {
      setLoading(false);
    }
  }

  // Organizar eventos por fecha para el calendario
  void _organizarEventosPorFecha() {
    _eventosPorFecha.clear();
    for (final evento in _eventos) {
      final fecha = DateTime(evento.fecha.year, evento.fecha.month, evento.fecha.day);
      if (_eventosPorFecha[fecha] == null) {
        _eventosPorFecha[fecha] = [];
      }
      _eventosPorFecha[fecha]!.add(evento);
    }
  }

  // Seleccionar una fecha
  void seleccionarFecha(DateTime fecha) {
    _fechaSeleccionada = fecha;
    notifyListeners();
  }

  // Obtener eventos para una fecha específica
  List<EventoCalendario> obtenerEventosParaFecha(DateTime fecha) {
    final fechaNormalizada = DateTime(fecha.year, fecha.month, fecha.day);
    return _eventosPorFecha[fechaNormalizada] ?? [];
  }

  // Verificar si una fecha tiene eventos
  bool tieneEventos(DateTime fecha) {
    final fechaNormalizada = DateTime(fecha.year, fecha.month, fecha.day);
    return _eventosPorFecha[fechaNormalizada]?.isNotEmpty ?? false;
  }

  // Obtener el número de eventos para una fecha
  int contarEventos(DateTime fecha) {
    final fechaNormalizada = DateTime(fecha.year, fecha.month, fecha.day);
    return _eventosPorFecha[fechaNormalizada]?.length ?? 0;
  }

  // Filtrar eventos por tipo
  List<EventoCalendario> filtrarEventosPorTipo(TipoServicio tipo) {
    return _eventos.where((evento) => evento.tipo == tipo).toList();
  }

  // Filtrar eventos por estado
  List<EventoCalendario> filtrarEventosPorEstado(String estado) {
    return _eventos.where((evento) => evento.estado.toLowerCase() == estado.toLowerCase()).toList();
  }

  // Obtener eventos próximos (siguientes 7 días)
  List<EventoCalendario> get eventosProximos {
    final ahora = DateTime.now();
    final fechaLimite = ahora.add(const Duration(days: 7));

    return _eventos.where((evento) {
      return evento.fecha.isAfter(ahora) && evento.fecha.isBefore(fechaLimite);
    }).toList()..sort((a, b) => a.fecha.compareTo(b.fecha));
  }

  // Obtener eventos de hoy
  List<EventoCalendario> get eventosHoy {
    final hoy = DateTime.now();
    final fechaHoy = DateTime(hoy.year, hoy.month, hoy.day);
    return _eventosPorFecha[fechaHoy] ?? [];
  }
}

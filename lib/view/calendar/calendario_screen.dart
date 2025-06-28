import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/events/evento_calendario.dart';
import 'package:client_service/viewmodel/calendario_viewmodel.dart';
import 'package:client_service/services/service_locator.dart';
import 'package:intl/intl.dart';

class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({super.key});

  @override
  State<CalendarioScreen> createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  late final CalendarioViewModel _viewModel;
  late final ValueNotifier<List<EventoCalendario>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<CalendarioViewModel>();
    _selectedDay = DateTime.now();
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _cargarEventos();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<void> _cargarEventos() async {
    await _viewModel.cargarEventos();
    if (mounted) {
      setState(() {
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
      });
    }
  }

  List<EventoCalendario> _getEventsForDay(DateTime day) {
    return _viewModel.obtenerEventosParaFecha(day);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
      _viewModel.seleccionarFecha(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Calendario de Servicios',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _cargarEventos,
          ),
          IconButton(
            icon: const Icon(Icons.today, color: Colors.white),
            onPressed: () {
              final hoy = DateTime.now();
              _onDaySelected(hoy, hoy);
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, child) {
          if (_viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              ),
            );
          }

          if (_viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar eventos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _viewModel.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _cargarEventos,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              _buildCalendar(),
              const Divider(height: 1),
              Expanded(
                child: _buildEventsList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TableCalendar<EventoCalendario>(
        locale: 'es_ES',
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        eventLoader: _getEventsForDay,
        startingDayOfWeek: StartingDayOfWeek.monday,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: _onDaySelected,
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: TextStyle(color: Colors.red[600]),
          holidayTextStyle: TextStyle(color: Colors.red[600]),
          selectedDecoration: const BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
          markersMaxCount: 3,
          markerDecoration: const BoxDecoration(
            color: AppColors.accentColor,
            shape: BoxShape.circle,
          ),
          markersAlignment: Alignment.bottomCenter,
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonShowsNext: false,
          formatButtonDecoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          formatButtonTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isNotEmpty) {
              return _buildEventMarkers(events.cast<EventoCalendario>());
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildEventMarkers(List<EventoCalendario> events) {
    final tiposUnicos = events.map((e) => e.tipo).toSet().toList();

    return Positioned(
      bottom: 1,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: tiposUnicos.take(3).map((tipo) {
          Color color;
          switch (tipo) {
            case TipoServicio.camara:
              color = Colors.green;
              break;
            case TipoServicio.instalacion:
              color = Colors.blue;
              break;
            case TipoServicio.alquiler:
              color = Colors.orange;
              break;
          }
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEventsList() {
    return ValueListenableBuilder<List<EventoCalendario>>(
      valueListenable: _selectedEvents,
      builder: (context, value, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.event,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Servicios para ${DateFormat('EEEE, d MMMM', 'es_ES').format(_selectedDay!)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${value.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: value.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return _buildEventCard(value[index]);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay servicios programados',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'para este día',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(EventoCalendario evento) {
    Color tipoColor;
    IconData tipoIcon;

    switch (evento.tipo) {
      case TipoServicio.camara:
        tipoColor = Colors.green;
        tipoIcon = Icons.videocam;
        break;
      case TipoServicio.instalacion:
        tipoColor = Colors.blue;
        tipoIcon = Icons.construction;
        break;
      case TipoServicio.alquiler:
        tipoColor = Colors.orange;
        tipoIcon = Icons.directions_car;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: tipoColor, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: tipoColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      tipoIcon,
                      color: tipoColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          evento.titulo,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          evento.tipo.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            color: tipoColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildEstadoBadge(evento.estado),
                ],
              ),
              const SizedBox(height: 12),
              if (evento.descripcion.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(Icons.description, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        evento.descripcion,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    evento.horaFin != null
                        ? '${evento.horaInicio} - ${evento.horaFin}'
                        : evento.horaInicio,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (evento.direccion != null) ...[
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        evento.direccion!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              if (evento.tecnico != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Técnico: ${evento.tecnico}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEstadoBadge(String estado) {
    Color backgroundColor;
    Color textColor = Colors.white;

    switch (estado.toLowerCase()) {
      case 'pendiente':
        backgroundColor = Colors.orange;
        break;
      case 'en proceso':
      case 'enproceso':
        backgroundColor = Colors.blue;
        break;
      case 'completado':
        backgroundColor = Colors.green;
        break;
      case 'cancelado':
        backgroundColor = Colors.red;
        break;
      default:
        backgroundColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        estado,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

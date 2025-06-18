import 'package:flutter/material.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/constants/notificacion_sistema.dart';
import 'package:client_service/services/notificacion_service.dart';
import 'package:client_service/services/service_locator.dart';

class NotificacionesScreen extends StatefulWidget {
  const NotificacionesScreen({super.key});

  @override
  State<NotificacionesScreen> createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  late final NotificacionService _notificacionService;

  @override
  void initState() {
    super.initState();
    _notificacionService = sl<NotificacionService>();
    _notificacionService.addListener(_onNotificacionesChanged);
    // Comentado temporalmente para debugging
    // _agregarNotificacionesPrueba();
  }

  @override
  void dispose() {
    _notificacionService.removeListener(_onNotificacionesChanged);
    super.dispose();
  }

  void _onNotificacionesChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _agregarNotificacionesPrueba() async {
    // Solo agregar si no hay notificaciones
    if (_notificacionService.notificaciones.isEmpty) {
      await _notificacionService.agregarNotificacion(
        titulo: 'Bienvenido al sistema',
        mensaje:
            'Sistema de gestión de servicios técnicos iniciado correctamente.',
        tipo: TipoNotificacion.sistema,
        prioridad: PrioridadNotificacion.media,
        mostrarFlash: false,
      );

      await _notificacionService.agregarNotificacion(
        titulo: 'Mantenimiento programado',
        mensaje:
            'Recordatorio: mantenimiento de cámaras programado para mañana a las 9:00 AM.',
        tipo: TipoNotificacion.recordatorio,
        prioridad: PrioridadNotificacion.alta,
        mostrarFlash: false,
      );

      await _notificacionService.agregarNotificacion(
        titulo: 'Nuevo servicio registrado',
        mensaje:
            'Se ha registrado un nuevo servicio de instalación de postes para el cliente ACME Corp.',
        tipo: TipoNotificacion.servicio,
        prioridad: PrioridadNotificacion.media,
        mostrarFlash: false,
      );

      await _notificacionService.agregarNotificacion(
        titulo: 'Factura generada',
        mensaje:
            'Nueva factura #001-2025 por \$2,500.00 ha sido creada exitosamente.',
        tipo: TipoNotificacion.facturacion,
        prioridad: PrioridadNotificacion.media,
        mostrarFlash: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificaciones = _notificacionService.notificaciones;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Notificaciones',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read, color: Colors.white),
            onPressed: _marcarTodasComoLeidas,
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            onPressed: _mostrarDialogoLimpiar,
          ),
        ],
      ),
      body: notificaciones.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notificaciones.length,
              itemBuilder: (context, index) {
                return _buildNotificationCard(notificaciones[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No hay notificaciones',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Las notificaciones aparecerán aquí',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificacionSistema notificacion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notificacion.leida ? Colors.grey[50] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notificacion.leida
              ? Colors.grey[300]!
              : AppColors.primaryColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _marcarComoLeida(notificacion),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatar(notificacion),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              notificacion.titulo,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: notificacion.leida
                                    ? FontWeight.w500
                                    : FontWeight.bold,
                                color: notificacion.leida
                                    ? Colors.grey[700]
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              _buildPriorityIcon(notificacion.prioridad),
                              const SizedBox(width: 8),
                              Text(
                                _formatearTiempo(notificacion.fechaCreacion),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notificacion.tipo.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getTipoColor(notificacion.tipo),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notificacion.mensaje,
                        style: TextStyle(
                          fontSize: 14,
                          color: notificacion.leida
                              ? Colors.grey[600]
                              : Colors.grey[800],
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (!notificacion.leida) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Nueva',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'marcar':
                        _marcarComoLeida(notificacion);
                        break;
                      case 'eliminar':
                        _eliminarNotificacion(notificacion);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'marcar',
                      child: Row(
                        children: [
                          Icon(
                            notificacion.leida
                                ? Icons.mark_email_unread
                                : Icons.mark_email_read,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(notificacion.leida
                              ? 'Marcar como no leída'
                              : 'Marcar como leída'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'eliminar',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Eliminar', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(NotificacionSistema notificacion) {
    Color backgroundColor;
    IconData icon;

    switch (notificacion.tipo) {
      case TipoNotificacion.servicio:
        backgroundColor = AppColors.primaryColor;
        icon = Icons.engineering;
        break;
      case TipoNotificacion.sistema:
        backgroundColor = Colors.orange;
        icon = Icons.settings;
        break;
      case TipoNotificacion.mantenimiento:
        backgroundColor = Colors.blue;
        icon = Icons.build;
        break;
      case TipoNotificacion.facturacion:
        backgroundColor = Colors.green;
        icon = Icons.receipt;
        break;
      case TipoNotificacion.recordatorio:
        backgroundColor = Colors.purple;
        icon = Icons.access_time;
        break;
      case TipoNotificacion.error:
        backgroundColor = Colors.red;
        icon = Icons.error;
        break;
      case TipoNotificacion.exito:
        backgroundColor = Colors.teal;
        icon = Icons.check_circle;
        break;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: backgroundColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        color: backgroundColor,
        size: 24,
      ),
    );
  }

  Widget _buildPriorityIcon(PrioridadNotificacion prioridad) {
    Color color;
    IconData icon;

    switch (prioridad) {
      case PrioridadNotificacion.baja:
        color = Colors.green;
        icon = Icons.keyboard_arrow_down;
        break;
      case PrioridadNotificacion.media:
        color = Colors.orange;
        icon = Icons.remove;
        break;
      case PrioridadNotificacion.alta:
        color = Colors.red;
        icon = Icons.keyboard_arrow_up;
        break;
      case PrioridadNotificacion.critica:
        color = Colors.purple;
        icon = Icons.priority_high;
        break;
    }

    return Icon(
      icon,
      size: 16,
      color: color,
    );
  }

  Color _getTipoColor(TipoNotificacion tipo) {
    switch (tipo) {
      case TipoNotificacion.servicio:
        return AppColors.primaryColor;
      case TipoNotificacion.sistema:
        return Colors.orange;
      case TipoNotificacion.mantenimiento:
        return Colors.blue;
      case TipoNotificacion.facturacion:
        return Colors.green;
      case TipoNotificacion.recordatorio:
        return Colors.purple;
      case TipoNotificacion.error:
        return Colors.red;
      case TipoNotificacion.exito:
        return Colors.teal;
    }
  }

  String _formatearTiempo(DateTime fecha) {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fecha);

    if (diferencia.inMinutes < 60) {
      return '${diferencia.inMinutes}m';
    } else if (diferencia.inHours < 24) {
      return '${diferencia.inHours}h';
    } else if (diferencia.inDays < 7) {
      return '${diferencia.inDays}d';
    } else {
      return '${fecha.day}/${fecha.month}';
    }
  }

  void _marcarComoLeida(NotificacionSistema notificacion) {
    _notificacionService.marcarComoLeida(notificacion.id);
  }

  void _eliminarNotificacion(NotificacionSistema notificacion) {
    _notificacionService.eliminarNotificacion(notificacion.id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notificación eliminada'),
      ),
    );
  }

  void _marcarTodasComoLeidas() {
    _notificacionService.marcarTodasComoLeidas();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todas las notificaciones marcadas como leídas'),
      ),
    );
  }

  void _mostrarDialogoLimpiar() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar notificaciones'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar todas las notificaciones leídas?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _limpiarNotificacionesLeidas();
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _limpiarNotificacionesLeidas() {
    final notificacionesLeidas =
        _notificacionService.notificaciones.where((n) => n.leida).length;

    _notificacionService.limpiarNotificacionesLeidas();

    if (notificacionesLeidas > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$notificacionesLeidas notificaciones eliminadas'),
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:client_service/utils/colors.dart';

class EstadoGestionWidget extends StatelessWidget {
  final String estado;
  final bool estaCancelado;
  final DateTime? fechaCancelacion;
  final String? motivoCancelacion;
  final VoidCallback? onCancelar;
  final VoidCallback? onRetomar;
  final VoidCallback? onCambiarEstado;

  const EstadoGestionWidget({
    super.key,
    required this.estado,
    required this.estaCancelado,
    this.fechaCancelacion,
    this.motivoCancelacion,
    this.onCancelar,
    this.onRetomar,
    this.onCambiarEstado,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: _getEstadoColor().withOpacity(0.1),
        border: Border.all(color: _getEstadoColor()),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getEstadoIcon(),
                color: _getEstadoColor(),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Estado: $estado',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ).copyWith(color: _getEstadoColor()),
              ),
            ],
          ),
          if (estaCancelado) ...[
            const SizedBox(height: 8),
            if (fechaCancelacion != null)
              Text(
                'Cancelado el: ${_formatDate(fechaCancelacion!)}',
                style: TextStyle(fontSize: 12, color: Colors.red[700]),
              ),
            if (motivoCancelacion != null && motivoCancelacion!.isNotEmpty)
              Text(
                'Motivo: $motivoCancelacion',
                style: TextStyle(fontSize: 12, color: Colors.red[700]),
              ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (!estaCancelado && onCancelar != null)
                Expanded(
                  child: CustomButton(
                    text: 'Cancelar Servicio',
                    onPressed: onCancelar!,
                    color: Colors.red,
                    icon: Icons.cancel,
                  ),
                ),
              if (estaCancelado && onRetomar != null) ...[
                Expanded(
                  child: CustomButton(
                    text: 'Retomar Servicio',
                    onPressed: onRetomar!,
                    color: Colors.green,
                    icon: Icons.play_arrow,
                  ),
                ),
              ],
              if (!estaCancelado && onCambiarEstado != null) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    text: 'Cambiar Estado',
                    onPressed: onCambiarEstado!,
                    color: AppColors.primaryColor,
                    icon: Icons.edit,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _getEstadoColor() {
    switch (estado.toLowerCase()) {
      case 'pendiente':
        return Colors.orange;
      case 'en proceso':
      case 'enproceso':
        return Colors.blue;
      case 'completado':
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getEstadoIcon() {
    switch (estado.toLowerCase()) {
      case 'pendiente':
        return Icons.pending;
      case 'en proceso':
      case 'enproceso':
        return Icons.hourglass_empty;
      case 'completado':
        return Icons.check_circle;
      case 'cancelado':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 18) : Container(),
      label: Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}

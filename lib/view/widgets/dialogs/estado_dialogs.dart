import 'package:flutter/material.dart';
import 'package:client_service/utils/colors.dart';

class CancelarServicioDialog extends StatefulWidget {
  final String tipoServicio;
  final Function(String motivo) onConfirmar;

  const CancelarServicioDialog({
    super.key,
    required this.tipoServicio,
    required this.onConfirmar,
  });

  @override
  State<CancelarServicioDialog> createState() => _CancelarServicioDialogState();
}

class _CancelarServicioDialogState extends State<CancelarServicioDialog> {
  final TextEditingController _motivoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _motivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cancelar ${widget.tipoServicio}'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '¿Está seguro de que desea cancelar este ${widget.tipoServicio.toLowerCase()}?',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _motivoController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Motivo de cancelación *',
                hintText: 'Ingrese el motivo de la cancelación',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El motivo es obligatorio';
                }
                if (value.trim().length < 5) {
                  return 'El motivo debe tener al menos 5 caracteres';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onConfirmar(_motivoController.text.trim());
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Confirmar Cancelación'),
        ),
      ],
    );
  }
}

class CambiarEstadoDialog extends StatefulWidget {
  final String estadoActual;
  final List<String> estadosDisponibles;
  final Function(String nuevoEstado) onConfirmar;

  const CambiarEstadoDialog({
    super.key,
    required this.estadoActual,
    required this.estadosDisponibles,
    required this.onConfirmar,
  });

  @override
  State<CambiarEstadoDialog> createState() => _CambiarEstadoDialogState();
}

class _CambiarEstadoDialogState extends State<CambiarEstadoDialog> {
  String? _selectedEstado;

  @override
  void initState() {
    super.initState();
    _selectedEstado = widget.estadoActual;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cambiar Estado'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Estado actual: ${widget.estadoActual}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text('Seleccione el nuevo estado:'),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedEstado,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nuevo Estado',
            ),
            items: widget.estadosDisponibles.map((estado) {
              return DropdownMenuItem<String>(
                value: estado,
                child: Row(
                  children: [
                    Icon(
                      _getEstadoIcon(estado),
                      color: _getEstadoColor(estado),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(estado),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedEstado = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed:
              _selectedEstado != null && _selectedEstado != widget.estadoActual
                  ? () {
                      widget.onConfirmar(_selectedEstado!);
                      Navigator.of(context).pop();
                    }
                  : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Cambiar Estado'),
        ),
      ],
    );
  }

  Color _getEstadoColor(String estado) {
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

  IconData _getEstadoIcon(String estado) {
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
}

class RetomarServicioDialog extends StatelessWidget {
  final String tipoServicio;
  final VoidCallback onConfirmar;

  const RetomarServicioDialog({
    super.key,
    required this.tipoServicio,
    required this.onConfirmar,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Retomar $tipoServicio'),
      content: Text(
        '¿Está seguro de que desea retomar este ${tipoServicio.toLowerCase()}? '
        'Esto cambiará el estado a "Pendiente" y eliminará la información de cancelación.',
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirmar();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text('Retomar Servicio'),
        ),
      ],
    );
  }
}

import 'package:client_service/models/factura.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewFactura extends StatelessWidget {
  final Factura factura;

  const ViewFactura({super.key, required this.factura});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('Factura ${factura.numeroFactura}'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implementar compartir/imprimir
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Función de impresión/compartir en desarrollo')),
              );
            },
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () {
              // TODO: Implementar generación PDF
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Generación de PDF en desarrollo')),
              );
            },
            icon: const Icon(Icons.print),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Encabezado de la factura
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'FACTURA',
                        style: AppFonts.bodyNormal.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getEstadoColor(factura.estado),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getEstadoText(factura.estado),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Número: ${factura.numeroFactura}',
                    style: AppFonts.bodyNormal.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fecha de Emisión: ${DateFormat('dd/MM/yyyy').format(factura.fechaEmision)}',
                    style: AppFonts.bodyNormal,
                  ),
                  Text(
                    'Fecha de Vencimiento: ${DateFormat('dd/MM/yyyy').format(factura.fechaVencimiento)}',
                    style: AppFonts.bodyNormal,
                  ),
                  Text(
                    'Tipo de Servicio: ${_getTipoServicioText(factura.tipoServicio)}',
                    style: AppFonts.bodyNormal,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Información del cliente
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'INFORMACIÓN DEL CLIENTE',
                    style: AppFonts.bodyNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildInfoRow('Nombre:', factura.nombreCliente),
                  _buildInfoRow('Dirección:', factura.direccionCliente),
                  _buildInfoRow('Teléfono:', factura.telefonoCliente),
                  _buildInfoRow('Correo:', factura.correoCliente),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Items de la factura
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DETALLE DE SERVICIOS',
                    style: AppFonts.bodyNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Encabezados de la tabla
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Descripción',
                            style: AppFonts.bodyNormal
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Cant.',
                            style: AppFonts.bodyNormal
                                .copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Precio',
                            style: AppFonts.bodyNormal
                                .copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Desc.',
                            style: AppFonts.bodyNormal
                                .copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Total',
                            style: AppFonts.bodyNormal
                                .copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Items
                  ...factura.items
                      .map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    item.descripcion,
                                    style: AppFonts.bodyNormal,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    item.cantidad.toString(),
                                    style: AppFonts.bodyNormal,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '\$${item.precioUnitario.toStringAsFixed(2)}',
                                    style: AppFonts.bodyNormal,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${item.descuento.toStringAsFixed(1)}%',
                                    style: AppFonts.bodyNormal,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '\$${item.total.toStringAsFixed(2)}',
                                    style: AppFonts.bodyNormal
                                        .copyWith(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      ,
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Totales
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 300,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        _buildTotalRow('Subtotal:', factura.subtotal),
                        _buildTotalRow('Descuentos:', -factura.totalDescuentos),
                        _buildTotalRow(
                            'Base Imponible:', factura.baseImponible),
                        _buildTotalRow(
                            'Impuesto (${factura.impuesto.toStringAsFixed(1)}%):',
                            factura.montoImpuesto),
                        const Divider(thickness: 2),
                        _buildTotalRow(
                          'TOTAL:',
                          factura.total,
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Observaciones
            if (factura.observaciones != null &&
                factura.observaciones!.isNotEmpty) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OBSERVACIONES',
                      style: AppFonts.bodyNormal.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      factura.observaciones!,
                      style: AppFonts.bodyNormal,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Información adicional
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'INFORMACIÓN ADICIONAL',
                    style: AppFonts.bodyNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow('Creado por:', factura.creadoPor),
                  _buildInfoRow(
                      'Fecha de creación:',
                      DateFormat('dd/MM/yyyy HH:mm')
                          .format(factura.fechaCreacion)),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppFonts.bodyNormal.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppFonts.bodyNormal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double valor, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppFonts.bodyNormal.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            '\$${valor.toStringAsFixed(2)}',
            style: AppFonts.bodyNormal.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? AppColors.primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }

  Color _getEstadoColor(EstadoFactura estado) {
    switch (estado) {
      case EstadoFactura.pendiente:
        return Colors.orange;
      case EstadoFactura.pagada:
        return Colors.green;
      case EstadoFactura.vencida:
        return Colors.red;
      case EstadoFactura.cancelada:
        return Colors.grey;
    }
  }

  String _getEstadoText(EstadoFactura estado) {
    switch (estado) {
      case EstadoFactura.pendiente:
        return 'PENDIENTE';
      case EstadoFactura.pagada:
        return 'PAGADA';
      case EstadoFactura.vencida:
        return 'VENCIDA';
      case EstadoFactura.cancelada:
        return 'CANCELADA';
    }
  }

  String _getTipoServicioText(TipoServicio tipo) {
    switch (tipo) {
      case TipoServicio.camara:
        return 'Cámara';
      case TipoServicio.instalacion:
        return 'Instalación';
      case TipoServicio.vehiculo:
        return 'Vehículo';
    }
  }
}

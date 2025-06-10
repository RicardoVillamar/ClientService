import 'package:client_service/models/vehiculo.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/view/widgets/shared/apptitle.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/view/widgets/shared/search_with_dual_filter.dart';
import 'package:client_service/view/widgets/shared/toolbar.dart';
import 'package:client_service/view/widgets/date_filter_modal.dart';
import 'package:client_service/viewmodel/vehiculo_viewmodel.dart';
import 'package:client_service/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportVehiculo extends StatefulWidget {
  const ReportVehiculo({super.key});

  @override
  State<ReportVehiculo> createState() => _ReportVehiculoState();
}

class _ReportVehiculoState extends State<ReportVehiculo> {
  final AlquilerViewModel viewModel = sl<AlquilerViewModel>();
  DateRangeFilter? _currentReservaFilter;
  DateRangeFilter? _currentTrabajoFilter;
  String _activeFilterType = 'none'; // 'none', 'reserva', 'trabajo'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
        ),
        child: Column(
          children: [
            const Apptitle(title: 'Reporte de vehiculos'),
            SearchWithDualFilter(
              reservaFilterText: _currentReservaFilter?.toString(),
              trabajoFilterText: _currentTrabajoFilter?.toString(),
              onReservaFilterPressed: () => _showFilterModal('reserva'),
              onTrabajoFilterPressed: () => _showFilterModal('trabajo'),
              onClearFilters: _clearFilters,
              hasActiveReservaFilter: _activeFilterType == 'reserva',
              hasActiveTrabajoFilter: _activeFilterType == 'trabajo',
            ),
            Expanded(
              child: FutureBuilder<List<Alquiler>>(
                future: _getFilteredAlquileres(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No hay clientes'));
                  } else {
                    final alquileres = snapshot.data!;
                    return ListView.builder(
                      itemCount: alquileres.length,
                      itemBuilder: (context, index) {
                        final alquiler = alquileres[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: const BoxDecoration(
                            color: AppColors.whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(alquiler.nombreComercial),
                                Text(DateFormat('yyyy-MM-dd')
                                    .format(alquiler.fechaReserva)),
                                Text(DateFormat('yyyy-MM-dd')
                                    .format(alquiler.fechaTrabajo)),
                                Text(alquiler.direccion),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(alquiler.telefono),
                                Text(
                                    '\$${alquiler.montoAlquiler.toStringAsFixed(2)}'),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              color: AppColors.whiteColor,
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) async {
                                if (value == 'editar') {
                                  print(
                                      'Editar cliente: ${alquiler.nombreComercial}');
                                } else if (value == 'eliminar') {
                                  await viewModel
                                      .eliminarAlquiler(alquiler.id!);
                                  setState(() {});
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'editar',
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Editar'),
                                      Icon(
                                        Icons.edit,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'eliminar',
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Eliminar'),
                                      Icon(
                                        Icons.delete,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: BtnFloating(
        onPressed: () {
          _exportWithCurrentFilter();
        },
        icon: Icons.download_rounded,
        text: 'Descargar',
      ),
      bottomNavigationBar: const Toolbar(),
    );
  }

  Future<void> _showFilterModal(String filterType) async {
    final currentFilter =
        filterType == 'reserva' ? _currentReservaFilter : _currentTrabajoFilter;

    final title =
        filterType == 'reserva' ? 'Filtrar Reserva' : 'Filtrar Trabajo';

    final result = await DateFilterModal.show(
      context: context,
      initialFilter: currentFilter,
      title: title,
    );

    if (result != null) {
      setState(() {
        if (filterType == 'reserva') {
          _currentReservaFilter = result;
          _currentTrabajoFilter = null;
          _activeFilterType = result.hasFilter ? 'reserva' : 'none';
        } else {
          _currentTrabajoFilter = result;
          _currentReservaFilter = null;
          _activeFilterType = result.hasFilter ? 'trabajo' : 'none';
        }
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _currentReservaFilter = null;
      _currentTrabajoFilter = null;
      _activeFilterType = 'none';
    });
  }

  Future<List<Alquiler>> _getFilteredAlquileres() async {
    if (_activeFilterType == 'reserva' &&
        _currentReservaFilter?.hasFilter == true) {
      return viewModel.obtenerAlquileresFiltradosPorReserva(
        startDate: _currentReservaFilter!.startDate,
        endDate: _currentReservaFilter!.endDate,
      );
    } else if (_activeFilterType == 'trabajo' &&
        _currentTrabajoFilter?.hasFilter == true) {
      return viewModel.obtenerAlquileresFiltradosPorTrabajo(
        startDate: _currentTrabajoFilter!.startDate,
        endDate: _currentTrabajoFilter!.endDate,
      );
    } else {
      return viewModel.obtenerAlquileres();
    }
  }

  Future<void> _exportWithCurrentFilter() async {
    if (_activeFilterType == 'reserva' &&
        _currentReservaFilter?.hasFilter == true) {
      await viewModel.exportarAlquileresFiltradosPorReserva(
        startDate: _currentReservaFilter!.startDate,
        endDate: _currentReservaFilter!.endDate,
      );
    } else if (_activeFilterType == 'trabajo' &&
        _currentTrabajoFilter?.hasFilter == true) {
      await viewModel.exportarAlquileresFiltradosPorTrabajo(
        startDate: _currentTrabajoFilter!.startDate,
        endDate: _currentTrabajoFilter!.endDate,
      );
    } else {
      await viewModel.exportAlquileres();
    }
  }
}

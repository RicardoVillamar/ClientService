import 'package:client_service/models/vehiculo.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/view/widgets/shared/apptitle.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/view/widgets/shared/search.dart';
import 'package:client_service/view/widgets/shared/toolbar.dart';
import 'package:client_service/viewmodel/vehiculo_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportVehiculo extends StatefulWidget {
  const ReportVehiculo({super.key});

  @override
  State<ReportVehiculo> createState() => _ReportVehiculoState();
}

class _ReportVehiculoState extends State<ReportVehiculo> {
  AlquilerViewModel viewModel = AlquilerViewModel();
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
            const SearchBarPage(),
            Expanded(
              child: FutureBuilder<List<Alquiler>>(
                future: viewModel.obtenerAlquileres(),
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
          onPressed: () {}, icon: Icons.download_rounded, text: 'Descargar'),
      bottomNavigationBar: const Toolbar(),
    );
  }
}

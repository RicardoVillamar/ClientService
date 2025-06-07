import 'package:client_service/models/empleado.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/view/widgets/shared/apptitle.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/view/widgets/shared/search.dart';
import 'package:client_service/view/widgets/shared/toolbar.dart';
import 'package:client_service/viewmodel/empleado_viewmodel.dart';
import 'package:flutter/material.dart';

class ReportEmpleado extends StatefulWidget {
  const ReportEmpleado({super.key});

  @override
  State<ReportEmpleado> createState() => _ReportEmpleadoState();
}

class _ReportEmpleadoState extends State<ReportEmpleado> {
  double heightScreen = 0;
  final EmpleadoViewmodel viewModel = EmpleadoViewmodel();

  @override
  Widget build(BuildContext context) {
    heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
        ),
        child: Column(
          children: [
            const Apptitle(title: 'Reporte de Empleado'),
            const SearchBarPage(),
            Expanded(
              child: FutureBuilder<List<Empleado>>(
                future: viewModel.obtenerEmpleados(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No hay empleados'));
                  } else {
                    final empleados = snapshot.data!;
                    return ListView.builder(
                      itemCount: empleados.length,
                      itemBuilder: (context, index) {
                        final empleado = empleados[index];
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
                            leading: CircleAvatar(
                              backgroundImage: empleado.fotoUrl.isNotEmpty
                                  ? NetworkImage(empleado.fotoUrl)
                                  : null,
                              backgroundColor: AppColors.primaryColor,
                              child: empleado.fotoUrl.isEmpty
                                  ? Text(
                                      empleado.nombre.isNotEmpty
                                          ? empleado.nombre[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        color: AppColors.whiteColor,
                                        fontSize: 20,
                                      ),
                                    )
                                  : null,
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${empleado.nombre} ${empleado.apellido}'),
                                Text(empleado.cedula),
                                Text(empleado.correo),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Telefono: ${empleado.telefono}'),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              color: AppColors.whiteColor,
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) async {
                                if (value == 'editar') {
                                  print('Editar empleado: ${empleado.nombre}');
                                } else if (value == 'eliminar') {
                                  await viewModel
                                      .eliminarEmpleado(empleado.id!);
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
            viewModel.exportEmpleados();
          },
          icon: Icons.download_rounded,
          text: 'Descargar',
          isVisible: viewModel.empleados.isNotEmpty),
      bottomNavigationBar: const Toolbar(),
    );
  }
}

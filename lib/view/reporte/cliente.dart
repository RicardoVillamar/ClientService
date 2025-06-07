import 'package:client_service/models/cliente.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/view/widgets/shared/apptitle.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/view/widgets/shared/search.dart';
import 'package:client_service/view/widgets/shared/toolbar.dart';
import 'package:client_service/viewmodel/cliente_viewmodel.dart';
import 'package:flutter/material.dart';

class ReportCliente extends StatefulWidget {
  const ReportCliente({super.key});

  @override
  State<ReportCliente> createState() => _ReportClienteState();
}

class _ReportClienteState extends State<ReportCliente> {
  final ClienteViewModel viewModel = ClienteViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
        ),
        child: Column(
          children: [
            const Apptitle(title: 'Reporte de Clientes'),
            const SearchBarPage(),
            Expanded(
              child: FutureBuilder<List<Cliente>>(
                future: viewModel.obtenerClientes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No hay clientes'));
                  } else {
                    final clientes = snapshot.data!;
                    return ListView.builder(
                      itemCount: clientes.length,
                      itemBuilder: (context, index) {
                        final cliente = clientes[index];
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
                              backgroundColor: AppColors.primaryColor,
                              child: Text(
                                cliente.nombreComercial.isNotEmpty
                                    ? cliente.nombreComercial[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cliente.nombreComercial),
                                Text(cliente.telefono),
                                Text(cliente.correo),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cliente.personaContacto),
                                Text(cliente.cedula),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              color: AppColors.whiteColor,
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) async {
                                if (value == 'editar') {
                                  print(
                                      'Editar cliente: ${cliente.nombreComercial}');
                                } else if (value == 'eliminar') {
                                  await viewModel.eliminarCliente(cliente.id!);
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
            viewModel.exportarClientes();
          },
          icon: Icons.download_rounded,
          text: 'Descargar'),
      bottomNavigationBar: const Toolbar(),
    );
  }
}

import 'package:client_service/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client_service/providers/empleado_provider.dart';
import 'package:client_service/view/calendar/calendario_screen.dart';

class Toolbar extends StatefulWidget {
  const Toolbar({super.key});

  @override
  State<Toolbar> createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        color: AppColors.primaryColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.home, size: 30),
            color: AppColors.whiteColor,
          ),
          IconButton(
            onPressed: () {
              final empleado =
                  Provider.of<EmpleadoProvider>(context, listen: false)
                      .empleado;
              if (empleado != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CalendarioScreen(empleado: empleado),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'No hay usuario autenticado para mostrar el calendario.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            icon: const Icon(Icons.calendar_month, size: 30),
            color: AppColors.secondaryColor,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person, size: 30),
            color: AppColors.secondaryColor,
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, 'configuracion'),
            icon: const Icon(Icons.settings, size: 30),
            color: AppColors.secondaryColor,
          ),
        ],
      ),
    );
  }
}

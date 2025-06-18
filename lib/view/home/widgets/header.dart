import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:client_service/services/notificacion_service.dart';
import 'package:client_service/services/service_locator.dart';
import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  double screenHeight = 0.0;
  final String nombre = 'Usuario';
  late final NotificacionService _notificacionService;

  @override
  void initState() {
    super.initState();
    _notificacionService = sl<NotificacionService>();
    _notificacionService.addListener(_onNotificacionesChanged);
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

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [Text('Hola! $nombre', style: AppFonts.titleBold)],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(50),
                  border:
                      Border.all(color: AppColors.blackColor.withOpacity(0.1)),
                ),
                child: Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      color: AppColors.blackColor,
                      iconSize: 25,
                      onPressed: () =>
                          Navigator.pushNamed(context, 'notificaciones'),
                    ),
                    if (_notificacionService.tieneNotificacionesNoLeidas)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${_notificacionService.contadorNoLeidas}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(50),
                  border:
                      Border.all(color: AppColors.blackColor.withOpacity(0.1)),
                ),
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  color: AppColors.blackColor,
                  iconSize: 25,
                  onPressed: () =>
                      Navigator.pushNamed(context, 'configuracion'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

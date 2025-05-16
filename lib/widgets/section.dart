import 'package:client_service/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionPage extends StatefulWidget {
  final String selectedCategory;
  const SectionPage({super.key, required this.selectedCategory});

  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              widget.selectedCategory,
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.selectedCategory == 'Registros') ...[
              blockSections('Nuevos Empleados', 'NuevosEmpleados.png'),
              blockSections('Nuevos Clientes', 'NuevosClientes.png'),
            ] else if (widget.selectedCategory == 'Facturación') ...[
              blockSections('Nuevas Facturas', 'NuevaFactura.png'),
              blockSections('Reporte de Facturas', 'ReporteFactura.png'),
              blockSections('Anular Factura', 'AnularFactura.png'),
            ] else if (widget.selectedCategory == 'Servicios') ...[
              blockSections(
                  'Registro de instalación', 'RegistroInstalacion.png'),
              blockSections('Manteniminto de cámaras', 'Camaras.png'),
              blockSections('Alquiler vehículos', 'AlquilerVehiculo.png'),
            ] else if (widget.selectedCategory == 'Reportes') ...[
              blockSections('Empleados', 'Empleados.png'),
              blockSections('Clientes', 'Clientes.png'),
              blockSections(
                  'Reporte de instalaciones', 'ReporteInstalacion.png'),
              blockSections('Manteniminto de cámaras', 'Camaras.png'),
              blockSections('Alquiler vehículos', 'AlquilerVehiculo.png'),
              const SizedBox(height: 20),
            ]
          ]),
    );
  }

  Widget blockSections(String texto, String img) {
    return GestureDetector(
      onTap: () {
        // Navegar a la página usando el mapa de rutas
        if (routes.containsKey(texto)) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: routes[texto]!),
          );
        } else {}
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withOpacity(0.1)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 4,
            )
          ],
        ),
        height: 86,
        margin: const EdgeInsets.only(top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/$img'),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                texto,
                style: GoogleFonts.nunito(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward_ios_sharp),
            ),
            const SizedBox(
              width: 15,
            )
          ],
        ),
      ),
    );
  }
}

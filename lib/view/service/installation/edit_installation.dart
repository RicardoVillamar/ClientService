import 'package:client_service/models/instalacion.dart';
import 'package:client_service/models/empleado.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/viewmodel/instalacion_viewmodel.dart';
import 'package:client_service/viewmodel/empleado_viewmodel.dart';
import 'package:client_service/services/service_locator.dart';
import 'package:client_service/view/widgets/flash_messages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditInstallation extends StatefulWidget {
  final Instalacion instalacion;

  const EditInstallation({super.key, required this.instalacion});

  @override
  State<EditInstallation> createState() => _EditInstallationState();
}

class _EditInstallationState extends State<EditInstallation> {
  final TextEditingController _cedula = TextEditingController();
  final TextEditingController _nombreComercial = TextEditingController();
  final TextEditingController _direccion = TextEditingController();
  final TextEditingController _item = TextEditingController();
  final TextEditingController _descripcion = TextEditingController();
  final TextEditingController _telefono = TextEditingController();
  final TextEditingController _numeroTarea = TextEditingController();
  final TextEditingController _fechaInstalacion = TextEditingController();

  String? selectHoraInicio;
  String? selectHoraFin;
  String? selectTipoTrabajo;
  String? selectCargoPuesto; // This will store the cedula

  List<String> horas = [
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00'
  ];

  List<String> tiposTrabajo = [
    'Instalación',
    'Mantenimiento',
    'Reparación',
    'Revisión',
  ];

  List<Empleado> empleados = [];

  final InstalacionViewModel _instalacionViewModel = sl<InstalacionViewModel>();
  final EmpleadoViewmodel _empleadoViewModel = sl<EmpleadoViewmodel>();

  @override
  void initState() {
    super.initState();
    _loadInstallationData();
    _loadEmpleados();
  }

  void _loadEmpleados() async {
    empleados = await _empleadoViewModel.obtenerEmpleados();
    setState(() {});
  }

  void _loadInstallationData() {
    _cedula.text = widget.instalacion.cedula;
    _nombreComercial.text = widget.instalacion.nombreComercial;
    _direccion.text = widget.instalacion.direccion;
    _item.text = widget.instalacion.item;
    _descripcion.text = widget.instalacion.descripcion;
    _telefono.text = widget.instalacion.telefono;
    _numeroTarea.text = widget.instalacion.numeroTarea;
    _fechaInstalacion.text =
        DateFormat('dd/MM/yyyy').format(widget.instalacion.fechaInstalacion);
    selectHoraInicio = widget.instalacion.horaInicio;
    selectHoraFin = widget.instalacion.horaFin;
    selectTipoTrabajo = widget.instalacion.tipoTrabajo;
    selectCargoPuesto = widget.instalacion.cargoPuesto;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.instalacion.fechaInstalacion,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        _fechaInstalacion.text = formattedDate;
      });
    }
  }

  void _updateInstallation() async {
    if (_cedula.text.isEmpty ||
        _nombreComercial.text.isEmpty ||
        _direccion.text.isEmpty ||
        _item.text.isEmpty ||
        _descripcion.text.isEmpty ||
        _telefono.text.isEmpty ||
        _numeroTarea.text.isEmpty ||
        _fechaInstalacion.text.isEmpty ||
        selectHoraInicio == null ||
        selectHoraFin == null ||
        selectTipoTrabajo == null ||
        selectCargoPuesto == null) {
      FlashMessages.showWarning(
        context: context,
        message: 'Por favor complete todos los campos',
      );
      return;
    }

    try {
      final updatedInstallation = Instalacion(
        id: widget.instalacion.id,
        cedula: _cedula.text.trim(),
        nombreComercial: _nombreComercial.text.trim(),
        direccion: _direccion.text.trim(),
        item: _item.text.trim(),
        descripcion: _descripcion.text.trim(),
        telefono: _telefono.text.trim(),
        numeroTarea: _numeroTarea.text.trim(),
        fechaInstalacion:
            DateFormat('dd/MM/yyyy').parse(_fechaInstalacion.text),
        horaInicio: selectHoraInicio!,
        horaFin: selectHoraFin!,
        tipoTrabajo: selectTipoTrabajo!,
        cargoPuesto: selectCargoPuesto!,
      );

      await _instalacionViewModel.actualizarInstalacion(updatedInstallation);

      FlashMessages.showSuccess(
        context: context,
        message: 'Instalación actualizada exitosamente',
      );

      Navigator.pop(context);
    } catch (e) {
      FlashMessages.showError(
        context: context,
        message: 'Error al actualizar la instalación: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Editar Instalación'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Editar Información de Instalación',
                    style: AppFonts.titleBold.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildForm(),
                  const SizedBox(height: 30),
                  BtnElevated(
                    text: 'Actualizar Instalación',
                    onPressed: _updateInstallation,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        _buildTextField('Cédula', _cedula, 'Ingrese la cédula'),
        const SizedBox(height: 15),
        _buildTextField('Nombre Comercial', _nombreComercial,
            'Ingrese el nombre comercial'),
        const SizedBox(height: 15),
        _buildTextField('Dirección', _direccion, 'Ingrese la dirección'),
        const SizedBox(height: 15),
        _buildTextField('Item', _item, 'Ingrese el item'),
        const SizedBox(height: 15),
        _buildTextField('Descripción', _descripcion, 'Ingrese la descripción'),
        const SizedBox(height: 15),
        _buildTextField('Teléfono', _telefono, 'Ingrese el teléfono'),
        const SizedBox(height: 15),
        _buildTextField(
            'Número de Tarea', _numeroTarea, 'Ingrese el número de tarea'),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer(
            child: _buildTextField('Fecha de Instalación', _fechaInstalacion,
                'Seleccione la fecha'),
          ),
        ),
        const SizedBox(height: 15),
        // Dropdown for Cargo/Puesto (employee cedula)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cargo/Puesto',
              style: AppFonts.bodyNormal.copyWith(
                color: AppColors.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                border: Border.all(color: AppColors.greyColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectCargoPuesto,
                hint: Text('Cargo o Puesto', style: AppFonts.inputtext),
                onChanged: (String? newValue) {
                  setState(() {
                    selectCargoPuesto = newValue;
                  });
                },
                items: empleados.map((Empleado empleado) {
                  return DropdownMenuItem<String>(
                    value: empleado.cedula,
                    child: Text(empleado.nombreCompletoConCargo),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.bodyNormal.copyWith(
            color: AppColors.textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: AppColors.greyColor.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: AppColors.greyColor.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
        ),
      ],
    );
  }
}

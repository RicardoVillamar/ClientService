import 'package:client_service/models/camara.dart';
import 'package:client_service/models/empleado.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/view/widgets/shared/estado_gestion_widget.dart';
import 'package:client_service/view/widgets/dialogs/estado_dialogs.dart';
import 'package:client_service/viewmodel/camara_viewmodel.dart';
import 'package:client_service/viewmodel/empleado_viewmodel.dart';
import 'package:client_service/services/service_locator.dart';
import 'package:client_service/view/widgets/flash_messages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditCamara extends StatefulWidget {
  final Camara camara;

  const EditCamara({super.key, required this.camara});

  @override
  State<EditCamara> createState() => _EditCamaraState();
}

class _EditCamaraState extends State<EditCamara> {
  final TextEditingController _nombreC = TextEditingController();
  final TextEditingController _direccion = TextEditingController();
  final TextEditingController _observaciones = TextEditingController();
  final TextEditingController _costo = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? selectTecnico;
  List<Empleado> tecnicos = [];

  String? selectTipo;
  List<String> tipo = [
    'Tipo 1',
    'Tipo 2',
    'Tipo 3',
    'Tipo 4',
  ];

  final CamaraViewModel _camaraViewModel = sl<CamaraViewModel>();
  final EmpleadoViewmodel _empleadoViewModel = sl<EmpleadoViewmodel>();

  @override
  void initState() {
    super.initState();
    _loadCamaraData();
    _loadEmpleados();
  }

  void _loadEmpleados() async {
    tecnicos = await _empleadoViewModel.obtenerEmpleados();
    setState(() {});
  }

  void _loadCamaraData() {
    _nombreC.text = widget.camara.nombreComercial;
    _direccion.text = widget.camara.direccion;
    _observaciones.text = widget.camara.descripcion;
    _costo.text = widget.camara.costo.toString();
    _dateController.text =
        DateFormat('dd/MM/yyyy').format(widget.camara.fechaMantenimiento);
    selectTecnico = widget.camara.tecnico;
    selectTipo = widget.camara.tipo;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.camara.fechaMantenimiento,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        _dateController.text = formattedDate;
      });
    }
  }

  void _updateCamara() async {
    if (_nombreC.text.isEmpty ||
        _direccion.text.isEmpty ||
        _dateController.text.isEmpty ||
        _observaciones.text.isEmpty ||
        _costo.text.isEmpty ||
        selectTecnico == null ||
        selectTipo == null) {
      FlashMessages.showWarning(
        context: context,
        message: 'Por favor complete todos los campos',
      );
      return;
    }

    try {
      final updatedCamara = Camara(
        id: widget.camara.id,
        nombreComercial: _nombreC.text.trim(),
        direccion: _direccion.text.trim(),
        tecnico: selectTecnico!,
        tipo: selectTipo!,
        fechaMantenimiento:
            DateFormat('dd/MM/yyyy').parse(_dateController.text),
        descripcion: _observaciones.text.trim(),
        costo: double.tryParse(_costo.text.trim()) ?? 0,
        estado: widget.camara.estado,
        fechaCancelacion: widget.camara.fechaCancelacion,
        motivoCancelacion: widget.camara.motivoCancelacion,
      );

      await _camaraViewModel.actualizarCamara(updatedCamara);

      FlashMessages.showSuccess(
        context: context,
        message: 'Cámara actualizada exitosamente',
      );

      Navigator.pop(context);
    } catch (e) {
      FlashMessages.showError(
        context: context,
        message: 'Error al actualizar la cámara: $e',
      );
    }
  }

  void _cancelarMantenimiento() {
    showDialog(
      context: context,
      builder: (context) => CancelarServicioDialog(
        tipoServicio: 'Mantenimiento de Cámara',
        onConfirmar: (motivo) async {
          try {
            await _camaraViewModel.cancelarMantenimiento(
                widget.camara.id!, motivo);
            FlashMessages.showSuccess(
              context: context,
              message: 'Mantenimiento cancelado exitosamente',
            );
            Navigator.pop(context);
          } catch (e) {
            FlashMessages.showError(
              context: context,
              message: 'Error al cancelar: $e',
            );
          }
        },
      ),
    );
  }

  void _retomarMantenimiento() {
    showDialog(
      context: context,
      builder: (context) => RetomarServicioDialog(
        tipoServicio: 'Mantenimiento de Cámara',
        onConfirmar: () async {
          try {
            await _camaraViewModel.retomarMantenimiento(widget.camara.id!);
            FlashMessages.showSuccess(
              context: context,
              message: 'Mantenimiento retomado exitosamente',
            );
            Navigator.pop(context);
          } catch (e) {
            FlashMessages.showError(
              context: context,
              message: 'Error al retomar: $e',
            );
          }
        },
      ),
    );
  }

  void _cambiarEstado() {
    showDialog(
      context: context,
      builder: (context) => CambiarEstadoDialog(
        estadoActual: widget.camara.estado.displayName,
        estadosDisponibles: EstadoCamara.allDisplayNames,
        onConfirmar: (nuevoEstado) async {
          try {
            final estadoEnum = EstadoCamara.fromString(nuevoEstado);
            await _camaraViewModel.cambiarEstado(
                widget.camara.id!, estadoEnum.displayName);
            FlashMessages.showSuccess(
              context: context,
              message: 'Estado cambiado exitosamente',
            );
            Navigator.pop(context);
          } catch (e) {
            FlashMessages.showError(
              context: context,
              message: 'Error al cambiar estado: $e',
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Editar Cámara'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Widget de gestión de estado
            EstadoGestionWidget(
              estado: widget.camara.estado.displayName,
              estaCancelado: widget.camara.estaCancelado,
              fechaCancelacion: widget.camara.fechaCancelacion,
              motivoCancelacion: widget.camara.motivoCancelacion,
              onCancelar:
                  widget.camara.estaCancelado ? null : _cancelarMantenimiento,
              onRetomar:
                  widget.camara.estaCancelado ? _retomarMantenimiento : null,
              onCambiarEstado:
                  widget.camara.estaCancelado ? null : _cambiarEstado,
            ),
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
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Editar Información de Cámara',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildForm(),
                  const SizedBox(height: 30),
                  BtnElevated(
                    text: 'Actualizar Cámara',
                    onPressed: _updateCamara,
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
        _buildTextField(
            'Nombre Comercial', _nombreC, 'Ingrese el nombre comercial'),
        const SizedBox(height: 15),
        _buildTextField('Dirección', _direccion, 'Ingrese la dirección'),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer(
            child: _buildTextField('Fecha de Mantenimiento', _dateController,
                'Seleccione la fecha'),
          ),
        ),
        const SizedBox(height: 15),
        _buildEmployeeDropdown('Técnico', selectTecnico, tecnicos, (value) {
          setState(() {
            selectTecnico = value;
          });
        }),
        const SizedBox(height: 15),
        _buildDropdown('Tipo', selectTipo, tipo, (value) {
          setState(() {
            selectTipo = value;
          });
        }),
        const SizedBox(height: 15),
        _buildTextField(
            'Observaciones', _observaciones, 'Ingrese las observaciones'),
        const SizedBox(height: 15),
        _buildTextField('Costo', _costo, 'Ingrese el costo'),
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
          style: const TextStyle(fontSize: 14).copyWith(
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

  Widget _buildDropdown(String label, String? value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14).copyWith(
            color: AppColors.textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              hint: Text(
                'Seleccione $label',
                style: const TextStyle(fontSize: 12).copyWith(
                  color: AppColors.greyColor,
                ),
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 12).copyWith(
                      color: AppColors.textColor,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeDropdown(String label, String? value,
      List<Empleado> employees, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14).copyWith(
            color: AppColors.textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              hint: Text(
                'Seleccione $label',
                style: const TextStyle(fontSize: 12).copyWith(
                  color: AppColors.greyColor,
                ),
              ),
              items: employees.map((Empleado empleado) {
                return DropdownMenuItem<String>(
                  value: empleado.nombreCompleto,
                  child: Text(
                    empleado.nombreCompletoConCargo,
                    style: const TextStyle(fontSize: 12).copyWith(
                      color: AppColors.textColor,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

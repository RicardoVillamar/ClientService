import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/colors.dart';
import '../../utils/font.dart';

class DateRangeFilter {
  final DateTime? startDate;
  final DateTime? endDate;

  DateRangeFilter({this.startDate, this.endDate});

  bool get hasFilter => startDate != null || endDate != null;

  bool isDateInRange(DateTime date) {
    if (startDate != null && date.isBefore(startDate!)) return false;
    if (endDate != null && date.isAfter(endDate!)) return false;
    return true;
  }

  @override
  String toString() {
    if (startDate == null && endDate == null) return 'Sin filtro';
    final formatter = DateFormat('dd/MM/yyyy');
    if (startDate != null && endDate != null) {
      return '${formatter.format(startDate!)} - ${formatter.format(endDate!)}';
    } else if (startDate != null) {
      return 'Desde ${formatter.format(startDate!)}';
    } else {
      return 'Hasta ${formatter.format(endDate!)}';
    }
  }
}

class DateFilterModal extends StatefulWidget {
  final DateRangeFilter? initialFilter;
  final String title;

  const DateFilterModal({
    super.key,
    this.initialFilter,
    this.title = 'Filtrar',
  });

  @override
  State<DateFilterModal> createState() => _DateFilterModalState();

  static Future<DateRangeFilter?> show({
    required BuildContext context,
    DateRangeFilter? initialFilter,
    String title = 'Filtrar',
  }) {
    return showDialog<DateRangeFilter>(
      context: context,
      builder: (context) => DateFilterModal(
        initialFilter: initialFilter,
        title: title,
      ),
    );
  }
}

class _DateFilterModalState extends State<DateFilterModal> {
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialFilter?.startDate;
    _endDate = widget.initialFilter?.endDate;

    _startDateController = TextEditingController();
    _endDateController = TextEditingController();

    if (_startDate != null) {
      _startDateController.text = DateFormat('dd/MM/yyyy').format(_startDate!);
    }
    if (_endDate != null) {
      _endDateController.text = DateFormat('dd/MM/yyyy').format(_endDate!);
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _startDate = date;
        _startDateController.text = DateFormat('dd/MM/yyyy').format(date);
      });
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _endDate = date;
        _endDateController.text = DateFormat('dd/MM/yyyy').format(date);
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _startDateController.clear();
      _endDateController.clear();
    });
  }

  bool get _hasValidRange {
    if (_startDate == null || _endDate == null) return true;
    return _startDate!.isBefore(_endDate!) ||
        _startDate!.isAtSameMomentAs(_endDate!);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: screenWidth > 450 ? 400 : screenWidth * 0.9,
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: AppFonts.titleBold.copyWith(
                      color: AppColors.primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  color: AppColors.blackColor,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Subtitle
            Text(
              'Rango de fecha',
              style: AppFonts.subtitleBold.copyWith(
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 16),

            // Start Date Field
            _buildDateField(
              label: 'Fecha desde',
              controller: _startDateController,
              onTap: _selectStartDate,
            ),
            const SizedBox(height: 16),

            // End Date Field
            _buildDateField(
              label: 'Fecha hasta',
              controller: _endDateController,
              onTap: _selectEndDate,
            ),

            // Error message for invalid range
            if (!_hasValidRange) ...[
              const SizedBox(height: 8),
              Text(
                'La fecha de inicio debe ser anterior o igual a la fecha final',
                style: AppFonts.text.copyWith(color: AppColors.colorError),
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ],

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Clear Button
                Flexible(
                  child: TextButton(
                    onPressed: _clearFilters,
                    child: Text(
                      'Limpiar',
                      style: AppFonts.buttonNormal.copyWith(
                        color: AppColors.blackColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Cancel Button
                Flexible(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancelar',
                      style: AppFonts.buttonNormal.copyWith(
                        color: AppColors.blackColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Apply Button
                Flexible(
                  child: ElevatedButton(
                    onPressed: _hasValidRange
                        ? () {
                            final filter = DateRangeFilter(
                              startDate: _startDate,
                              endDate: _endDate,
                            );
                            Navigator.of(context).pop(filter);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.whiteColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Aplicar',
                      style: AppFonts.buttonBold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.bodyNormal.copyWith(
            color: AppColors.blackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: 'dd/mm/aaaa',
            suffixIcon: const Icon(Icons.calendar_today, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.greyColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.greyColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: AppColors.primaryColor, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}

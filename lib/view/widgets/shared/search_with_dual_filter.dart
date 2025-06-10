import 'package:flutter/material.dart';
import '../../../utils/colors.dart';

class SearchWithDualFilter extends StatelessWidget {
  final String? reservaFilterText;
  final String? trabajoFilterText;
  final VoidCallback? onReservaFilterPressed;
  final VoidCallback? onTrabajoFilterPressed;
  final VoidCallback? onClearFilters;
  final bool hasActiveReservaFilter;
  final bool hasActiveTrabajoFilter;

  const SearchWithDualFilter({
    super.key,
    this.reservaFilterText,
    this.trabajoFilterText,
    this.onReservaFilterPressed,
    this.onTrabajoFilterPressed,
    this.onClearFilters,
    this.hasActiveReservaFilter = false,
    this.hasActiveTrabajoFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasAnyActiveFilter = hasActiveReservaFilter || hasActiveTrabajoFilter;

    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Search field with filter buttons
          Row(
            children: [
              // Search Field
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.whiteColor,
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      labelText: 'Buscar',
                      labelStyle: TextStyle(
                        color: AppColors.primaryColor,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.primaryColor,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          width: 0.1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          width: 0.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Reserva Filter Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: hasActiveReservaFilter
                      ? AppColors.primaryColor
                      : AppColors.whiteColor,
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 1,
                  ),
                ),
                child: IconButton(
                  onPressed: onReservaFilterPressed,
                  icon: Icon(
                    Icons.event_available,
                    color: hasActiveReservaFilter
                        ? AppColors.whiteColor
                        : AppColors.primaryColor,
                  ),
                  tooltip: 'Filtrar por fecha de reserva',
                ),
              ),

              const SizedBox(width: 8),

              // Trabajo Filter Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: hasActiveTrabajoFilter
                      ? AppColors.primaryColor
                      : AppColors.whiteColor,
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 1,
                  ),
                ),
                child: IconButton(
                  onPressed: onTrabajoFilterPressed,
                  icon: Icon(
                    Icons.work,
                    color: hasActiveTrabajoFilter
                        ? AppColors.whiteColor
                        : AppColors.primaryColor,
                  ),
                  tooltip: 'Filtrar por fecha de trabajo',
                ),
              ),

              // Clear Filter Button (only show when filter is active)
              if (hasAnyActiveFilter) ...[
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.colorError,
                  ),
                  child: IconButton(
                    onPressed: onClearFilters,
                    icon: const Icon(
                      Icons.clear,
                      color: AppColors.whiteColor,
                    ),
                    tooltip: 'Limpiar filtros',
                  ),
                ),
              ],
            ],
          ),

          // Active filter indicator
          if (hasAnyActiveFilter) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryColor),
              ),
              child: Row(
                children: [
                  Icon(
                    hasActiveReservaFilter ? Icons.event_available : Icons.work,
                    size: 16,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hasActiveReservaFilter
                          ? 'Filtro Reserva: ${reservaFilterText ?? "Sin filtro"}'
                          : 'Filtro Trabajo: ${trabajoFilterText ?? "Sin filtro"}',
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

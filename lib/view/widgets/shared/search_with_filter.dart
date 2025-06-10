import 'package:flutter/material.dart';
import '../../../utils/colors.dart';

class SearchWithFilter extends StatelessWidget {
  final String? filterText;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onClearFilter;
  final bool hasActiveFilter;

  const SearchWithFilter({
    super.key,
    this.filterText,
    this.onFilterPressed,
    this.onClearFilter,
    this.hasActiveFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
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

          // Filter Button
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: hasActiveFilter
                  ? AppColors.primaryColor
                  : AppColors.whiteColor,
              border: Border.all(
                color: AppColors.primaryColor,
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: onFilterPressed,
              icon: Icon(
                Icons.filter_list,
                color: hasActiveFilter
                    ? AppColors.whiteColor
                    : AppColors.primaryColor,
              ),
              tooltip: filterText ?? 'Filtrar',
            ),
          ),

          // Clear Filter Button (only show when filter is active)
          if (hasActiveFilter) ...[
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.colorError,
              ),
              child: IconButton(
                onPressed: onClearFilter,
                icon: const Icon(
                  Icons.clear,
                  color: AppColors.whiteColor,
                ),
                tooltip: 'Limpiar filtro',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

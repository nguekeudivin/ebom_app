import 'package:ebom/src/config/app_colors.dart';
import 'package:flutter/material.dart';

class SearchTypesChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SearchTypesChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.4),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.7),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

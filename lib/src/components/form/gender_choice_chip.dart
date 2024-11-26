import 'package:ebom/src/config/app_colors.dart';
import 'package:flutter/material.dart';

class GenderChoiceChip extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Size fixedSize;
  final Color selectedColor;
  final Color borderColor;
  final Color selectedBorderColor;
  final Color textColor;
  final String selectedValue;
  final void Function(String) onSelected;

  const GenderChoiceChip({
    required this.text,
    required this.selectedValue,
    required this.onSelected,
    super.key,
    this.fontSize,
    this.fixedSize = const Size.fromHeight(45),
    this.selectedColor = AppColors.primaryLighter,
    this.borderColor = AppColors.gray700,
    this.selectedBorderColor = AppColors.primary,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: SizedBox(
        width: 100,
        child: Align(
          alignment: AlignmentDirectional.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
      selected: selectedValue == text,
      selectedColor: selectedColor,
      onSelected: (bool selected) {
        if (selected) {
          onSelected(text);
        }
      },
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: selectedValue == text ? selectedBorderColor : borderColor,
          width: 2.0,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      showCheckmark: false,
    );
  }
}

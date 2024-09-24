import 'package:flutter/material.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'button.dart';

class PrimaryButton extends Button {
  final String text;
  final Color color;

  const PrimaryButton({
    required this.text,
    required super.onPressed,
    this.color = Colors.white,
    super.fontSize,
    super.isLoading,
    super.disabled,
    super.fixedSize,
    super.backgroundColor = AppColors.primary,
    super.borderWidth = 0,
    super.borderColor = AppColors.primary,
    super.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  @override
  Widget buildContent(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}

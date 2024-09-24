import 'package:flutter/material.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'button.dart';

class ButtonWithIcon extends Button {
  final String text;
  final Widget icon;
  final double space;
  final Color color;

  const ButtonWithIcon({
    required this.text,
    required this.icon,
    required super.onPressed,
    this.space = 8,
    this.color = AppColors.primary,
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        SizedBox(width: space),
        Text(
          text,
          style: TextStyle(
            color: color,
          ),
        ),
      ],
    );
  }
}

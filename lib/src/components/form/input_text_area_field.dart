import 'package:flutter/material.dart';
import 'package:ebom/src/config/app_colors.dart';

class InputTextAreaField extends StatelessWidget {
  final String hintText;
  final bool obscureText;

  final Widget? prefixIcon;

  final Color color;
  final double borderWidth;
  final Color borderColor;
  final Color backgroundColor;
  final Color? focusBorderColor;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final TextEditingController controller;
  final dynamic maxLines;

  const InputTextAreaField({
    required this.hintText,
    required this.controller,
    required this.maxLines,
    super.key,
    this.obscureText = false,
    this.color = AppColors.gray700,
    this.backgroundColor = Colors.white,
    this.borderWidth = 2,
    this.borderColor = AppColors.borderGray,
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
    this.focusBorderColor = AppColors.primary,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          color: color,
          fontSize: 15,
        ),
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
          prefixIcon: prefixIcon,
          contentPadding: padding,
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: focusBorderColor ?? borderColor,
              width: borderWidth,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: borderColor,
              width: borderWidth,
            ),
          ),
        ),
      ),
    );
  }
}

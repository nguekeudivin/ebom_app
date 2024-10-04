import 'package:flutter/material.dart';
import 'package:ebom/src/config/app_colors.dart';

class SimpleButton extends StatelessWidget {
  final void Function(BuildContext) onPressed;
  final double? fontSize;
  final bool isLoading;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;
  final Widget child;

  const SimpleButton({
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.fontSize,
    this.backgroundColor = AppColors.primary,
    this.borderColor = AppColors.primary,
    this.borderWidth = 0,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  @protected
  Widget buildContent(BuildContext context) {
    return const Placeholder();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
      onPressed: () => onPressed(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: borderWidth != 0
              ? BorderSide(width: borderWidth, color: borderColor)
              : BorderSide.none,
        ),
        elevation: 0,
        enableFeedback: true,
        overlayColor: AppColors.primaryLight,
        splashFactory: InkRipple.splashFactory,
      ),
      child: Center(
        child: Visibility(
          visible: !isLoading,
          replacement: const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          child: child,
        ),
      ),
    ));
  }
}

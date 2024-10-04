import 'package:flutter/material.dart';
import 'package:ebom/src/resources/app_assets.dart';

class LogoSquare extends StatelessWidget {
  final double size;
  const LogoSquare({super.key, this.size = 128});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Center(
        child: Image.asset(
          AppAssets.logoSquare, // Pass assets using AppAssets
          //fit: BoxFit.contain,
        ),
      ),
    );
  }
}

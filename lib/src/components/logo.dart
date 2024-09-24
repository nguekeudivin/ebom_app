import 'package:flutter/material.dart';
import 'package:ebom/src/resources/app_assets.dart';

class Logo extends StatelessWidget {
  final double size;
  const Logo({super.key, this.size = 128});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        AppAssets.imageLogo, // Pass assets using AppAssets
        //fit: BoxFit.contain,
      ),
    );
  }
}

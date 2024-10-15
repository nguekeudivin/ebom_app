import 'package:ebom/src/resources/app_assets.dart';
import 'package:ebom/src/services/connexion_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAvatar extends StatelessWidget {
  final double width;
  final double height;
  const UserAvatar({this.width = 40, this.height = 40, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnexionProvider>(
      builder: (context, provider, child) {
        if (provider.connexion != null) {
          return Image.network(
            provider.connexion?.image as String,
            height: height,
            width: width,
            fit: BoxFit.cover,
          );
        } else {
          return Image.asset(
            AppAssets.logoSquare,
            height: height,
            width: width,
            fit: BoxFit.cover,
          );
        }
      },
    );
  }
}

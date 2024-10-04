import 'package:ebom/src/components/logo/logo_square.dart';
import 'package:ebom/src/resources/app_assets.dart';
import 'package:ebom/src/screens/account/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final double? paddingX;
  final Color? textColor;

  const HomeHeader({
    this.paddingX = 16,
    this.textColor = Colors.white,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(paddingX ?? 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              LogoSquare(),
            ],
          ),
          Row(
            children: [
              RichText(
                text: TextSpan(
                  text: 'Hello',
                  style:
                      TextStyle(fontSize: 18, color: textColor ?? Colors.black),
                  children: const [
                    TextSpan(
                      text: ' Suzy',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ), // Bold style
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                child: SizedBox.square(
                  dimension: 40,
                  child: Image.asset(
                    AppAssets.avatar,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

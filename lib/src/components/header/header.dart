import 'package:ebom/src/resources/app_assets.dart';
import 'package:ebom/src/screens/account/profile_screen.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final Color? color;
  const Header({required this.title, this.color = Colors.white, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
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
    );
  }
}

import 'package:ebom/src/components/logo_square.dart';
import 'package:ebom/src/resources/app_assets.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  const Header({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            SizedBox.square(
              dimension: 40,
              child: Image.asset(
                AppAssets.avatar,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Container(
              decoration: const BoxDecoration(
                color: Colors.blue, // Background color
                shape: BoxShape.circle, // Make the background circular
              ),
              child: IconButton(
                icon: const Icon(Icons.menu),
                color: Colors.white, // Icon color
                onPressed: () {
                  // Handle button press
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

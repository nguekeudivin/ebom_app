import 'package:ebom/src/config/app_colors.dart';
import 'package:flutter/material.dart';

class ProductLabel extends StatelessWidget {
  const ProductLabel({super.key});

  @override
  Widget build(BuildContext context) {
    String name = 'Notebook Gamer 2024';
    // Using string interpolation and truncating the name
    String displayName =
        (name.length > 20) ? '${name.substring(0, 20)}...' : name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.star,
              color: Colors.yellow,
              size: 16,
            ),
            Text('4.5'),
          ],
        ),
        Text(
          displayName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          '150.000 FCFA',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

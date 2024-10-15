import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/utils/helpers.dart';
import 'package:flutter/material.dart';

class ProductLabel extends StatelessWidget {
  final dynamic product;
  const ProductLabel({this.product, super.key});

  @override
  Widget build(BuildContext context) {
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
          truncate(product['nom'], 40),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${product['prix']} FCFA',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

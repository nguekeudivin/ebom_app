import 'package:ebom/src/components/products/product_categories_slide.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/categories_screen.dart';
import 'package:flutter/material.dart';

class CategoriesSwiper extends StatelessWidget {
  const CategoriesSwiper({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Toutes les categories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Pour tous les prix',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  //color: Colors.blue, // Background color
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                  ), // Make the background circular
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoriesScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        const ProductCategoriesSlide(),
      ],
    );
  }
}

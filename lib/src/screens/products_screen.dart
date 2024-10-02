import 'package:ebom/src/components/header/header.dart';
import 'package:ebom/src/components/input_search.dart';
import 'package:ebom/src/components/product_label.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/resources/app_assets.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Header(title: 'Products'),
          const InputSearch(),
          const SizedBox(
            height: 16,
          ),
          Flexible(
            // Use Flexible to avoid bottom overflow
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0, // Horizontal gap between grid items
              mainAxisSpacing: 8.0, // Vertical gap between grid items
              childAspectRatio: 0.75, // Adjust aspect ratio to control height
              children: List.generate(100, (index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderGray),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(
                              10,
                            ), // Set the desired radius for top-left corner
                            topRight: Radius.circular(
                              10,
                            ), // Set the desired radius for top-right corner
                          ),
                          child: Image.asset(
                            AppAssets.productExample,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: ProductLabel(),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

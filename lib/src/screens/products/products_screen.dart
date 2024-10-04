import 'package:ebom/src/components/header/big_header.dart';
import 'package:ebom/src/components/list/custom_list_row.dart';
import 'package:ebom/src/components/products/product_label.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/resources/app_assets.dart';
import 'package:ebom/src/screens/products/product_details_screen.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double widthReference = 400;

    double imageHeight =
        width < widthReference ? 120 : 120 + (width - widthReference) * 0.1;

    // Adjust child aspect ratio based on screen size

    return Column(
      children: [
        const BigHeader(
          title: 'Produits',
          searchPlaceholder: 'Iphone 15 Pro Max',
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              children: List.generate(15, (index) {
                return CustomListRow(
                  px: 16,
                  gap: 16,
                  children: List.generate(2, (colIndex) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductDetailsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderGray),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: imageHeight,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  AppAssets
                                      .productsImages[(index + colIndex) % 5],
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
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:ebom/src/components/list/custom_list_row.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/resources/app_assets.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:ebom/src/utils/helpers.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<bool> favorites = List<bool>.filled(10, Random().nextBool());

  @override
  Widget build(BuildContext context) {
    // Compute image Height base on screen size.
    double width = MediaQuery.of(context).size.width;
    double imageHeight = width < 400 ? 120 : 120 + (width - 400) * 0.1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Favoris',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Wrap(
          children: List.generate(100, (index) {
            return CustomListRow(
              gap: 16,
              px: 16,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderGray),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: imageHeight,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              AppAssets.productExample,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.favorite_outlined),
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(truncate('Ordinateur Portable Lenovo', 50)),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

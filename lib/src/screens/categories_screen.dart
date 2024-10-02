import 'package:ebom/src/components/pub_banner.dart';
import 'package:ebom/src/resources/app_assets.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
        title: const Text(
          'Categories Produits',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        
      ),
      body: Column(
        children: [
          const PubBanner(
            image: AppAssets.bannerGirl,
          ),
          Expanded(
            child: GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 3,
              // Generate 100 widgets that display their index in the List.
              children: List.generate(100, (index) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset(AppAssets.telephoneIntelligent),
                      ),
                      Text('Category $index 1'),
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

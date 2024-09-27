import 'package:ebom/src/manager/categorie_manager.dart';
import 'package:ebom/src/models/categorie_service.dart';
import 'package:ebom/src/resources/app_assets.dart';
import 'package:flutter/material.dart';

class ProductCategoriesSlide extends StatefulWidget {
  const ProductCategoriesSlide({super.key});

  @override
  State<ProductCategoriesSlide> createState() => _ProductCategoriesSlideState();
}

class _ProductCategoriesSlideState extends State<ProductCategoriesSlide> {
  // final CategorieManager categorieService = CategorieManager();
  // late Future<List<dynamic>> categories;

  // @override
  // void initState() {
  //   super.initState();
  //   // Initialize the futures
  //   categories = categorieService.productCategories();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder<List<dynamic>>(
  //     future: categories,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return CircularProgressIndicator();
  //       } else if (snapshot.hasError) {
  //         return Text('Error: ${snapshot.error}');
  //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //         return Text('No product categories available.');
  //       }

  //       // List of Product Categories
  //       return ExpansionTile(
  //         title: Text('Product Categories'),
  //         children: snapshot.data!.map<Widget>((category) {
  //           return ListTile(
  //             title: Text(
  //                 category['nom']), // Replace 'nom' with the appropriate field
  //           );
  //         }).toList(),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
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
            ),
          );
        },
      ),
    );
  }
}

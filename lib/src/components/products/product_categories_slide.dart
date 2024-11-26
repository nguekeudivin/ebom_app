import 'package:ebom/src/components/skeleton/categories_horizontal_list_sekeleton.dart';
import 'package:ebom/src/services/app_service.dart';
import 'package:ebom/src/services/categories_service.dart';
import 'package:ebom/src/services/search_service.dart';
import 'package:ebom/src/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCategoriesSlide extends StatefulWidget {
  const ProductCategoriesSlide({super.key});

  @override
  State<ProductCategoriesSlide> createState() => _ProductCategoriesSlideState();
}

class _ProductCategoriesSlideState extends State<ProductCategoriesSlide> {
  final CategoriesService categorieService = CategoriesService();
  late Future<List<dynamic>> categories;

  @override
  void initState() {
    super.initState();
    // Initialize the futures
    categories = categorieService.productCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: categories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CategoriesHorizontalListSkeleton();
        } else if (snapshot.hasError) {
          return const Text("Une erreur c'est produite");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('');
        }

        // List of Product Categories
        return SizedBox(
          height: 120,
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              var category = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  Provider.of<SearchProvider>(context, listen: false)
                      .setCategoryId(category['id']);

                  Provider.of<AppLayoutNavigationProvider>(
                    context,
                    listen: false,
                  ).setActiveScreen('products_screen');
                },
                child: Container(
                  width: 130,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.network(
                            category['icone'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          truncate(category['nom'], 25),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SizedBox(
  //     height: 108,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: 10,
  //       itemBuilder: (context, index) {
  //         return Container(
  //           width: 100,
  //           margin: const EdgeInsets.symmetric(horizontal: 12),
  //           child: Center(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 SizedBox(
  //                   width: 80,
  //                   height: 80,
  //                   child: Image.asset(AppAssets.telephoneIntelligent),
  //                 ),
  //                 Text('Category $index 1'),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}

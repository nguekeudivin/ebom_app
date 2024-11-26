import 'package:ebom/src/components/list/custom_list_row.dart';
import 'package:ebom/src/components/skeleton/categorie_skeleton.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/services/app_service.dart';
import 'package:ebom/src/services/categories_service.dart';
import 'package:ebom/src/services/search_service.dart';
import 'package:ebom/src/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
        title: const Text(
          'Categories Produits',
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: categories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Wrap(
                children: List.generate(10, (index) {
                  return CustomListRow(
                    gap: 16,
                    px: 16,
                    children: List.generate(2, (index) {
                      return const CategorieSkeleton();
                    }),
                  );
                }),
              );
            } else if (snapshot.hasError) {
              return const Text("Une erreur c'est produite");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Aucune information disponible',
                ),
              );
            }

            double rowCount = snapshot.data!.length / 2;

            return Wrap(
              children: List.generate(rowCount.ceil(), (index) {
                return CustomListRow(
                  px: 16,
                  gap: 16,
                  children: List.generate(
                    2,
                    (colIndex) {
                      if (snapshot.data!.length > (index * 2 + colIndex)) {
                        var category = snapshot.data![index * 2 + colIndex];

                        return GestureDetector(
                          onTap: () {
                            // Provider.of<SearchProvider>(context, listen: false)
                            //     .setKeyword(category['nom']);
                            Provider.of<SearchProvider>(context, listen: false)
                                .setCategoryId(category['id']);

                            Provider.of<AppLayoutNavigationProvider>(
                              context,
                              listen: false,
                            ).setActiveScreen('products_screen');

                            Navigator.of(context).pop();
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
                      } else {
                        return const Text('');
                      }
                    },
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

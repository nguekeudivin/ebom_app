import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/categories/categories_screen.dart';
import 'package:ebom/src/screens/categories/entreprises_types_screen.dart';
import 'package:ebom/src/services/app_service.dart';
import 'package:ebom/src/services/categories_service.dart';
import 'package:ebom/src/services/search_service.dart';
import 'package:ebom/src/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntreprisesTypesSlide extends StatefulWidget {
  const EntreprisesTypesSlide({super.key});

  @override
  State<EntreprisesTypesSlide> createState() => EntrepriseTypesSlide();
}

class EntrepriseTypesSlide extends State<EntreprisesTypesSlide> {
  final CategoriesService categorieService = CategoriesService();
  late Future<List<dynamic>> categories;

  @override
  void initState() {
    super.initState();
    // Initialize the futures
    categories = categorieService.typeEntreprises();
  }

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
                    "Tous les secteurs d'activité",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  // Text(
                  //   'Pour tout besoin',
                  //   style: TextStyle(fontSize: 16),
                  // ),
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
                        builder: (context) => const EntreprisesTypesScreen(),
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
          height: 8,
        ),
        FutureBuilder<List<dynamic>>(
          future: categories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
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
                          .setKeyword(category['nom']);
                      Provider.of<AppLayoutNavigationProvider>(
                        context,
                        listen: false,
                      ).setActiveScreen('products_screen');
                    },
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: Image.network(
                                category['image'],
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
        ),
      ],
    );
  }
}

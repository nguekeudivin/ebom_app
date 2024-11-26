import 'package:ebom/src/components/list/custom_list_row.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/services/categories_service.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final void Function(int value) onFilter;
  final String screen;
  const FilterScreen({
    required this.onFilter,
    this.screen = 'products_screen',
    super.key,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final CategoriesService categorieService = CategoriesService();
  late Future<List<dynamic>> categories;
  final Map<String, bool> values = {};

  @override
  void initState() {
    super.initState();
    // Initialize the futures
    switch (widget.screen) {
      case 'products_screen':
        categories = categorieService.productCategories();
        break;
      case 'entreprises_screen':
        categories = categorieService.typeEntreprises();
        break;
      case 'services_screen':
        categories = categorieService.serviceCategories();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Filtrer la rechercher',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
      //   child: PrimaryButton(
      //     text: 'Appliquer',
      //     onPressed: (context) {
      //       // We get only the first category.
      //       if (values.isNotEmpty) {
      //         widget.onFilter(values.entries.first.key);
      //         Navigator.pop(context);
      //       } else {
      //         Navigator.pop(context);
      //       }
      //     },
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.screen == 'entreprises_screen'
                    ? "Secteur d'activite"
                    : 'Par Categorie',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder(
              future: categories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Text("Une erreur c'est produite");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Aucune categorie disponible',
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(snapshot.data!.length, (index) {
                    return CustomListRow(
                      px: 16,
                      gap: 16,
                      children: List.generate(
                        2,
                        (colIndex) {
                          if (snapshot.data!.length > (index * 2 + colIndex)) {
                            var item = snapshot.data![index * 2 + colIndex];

                            return GestureDetector(
                              onTap: () {
                                widget.onFilter(item['id']);
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 70,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(item['nom']),
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

                // return Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: List.generate(snapshot.data!.length, (index) {
                //     var item = snapshot.data![index];
                //     return InputCheckboxField(
                //       label: Text(item['id']),
                //       isChecked: values[item['nom']] == null
                //           ? false
                //           : values[item['id']] as bool,
                //       onChanged: (value) {
                //         setState(() {
                //           values[item['id']] = value as bool;
                //         });
                //       },
                //     );
                //   }),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}

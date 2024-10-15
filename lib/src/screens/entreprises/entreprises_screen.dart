import 'package:ebom/src/components/header/big_header.dart';
import 'package:ebom/src/components/list/custom_list_row.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/models/entreprise.dart';
import 'package:ebom/src/screens/entreprises/entreprise_details_screen.dart';
import 'package:ebom/src/services/entreprise_service.dart';
import 'package:ebom/src/services/search_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntreprisesScreen extends StatefulWidget {
  const EntreprisesScreen({super.key});

  @override
  State<EntreprisesScreen> createState() => _EntreprisesScreenState();
}

class _EntreprisesScreenState extends State<EntreprisesScreen> {
  final EntrepriseService service = EntrepriseService();
  late Future<List<Entreprise>> entreprises;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the futures
    entreprises = service.items();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      String searchKeyword =
          Provider.of<SearchProvider>(context, listen: false).keyword;
      if (searchKeyword != '') {
        setState(() {
          entreprises = service.search(searchKeyword);
          _searchController.text = searchKeyword;
        });
      }
    });
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is removed
    _searchController.dispose();
    super.dispose();
  }

  void search() {
    setState(() {
      entreprises = service.search(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double widthReference = 400;

    double imageHeight =
        width < widthReference ? 120 : 120 + (width - widthReference) * 0.1;
    // double descriptionHeight = 80;
    double avatarSize = 40;

    // double gridGap = 16.0;
    //double labelPadding = 8;
    //double screenPadding = 16;

    // Adjust child aspect ratio based on screen size

    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              BigHeader(
                title: 'Nos entreprises',
                searchController: _searchController,
                searchPlaceholder: 'Entrer un mot cle',
                onSearch: search,
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: FutureBuilder(
                    future: entreprises,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text("Une erreur c'est produite");
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "Nous n'avons trouvez aucune entreprise correspondante a votre recherche",
                          ),
                        );
                      }

                      double rowCount = snapshot.data!.length / 2;

                      return Wrap(
                        children: List.generate(rowCount.ceil(), (index) {
                          return CustomListRow(
                            px: 16,
                            gap: 16,
                            children: List.generate(2, (colIndex) {
                              if (snapshot.data!.length >
                                  (index * 2 + colIndex)) {
                                var entreprise =
                                    snapshot.data![index * 2 + colIndex];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EntrepriseDetailsScreen(
                                          entreprise: entreprise,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.borderGray,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: imageHeight + avatarSize / 2,
                                          child: Stack(
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                height: imageHeight,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                      10,
                                                    ), // Set the desired radius for top-left corner
                                                    topRight: Radius.circular(
                                                      10,
                                                    ), // Set the desired radius for top-right corner
                                                  ),
                                                  child: Image.network(
                                                    entreprise.image,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              // Positioned(
                                              //   top: imageHeight - 24,
                                              //   child: Container(
                                              //     height: 24,
                                              //     padding: const EdgeInsets.symmetric(
                                              //         horizontal: 8),
                                              //     decoration: const BoxDecoration(
                                              //       color: AppColors.primary,
                                              //       borderRadius: BorderRadius.only(
                                              //         topRight: Radius.circular(12.0),
                                              //       ),
                                              //     ),
                                              //     child: Center(
                                              //       // Centers the text both vertically and horizontally
                                              //       child: Text(
                                              //         entreprise['nom'],
                                              //         style: const TextStyle(
                                              //           color: Colors.white,
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                              Positioned(
                                                top: imageHeight -
                                                    avatarSize / 2 -
                                                    2,
                                                right: 4,
                                                // Layer 2 with manual translation (acts like a higher z-index)
                                                child: Container(
                                                  width: avatarSize,
                                                  height: avatarSize,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20.0,
                                                    ), // Adjust the value to change roundness
                                                    child: Image.network(
                                                      entreprise.image,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Positioned(
                                              //   top: imageHeight + avatarSize / 2 - 4,
                                              //   child: SizedBox(
                                              //     width: (width -
                                              //             gridGap -
                                              //             2 * screenPadding -
                                              //             2 * labelPadding) /
                                              //         2,
                                              //     height: 100,
                                              //     child: Padding(
                                              //       padding:
                                              //           EdgeInsets.all(labelPadding),
                                              //       child: Text(
                                              //         displayDescription,
                                              //         style: const TextStyle(
                                              //             fontSize: 12),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 8.0,
                                          ),
                                          child: Text(entreprise.nom),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return const Text('');
                              }
                            }),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

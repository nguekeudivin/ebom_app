import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebom/src/components/header/big_header.dart';
import 'package:ebom/src/components/skeleton/image_skeleton.dart';
import 'package:ebom/src/components/list/custom_list_row.dart';
import 'package:ebom/src/components/skeleton/listing_skeleton.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/models/service.dart';
import 'package:ebom/src/screens/services/service_details_screen.dart';
import 'package:ebom/src/services/search_service.dart';
import 'package:ebom/src/services/service_service.dart';
import 'package:ebom/src/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final ServiceService service = ServiceService();
  late Future<List<Service>> services;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the futures
    services = service.items();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // String searchKeyword =
      //     Provider.of<SearchProvider>(context, listen: false).keyword;
      // if (searchKeyword != '') {
      //   setState(() {
      //     services = service.search(searchKeyword);
      //     _searchController.text = searchKeyword;
      //   });
      // }
      // Provider.of<SearchProvider>(context, listen: false).setKeyword('');

      int categoryId =
          Provider.of<SearchProvider>(context, listen: false).categoryId;
      if (categoryId != 0) {
        setState(() {
          services = service.searchByCategory(categoryId);
        });
        Provider.of<SearchProvider>(context, listen: false).setCategoryId(0);
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
      services = service.search(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double widthReference = 400;

    double imageHeight =
        width < widthReference ? 120 : 120 + (width - widthReference) * 0.1;

    // Adjust child aspect ratio based on screen size

    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              BigHeader(
                title: 'Nos services',
                searchPlaceholder: 'Entretien',
                searchController: _searchController,
                onSearch: search,
                screen: 'services_screen',
                onFilter: (int value) {
                  setState(() {
                    services = service.searchByCategory(value);
                  });
                },
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: FutureBuilder(
                    future: services,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListingSkeleton();
                      } else if (snapshot.hasError) {
                        return const Text("Une erreur c'est produite");
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "Nous n'avons trouvez aucun service correspondant a votre recherche",
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
                                var item = snapshot.data![index * 2 + colIndex];

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ServiceDetailsScreen(service: item),
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
                                      children: [
                                        Stack(
                                          children: [
                                            SizedBox(
                                              height: imageHeight,
                                              width: double.infinity,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  imageUrl: item.image,
                                                  placeholder: (
                                                    context,
                                                    url,
                                                  ) =>
                                                      const ImageSkeleton(),
                                                  errorWidget: (
                                                    context,
                                                    url,
                                                    error,
                                                  ) =>
                                                      const ImageSkeleton(),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                  ),
                                                ),
                                                child: Text(
                                                  item.nom,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            truncate(
                                              item.description,
                                              50,
                                            ),
                                          ),
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

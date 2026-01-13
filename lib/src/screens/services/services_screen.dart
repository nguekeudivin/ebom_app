import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebom/src/components/header/big_header.dart';
import 'package:ebom/src/components/skeleton/image_skeleton.dart';
import 'package:ebom/src/components/list/custom_list_row.dart';
import 'package:ebom/src/components/skeleton/listing_skeleton.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/models/service.dart';
import 'package:ebom/src/screens/services/service_details_screen.dart';
import 'package:ebom/src/services/search_service.dart';
import 'package:ebom/src/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final SearchService searchService = SearchService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Recherche initiale après le build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final searchProvider =
          Provider.of<SearchProvider>(context, listen: false);

      search({
        'type': 'services',
        'categories': searchProvider.filters['services_screen']!.join(','),
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void search(dynamic params) {
    searchService.search(params);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double widthReference = 400;
    double imageHeight =
        width < widthReference ? 120 : 120 + (width - widthReference) * 0.1;

    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Consumer<SearchProvider>(
                builder: (context, state, child) {
                  return Column(
                    children: [
                      BigHeader(
                        title: 'Services',
                        searchController: _searchController,
                        screen: 'services_screen',
                        onSearch: () {
                          search({
                            'search': _searchController.text,
                            'type': 'services',
                            'categories':
                                state.filters['services_screen']!.join(','),
                          });
                        },
                        onFilter: () {
                          search({
                            'search': _searchController.text,
                            'type': 'services',
                            'categories':
                                state.filters['services_screen']!.join(','),
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16,
                        ),
                        child: Wrap(
                          children: List.generate(
                              state.filters['services_screen']!.length,
                              (index) {
                            final category =
                                state.filters['services_screen']![index];
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.primary),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    category,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () {
                                      state.filters['services_screen']!
                                          .remove(category);
                                      search({
                                        'search': _searchController.text,
                                        'type': 'services',
                                        'categories': state
                                            .filters['services_screen']!
                                            .join(','),
                                      });
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: StreamBuilder<List<ResultItem>>(
                    stream: searchService.stream('services'),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const ListingSkeleton();
                      } else if (snapshot.hasError) {
                        return const Text("Une erreur s'est produite");
                      } else if (snapshot.data!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "Nous n'avons trouvé aucun service correspondant à votre recherche",
                          ),
                        );
                      }

                      final data = snapshot.data!;
                      double rowCount = data.length / 2;

                      return Wrap(
                        children: List.generate(rowCount.ceil(), (index) {
                          return CustomListRow(
                            px: 16,
                            gap: 16,
                            children: List.generate(2, (colIndex) {
                              if (data.length > (index * 2 + colIndex)) {
                                final item = data[index * 2 + colIndex].data;

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ServiceDetailsScreen(
                                          service: Service.fromDynamic(item),
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
                                                  imageUrl: item['image'],
                                                  placeholder:
                                                      (context, url) =>
                                                          const ImageSkeleton(),
                                                  errorWidget:
                                                      (context, url, error) =>
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
                                                  item['nom'],
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
                                            truncate(item['description'], 50),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox();
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


import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebom/src/components/header/big_header.dart';
import 'package:ebom/src/components/skeleton/image_skeleton.dart';
import 'package:ebom/src/components/list/custom_list_row.dart';
import 'package:ebom/src/components/skeleton/listing_skeleton.dart';
import 'package:ebom/src/components/products/product_label.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/products/product_details_screen.dart';
import 'package:ebom/src/services/cache_service.dart';
import 'package:ebom/src/services/product_service.dart';
import 'package:ebom/src/services/search_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  final String keyword;
  const ProductsScreen({this.keyword = '', super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  CacheService cacheService = CacheService();
  final ProductService service = ProductService();

  late Future<List<dynamic>> products;

  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  bool isCached = false;

  @override
  void initState() {
    super.initState();

    products = service.items();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      int categoryId =
          Provider.of<SearchProvider>(context, listen: false).categoryId;

      if (categoryId != 0) {
        // searchByCategory(categoryId);
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
      products = service.search(_searchController.text);
    });
  }

  void searchByCategory(int categoryId) {
    // service.searchByCategory(categoryId, (items) {
    //   setState(() {
    //     products = items;
    //   });
    // }).then((items) => {products = items});
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
                title: 'Produits',
                searchPlaceholder: 'Entrer un mot cle',
                searchController: _searchController,
                onSearch: search,
                searchLoading: isLoading,
                screen: 'products_screen',
                onFilter: (int value) {
                  setState(() {
                    products = service.searchByCategory(value);
                  });
                },
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: FutureBuilder(
                    future: products,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListingSkeleton();
                      } else if (snapshot.hasError) {
                        return const Text("Une erreur c'est produite");
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "Nous n'avons trouvez aucun produit correspondant a votre recherche",
                          ),
                        );
                      }
                      // Save data into cache.
                      cacheService.saveToCache('product_items', snapshot.data);

                      double rowCount = snapshot.data!.length / 2;

                      return Wrap(
                        children: List.generate(rowCount.ceil(), (index) {
                          return CustomListRow(
                            px: 16,
                            gap: 16,
                            children: List.generate(
                              2,
                              (colIndex) {
                                if (snapshot.data!.length >
                                    (index * 2 + colIndex)) {
                                  var product =
                                      snapshot.data![index * 2 + colIndex];

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailsScreen(
                                            product: product,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.gray100,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: imageHeight,
                                            width: double.infinity,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                imageUrl: product['image'],
                                                placeholder: (context, url) =>
                                                    const ImageSkeleton(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const ImageSkeleton(),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: ProductLabel(
                                              product: product,
                                            ),
                                          ),
                                        ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

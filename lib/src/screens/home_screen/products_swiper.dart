import 'package:ebom/src/components/skeleton/horizontal_list_skeleton.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/products/product_details_screen.dart';
import 'package:ebom/src/services/app_service.dart';
import 'package:ebom/src/services/product_service.dart';
import 'package:ebom/src/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsSwiper extends StatefulWidget {
  final Widget title;
  final Widget? subtitle;
  final String apiUri;
  final bool canViewMore;
  final EdgeInsets headerPadding;

  // CategoryId is use to filter results by category.
  // If categoryId is not equal to zero then we apply the filtring system into display.
  final int categoryId; //

  const ProductsSwiper({
    this.title = const Text(
      'Découvrez les meilleurs offres',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    this.subtitle = const Text(
      'Verifiées et certifiées',
      style: TextStyle(fontSize: 14),
    ),
    this.apiUri = 'produits',
    this.canViewMore = true,
    this.headerPadding = const EdgeInsets.all(16.0),
    this.categoryId = 0,
    super.key,
  });

  @override
  State<ProductsSwiper> createState() => _ProductsSwiperState();
}

class _ProductsSwiperState extends State<ProductsSwiper> {
  final ProductService service = ProductService();
  late Future<List<dynamic>> products;

  @override
  void initState() {
    super.initState();
    // Initialize the futures
    products = service.dynamicItems(widget.apiUri);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: products,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return HorizontalListSkeleton();
            } else if (snapshot.hasError) {
              return const Text("Une erreur c'est produite");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                width: double.infinity,
                color: AppColors.gray200,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text('Aucun produit disponible'),
              );
            }

            // We get the product list.
            var items = snapshot.data!;

            // is categories is set. We filter the product list again the category.
            if (widget.categoryId != 0) {
              items = items
                  .where(
                    (item) =>
                        (item['categorie_id'] is String
                            ? int.parse(item['categorie_id'])
                            : item['categorie_id']) ==
                        widget.categoryId,
                  )
                  .toList();
            }

            // is the list is empty. We return the message.
            if (items.isEmpty) {
              return const SizedBox(
                height: 1,
              );
            }

            return Column(
              children: [
                Padding(
                  padding: widget.headerPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.title,
                          if (widget.subtitle != null)
                            widget.subtitle as Widget,
                        ],
                      ),
                      widget.canViewMore
                          ? Container(
                              decoration: BoxDecoration(
                                //color: Colors.blue, // Background color
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary,
                                ), // Make the background circular
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Provider.of<AppLayoutNavigationProvider>(
                                    context,
                                    listen: false,
                                  ).setActiveScreen(
                                    'products_screen',
                                  ); // 3 is the index of
                                },
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.primary,
                                ),
                              ),
                            )
                          : const Text(''),
                    ],
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var product = items[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                product: product,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.gray100),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 150,
                                height: 120,
                                child: Image.network(
                                  product['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 16,
                                        ),
                                        Text('4.5'),
                                      ],
                                    ),
                                    Text(
                                      truncate(
                                        product['nom'],
                                        30,
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${product['prix']} FCFA',
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

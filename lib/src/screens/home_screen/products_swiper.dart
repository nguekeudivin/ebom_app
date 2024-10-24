import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/products/product_details_screen.dart';
import 'package:ebom/src/services/app_service.dart';
import 'package:ebom/src/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsSwiper extends StatefulWidget {
  final Widget title;
  final Widget subtitle;
  final String apiUri;
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
        const SizedBox(height: 16),
        FutureBuilder(
          future: products,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  height: 50,
                  width: 50,
                  padding: const EdgeInsets.all(16),
                  child: const CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return const Text("Une erreur c'est produite");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('');
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.title,
                          widget.subtitle,
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
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var product = snapshot.data![index];

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
                                      product['nom'],
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

import 'package:ebom/src/components/header/big_header.dart';
import 'package:ebom/src/components/list/custom_list_row.dart';
import 'package:ebom/src/components/products/product_label.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/products/product_details_screen.dart';
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
  final ProductService service = ProductService();
  late Future<List<dynamic>> products;
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize the futures
    products = service.items();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      String searchKeyword =
          Provider.of<SearchProvider>(context, listen: false).keyword;

      int categoryId =
          Provider.of<SearchProvider>(context, listen: false).categoryId;

      if (searchKeyword != '') {
        setState(() {
          products = service.search(searchKeyword);
          _searchController.text = searchKeyword;
        });
        Provider.of<SearchProvider>(context, listen: false).setKeyword('');
      }

      if (categoryId != 0) {
        setState(() {
          products = service.searchByCategory(categoryId);
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
      products = service.search(_searchController.text);
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
                title: 'Produits',
                searchPlaceholder: 'Entrer un mot cle',
                searchController: _searchController,
                onSearch: search,
                searchLoading: isLoading,
                screen: 'products_screen',
                onFilter: (value) {
                  setState(() {
                    products = service.search(value);
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
                        return const CircularProgressIndicator();
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
                                              child: Image.network(
                                                product['image'],
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

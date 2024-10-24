import 'package:ebom/src/components/form/input_text_field.dart';
import 'package:ebom/src/components/header/home_header.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/home_screen/banner_swiper_1.dart';
import 'package:ebom/src/screens/home_screen/banner_swiper_2.dart';
import 'package:ebom/src/components/products/categories_swiper.dart';
import 'package:ebom/src/screens/home_screen/entreprise_result_item.dart';
import 'package:ebom/src/screens/home_screen/entreprises_swiper.dart';
import 'package:ebom/src/screens/home_screen/entreprises_types_slide.dart';
import 'package:ebom/src/screens/home_screen/product_result_item.dart';
import 'package:ebom/src/screens/home_screen/products_swiper.dart';
import 'package:ebom/src/screens/home_screen/service_categories_slide.dart';
import 'package:ebom/src/screens/home_screen/service_result_item.dart';
import 'package:ebom/src/screens/home_screen/services_swiper.dart';
import 'package:ebom/src/services/search_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  TextEditingController inputCtl = TextEditingController();
  SearchService searchService = SearchService();
  late Future<List<ResultItem>> results;

  @override
  void initState() {
    super.initState();

    results = searchService.search('');

    // Initialize the futures
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String searchKeyword =
          Provider.of<SearchProvider>(context, listen: false).keyword;
      if (searchKeyword != '') {
        setState(() {
          inputCtl.text = searchKeyword;
        });
        results = searchService.search(searchKeyword);
      }
    });
  }

  void search() {
    Provider.of<SearchProvider>(context, listen: false)
        .setKeyword(inputCtl.text);
    results = searchService.search(inputCtl.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HomeHeader(
                      paddingX: 0,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Visibility(
                      visible:
                          Provider.of<SearchProvider>(context).keyword == '',
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(
                          //   height: 12,
                          // ),
                          // Text(
                          //   'Effectuez une rechercher rapide et precise',
                          //   style: TextStyle(
                          //     fontSize: 18,
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Qu'est ce vous voulez ?",
                            style: TextStyle(
                              // fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InputTextField(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50.0)),
                            borderColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            hintText: 'Ordinateur Lenovo',
                            controller: inputCtl,
                            // prefixIcon: const Icon(
                            //   Icons.search,
                            //   color: AppColors.primary,
                            // ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white, // Background color
                            shape: BoxShape
                                .circle, // Optional: to make the background circular
                          ),
                          child: IconButton(
                            onPressed: search,
                            icon: const Icon(
                              Icons.search,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Consumer<SearchProvider>(
                    builder: (context, state, child) {
                      if (state.keyword == '') {
                        return const Column(
                          children: [
                            SizedBox(height: 24),
                            CategoriesSwiper(),

                            //  PubBanner(
                            //   image: AppAssets.bannerGirl,
                            //   borderRadius: BorderRadius.all(Radius.circular(0)),
                            // ),

                            ProductsSwiper(),
                            SizedBox(height: 24),
                            BannerSwiper2(),
                            SizedBox(height: 24),
                            EntreprisesTypesSlide(),
                            SizedBox(
                              height: 8,
                            ),
                            EntreprisesSwiper(),
                            SizedBox(
                              height: 24,
                            ),
                            BannerSwiper2(),
                            SizedBox(height: 32),
                            ServicesCategoriesSlide(),
                            SizedBox(
                              height: 8,
                            ),
                            ServicesSwiper(),
                            SizedBox(
                              height: 32,
                            ),
                          ],
                        );
                      } else {
                        return FutureBuilder(
                          future: results,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Aucun resultat',
                                ),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Aucun resultat',
                                ),
                              );
                            }

                            return Column(
                              children:
                                  List.generate(snapshot.data!.length, (index) {
                                var item = snapshot.data![index];

                                switch (item.type) {
                                  case 'Produit':
                                    return ProductResultItem(
                                      index: index,
                                      item: item,
                                    );
                                  case 'Entreprise':
                                    return EntrepriseResultItem(
                                      index: index,
                                      item: item,
                                    );
                                  case 'Service':
                                    return ServiceResultItem(
                                      index: index,
                                      item: item,
                                    );
                                  default:
                                    return Text(item.type);
                                }
                              }),
                            );
                          },
                        );
                      }
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

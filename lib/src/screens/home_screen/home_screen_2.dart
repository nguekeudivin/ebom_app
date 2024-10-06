import 'package:ebom/src/components/form/input_text_field.dart';
import 'package:ebom/src/components/header/home_header.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/home_screen/banner_swiper_1.dart';
import 'package:ebom/src/screens/home_screen/banner_swiper_2.dart';
import 'package:ebom/src/screens/home_screen/categories_swiper.dart';
import 'package:ebom/src/screens/home_screen/products_swiper.dart';
import 'package:flutter/material.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  TextEditingController inputCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
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
                    bottom: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeHeader(
                        paddingX: 0,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      const Text(
                        'Effectuez une rechercher rapide',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const Text(
                        "Qu'est ce vous voulez ?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      InputTextField(
                        borderColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        hintText: 'Ordinateur Lenovo',
                        controller: inputCtl,
                        prefixIcon:
                            const Icon(Icons.search, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const CategoriesSwiper(),
                const SizedBox(height: 24),
                const BannerSwiper1(),
                // const PubBanner(
                //   image: AppAssets.bannerGirl,
                //   borderRadius: BorderRadius.all(Radius.circular(0)),
                // ),
                const SizedBox(height: 24),
                const ProductsSwiper(),
                const SizedBox(height: 24),
                const BannerSwiper2(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

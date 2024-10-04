import 'package:ebom/src/components/header/big_header.dart';
import 'package:ebom/src/components/list/custom_list_row.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/resources/app_assets.dart';
import 'package:ebom/src/screens/services/service_details_screen.dart';
import 'package:ebom/src/utils/helpers.dart';
import 'package:flutter/material.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double widthReference = 400;

    double imageHeight =
        width < widthReference ? 120 : 120 + (width - widthReference) * 0.1;

    // Adjust child aspect ratio based on screen size

    return Column(
      children: [
        const BigHeader(
          title: 'Nos services',
          searchPlaceholder: 'Entretien',
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              children: List.generate(15, (index) {
                return CustomListRow(
                  px: 16,
                  gap: 16,
                  children: List.generate(2, (colIndex) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ServiceDetailsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderGray),
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
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      AppAssets.servicesImages[
                                          (index + colIndex) % 6],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Soft et Interieur Akira',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                truncate(
                                  'Description du service. Description du service. Description',
                                  50,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

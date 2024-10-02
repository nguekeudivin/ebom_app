import 'package:ebom/src/components/header/big_header.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/resources/app_assets.dart';
import 'package:ebom/src/screens/entreprise_details_screen.dart';
import 'package:flutter/material.dart';

class EntreprisesScreen extends StatefulWidget {
  const EntreprisesScreen({super.key});

  @override
  State<EntreprisesScreen> createState() => _EntreprisesScreenState();
}

class _EntreprisesScreenState extends State<EntreprisesScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double widthReference = 400;

    double imageHeight =
        width < widthReference ? 120 : 120 + (width - widthReference) * 0.1;
    double descriptionHeight = 80;
    double avatarSize = 40;

    double gridGap = 16.0;
    double labelPadding = 8;
    double screenPadding = 16;

    // Adjust child aspect ratio based on screen size

    return Column(
      children: [
        const BigHeader(title: 'Nos entreprises'),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              children: List.generate(100, (index) {
                String description =
                    'Des voitures de qualité avec une garantie fiable et sure';
                String displayDescription = (description.length > 40)
                    ? '${description.substring(0, 40)}...'
                    : description;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EntrepriseDetailsScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: width / 2 - 2 * screenPadding,
                    height: imageHeight + descriptionHeight,
                    margin: EdgeInsets.only(
                      right: index % 2 == 0 ? gridGap : 0,
                      bottom: gridGap,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderGray),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: imageHeight,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(
                                10,
                              ), // Set the desired radius for top-left corner
                              topRight: Radius.circular(
                                10,
                              ), // Set the desired radius for top-right corner
                            ),
                            child: Image.asset(
                              AppAssets.entreprise,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: imageHeight - 24,
                          child: Container(
                            height: 24,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12.0),
                              ),
                            ),
                            child: const Center(
                              // Centers the text both vertically and horizontally
                              child: Text(
                                'Cami Toyota',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: imageHeight - avatarSize / 2 - 2,
                          right: 4,
                          // Layer 2 with manual translation (acts like a higher z-index)
                          child: Container(
                            width: avatarSize,
                            height: avatarSize,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                20.0,
                              ), // Adjust the value to change roundness
                              child: Image.asset(
                                AppAssets.productExample,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: imageHeight + avatarSize / 2 - 4,
                          child: SizedBox(
                            width: (width -
                                    gridGap -
                                    2 * screenPadding -
                                    2 * labelPadding) /
                                2,
                            height: 100,
                            child: Padding(
                              padding: EdgeInsets.all(labelPadding),
                              child: Text(
                                displayDescription,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

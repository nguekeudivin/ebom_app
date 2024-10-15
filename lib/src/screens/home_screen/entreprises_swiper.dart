import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/models/entreprise.dart';
import 'package:ebom/src/screens/entreprises/entreprise_details_screen.dart';
import 'package:ebom/src/services/app_service.dart';
import 'package:ebom/src/services/entreprise_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntreprisesSwiper extends StatefulWidget {
  final Widget title;
  final Widget subtitle;
  final String apiUri;
  const EntreprisesSwiper({
    this.title = const Text(
      'Nos meilleures entreprises',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    this.subtitle = const Text(
      'Certifies',
      style: TextStyle(fontSize: 14),
    ),
    this.apiUri = 'entreprises',
    super.key,
  });

  @override
  State<EntreprisesSwiper> createState() => _EntreprisesSwiperState();
}

class _EntreprisesSwiperState extends State<EntreprisesSwiper> {
  final EntrepriseService service = EntrepriseService();
  late Future<List<Entreprise>> entreprises;

  @override
  void initState() {
    super.initState();
    // Initialize the futures
    entreprises = service.items();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double widthReference = 400;

    double imageHeight =
        width < widthReference ? 120 : 120 + (width - widthReference) * 0.1;
    // double descriptionHeight = 80;
    double avatarSize = 40;

    return Column(
      children: [
        const SizedBox(height: 16),
        FutureBuilder(
          future: entreprises,
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
                              'entreprises_screen',
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
                  height: imageHeight + avatarSize + 20,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var entreprise = snapshot.data![index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EntrepriseDetailsScreen(
                                entreprise: entreprise,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 150,
                          height: imageHeight + avatarSize + 32,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.borderGray,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: imageHeight + avatarSize / 2,
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
                                        child: Image.network(
                                          entreprise.image,
                                          fit: BoxFit.cover,
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
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            20.0,
                                          ), // Adjust the value to change roundness
                                          child: Image.network(
                                            entreprise.image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0,
                                    bottom: 8.0,
                                  ),
                                  child: Text(entreprise.nom),
                                ),
                              ),
                              //const Spacer()
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

import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/models/service.dart';
import 'package:ebom/src/screens/services/service_details_screen.dart';
import 'package:ebom/src/services/app_service.dart';
import 'package:ebom/src/services/service_service.dart';
import 'package:ebom/src/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServicesSwiper extends StatefulWidget {
  final Widget title;
  final Widget subtitle;
  final String apiUri;
  const ServicesSwiper({
    this.title = const Text(
      'Les services a la une',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    this.subtitle = const Text(
      'Verifies',
      style: TextStyle(fontSize: 14),
    ),
    this.apiUri = 'entreprises',
    super.key,
  });

  @override
  State<ServicesSwiper> createState() => _EntreprisesSwiperState();
}

class _EntreprisesSwiperState extends State<ServicesSwiper> {
  final ServiceService serviceService = ServiceService();
  late Future<List<Service>> services;

  @override
  void initState() {
    super.initState();
    // Initialize the futures
    services = serviceService.items();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double widthReference = 400;

    double imageHeight =
        width < widthReference ? 120 : 120 + (width - widthReference) * 0.1;
    // double descriptionHeight = 80;

    return Column(
      children: [
        const SizedBox(height: 16),
        FutureBuilder(
          future: services,
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
                              'services_screen',
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
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var service = snapshot.data![index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceDetailsScreen(
                                service: service,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 150,
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
                                    service.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(truncate(service.nom, 32)),
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

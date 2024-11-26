import 'package:ebom/src/components/skeleton/horizontal_list_skeleton.dart';
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
  final Widget? subtitle;
  final String apiUri;
  final bool canViewMore;
  final EdgeInsets headerPadding;

  // CategoryId is use to filter results by category.
  // If categoryId is not equal to zero then we apply the filtring system into display.
  final int categoryId; //

  const ServicesSwiper({
    this.title = const Text(
      'Les services à la une',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    this.subtitle = const Text(
      'Verifiées',
      style: TextStyle(fontSize: 14),
    ),
    this.apiUri = 'services',
    this.canViewMore = true,
    this.headerPadding = const EdgeInsets.all(16.0),
    this.categoryId = 0,
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
    services = serviceService.dynamicItems(widget.apiUri);
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
        const SizedBox(height: 4),
        FutureBuilder(
          future: services,
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
                child: const Text('Aucun service disponible 0'),
              );
            }

            // we get the service list.
            var items = snapshot.data!;

            // is categories is set. We filter the services list again the category.
            if (widget.categoryId != 0) {
              items = items
                  .where(
                    (item) => item.categoryId == widget.categoryId,
                  )
                  .toList();
            }

            // is the list is empty. We return the message.
            if (items.isEmpty) {
              return const SizedBox(height: 1);
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      if (widget.canViewMore)
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
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var service = items[index];

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
                          margin: const EdgeInsets.only(right: 16, left: 16),
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

import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/models/entreprise.dart';
import 'package:ebom/src/models/service.dart';
import 'package:ebom/src/screens/entreprises/entreprise_details_screen.dart';
import 'package:ebom/src/services/entreprise_service.dart';
import 'package:flutter/material.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final Service service;
  const ServiceDetailsScreen({required this.service, super.key});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetailsScreen> {
  double bannerHeight = 180;
  double logoSize = 100;
  final EntrepriseService entrepriseService = EntrepriseService();
  late Future<Entreprise> vendor;

  @override
  void initState() {
    super.initState();

    vendor = entrepriseService.getEntreprise(widget.service.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: bannerHeight,
              width: double.infinity,
              child: Image.network(
                widget.service.image,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              color: AppColors.primary,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.service.categorie,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.service.nom,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.service.prix} XAF',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.service.description,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(widget.service.details),
                ],
              ),
            ),
            FutureBuilder(
              future: vendor,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: AppColors.primary,
                    child: const Text(
                      "Les informations de l'entreprise sont indisponibles",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else if (!snapshot.hasData) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: AppColors.primary,
                    child: const Text(
                      "Les informations de l'entreprise sont indisponibles",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                var vendor = snapshot.data!;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  color: AppColors.primary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "L'entreprise",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EntrepriseDetailsScreen(
                                    entreprise: vendor,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 3),
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  50,
                                ), // Adjust the value to change roundness
                                child: Image.network(
                                  vendor.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vendor.nom,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                vendor.telephone,
                                style: const TextStyle(
                                  //  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                vendor.email,
                                style: const TextStyle(
                                  //   fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

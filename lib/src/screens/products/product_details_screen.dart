import 'package:ebom/src/components/button/button_with_icon.dart';
import 'package:ebom/src/components/products/same_products.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/models/entreprise.dart';
import 'package:ebom/src/screens/chat/chat_screen.dart';
import 'package:ebom/src/screens/entreprises/entreprise_details_screen.dart';
import 'package:ebom/src/services/entreprise_service.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic product;
  const ProductDetailsScreen({required this.product, super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  double bannerHeight = 180;
  double logoSize = 100;
  final EntrepriseService entrepriseService = EntrepriseService();

  // Init a vendor entreprise from dynamic.
  Entreprise vendor = Entreprise.fromDynamic({'id': 0});

  Map<String, String> entreprise = {};

  @override
  void initState() {
    super.initState();

    entrepriseService
        .getSimpleEntreprise(widget.product['user_id'])
        .then((vendorResult) {
      setState(() {
        vendor = vendorResult;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
        actions: [
          FittedBox(
            fit: BoxFit.none,
            child: ButtonWithIcon(
              color: Colors.white,
              icon: const Icon(Icons.message, color: Colors.white),
              fixedSize: const Size.fromHeight(40),
              text: 'Contactez Vendeur',
              onPressed: (context) {
                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      conversation: {
                        'id': null,
                        'nom': vendor.nom,
                        'image': vendor.image,
                      },
                      receiverId: vendor.id,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(
            //   height: 220,
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: 1,
            //     itemBuilder: (context, index) {
            //       return SizedBox(
            //         height: 220,
            //         child: Image.network(
            //           widget.product['image'],
            //           fit: BoxFit.cover,
            //         ),
            //       );
            //     },
            //   ),
            // ),
            Center(
              child: SizedBox(
                height: 300,
                child: Image.network(
                  widget.product['image'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    widget.product['categorie'],
                    style: const TextStyle(color: AppColors.gray700),
                  ),
                  Text(
                    widget.product['nom'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 16,
                          ),
                          const Text('4.5'),
                          IconButton(
                            onPressed: () {
                              // Add product to favorite.
                            },
                            icon: const Icon(Icons.favorite_outline),
                            color: Colors.red,
                          ),
                        ],
                      ),
                      Text(
                        '${widget.product['prix']} XAF',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLighter,
                    ),
                    child: Text(widget.product['marque'] ?? ''),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.product['description'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.product['details'],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            if (vendor.id != 0)
              Container(
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
                      'Le vendeur',
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
                              border: Border.all(color: Colors.white, width: 3),
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
              ),
            const SizedBox(
              height: 32,
            ),
            const SameProducts(),
          ],
        ),
      ),
    );
  }
}

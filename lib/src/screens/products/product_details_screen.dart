import 'package:ebom/src/components/button/button_with_icon.dart';
import 'package:ebom/src/components/products/same_products.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/models/chart.dart';
import 'package:ebom/src/models/entreprise.dart';
import 'package:ebom/src/models/message.dart';
import 'package:ebom/src/models/product.dart';
import 'package:ebom/src/resources/app_assets.dart';
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
  late Future<Entreprise> vendor;

  @override
  void initState() {
    super.initState();

    vendor = entrepriseService.getEntreprise(widget.product['user_id']);
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
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      receiverId: widget.product['user_id'],
                      chat: Chat(
                        name: 'Vendeur',
                        image: AppAssets.productsImages[0],
                        messages: [
                          Message(
                            id: 0,
                            senderId: 0,
                            receiverId: 1,
                            content: 'Bonjour je suis interesse par ce produit',
                            time: DateTime.now(),
                            produit: Product(
                              id: 0,
                              nom: 'Ordinateur Lenovo',
                              marque: 'Lenovo',
                              prix: 200000,
                              categorie: 'Ordinateur',
                              description: '',
                            ),
                          ),
                        ],
                      ),
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
                  Text(
                    widget.product['nom'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.product['description'],
                    //   style: const TextStyle(fontWeight: FontWeight.bold),
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
            FutureBuilder(
              future: vendor,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  //return const Text(snapshot.error.toString())
                  return const Text(
                    'Les informations du vendeurs sont indisponibles',
                  );
                } else if (!snapshot.hasData) {
                  return const Text('');
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

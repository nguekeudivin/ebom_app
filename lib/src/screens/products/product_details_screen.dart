import 'package:ebom/src/components/button/button_with_icon.dart';
import 'package:ebom/src/components/products/same_products.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/models/chart.dart';
import 'package:ebom/src/models/message.dart';
import 'package:ebom/src/models/product.dart';
import 'package:ebom/src/resources/app_assets.dart';
import 'package:ebom/src/screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  double bannerHeight = 180;
  double logoSize = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
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
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 220,
                    child: Image.asset(
                      AppAssets.productsImages[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
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
                  const Text(
                    'Ordinateur Portable Lenovo',
                    style: TextStyle(
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
                      const Text(
                        '100,000 XAF',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'This is a fake description of the product. The company should a provide details informations about themselve.\n 16GRAM \n 512DD',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
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
                              chat: Chat(
                                name: 'Vendeur',
                                image: AppAssets.productsImages[0],
                                messages: [
                                  Message(
                                    id: 0,
                                    senderId: 0,
                                    receiverId: 1,
                                    content:
                                        'Bonjour je suis interesse par ce produit',
                                    time: DateTime.now(),
                                    produit: Produit(
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
                  const SizedBox(
                    height: 24,
                  ),
                  const SameProducts(),
                  const SizedBox(
                    height: 48,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

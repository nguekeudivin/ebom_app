import 'package:ebom/src/components/button/button_with_icon.dart';
import 'package:ebom/src/components/contact/contact_info.dart';
import 'package:ebom/src/components/skeleton/snapshot_loader.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/models/entreprise.dart';
import 'package:ebom/src/screens/chat/chat_screen.dart';
import 'package:ebom/src/screens/home_screen/products_swiper.dart';
import 'package:ebom/src/screens/home_screen/services_swiper.dart';
import 'package:ebom/src/services/categories_service.dart';
import 'package:ebom/src/services/entreprise_service.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class EntrepriseDetailsScreen extends StatefulWidget {
  final Entreprise entreprise;
  const EntrepriseDetailsScreen({required this.entreprise, super.key});

  @override
  State<EntrepriseDetailsScreen> createState() =>
      _EntrepriseDetailsScreenState();
}

class _EntrepriseDetailsScreenState extends State<EntrepriseDetailsScreen> {
  double bannerHeight = 180;
  double logoSize = 100;
  late Entreprise _details = Entreprise.fromDynamic({'id': 0});
  late Future<dynamic> _productCategories;
  late Future<dynamic> _serviceCategories;

  final EntrepriseService service = EntrepriseService();
  final CategoriesService categoriesService = CategoriesService();

  @override
  void initState() {
    super.initState();

    _productCategories = categoriesService.productCategories(
      uri: 'categories/produits/entreprise/${widget.entreprise.id}',
    );
    _serviceCategories = categoriesService.serviceCategories(
      uri: 'categories/services/entreprise/${widget.entreprise.id}',
    );

    Future.delayed(Duration.zero, () async {
      service.getEntreprise(widget.entreprise.id).then((details) {
        setState(() {
          _details = details;
        });
      }).catchError((error) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) {
            return AlertDialog(
              content: const Text(
                "Une erreur c'est produite au cours du chargement des informations de l'utilisateur. Verifier votre connexion internet.",
                //error,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      });
    });
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
        actions: [
          FittedBox(
            fit: BoxFit.none,
            child: ButtonWithIcon(
              color: Colors.white,
              icon: const Icon(Icons.message, color: Colors.white),
              fixedSize: const Size.fromHeight(40),
              text: 'Contactez',
              onPressed: (context) {
                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      conversation: {
                        'id': null,
                        'nom': widget.entreprise.nom,
                        'image': widget.entreprise.image,
                      },
                      receiverId: widget.entreprise.id,
                    ),
                  ),
                );
                //
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Positioned(
                  child: Column(
                    children: [
                      SizedBox(
                        height: bannerHeight,
                        width: double.infinity,
                        child: Image.network(
                          _details.banniere,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: logoSize / 2,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 16,
                  top: bannerHeight - logoSize / 2,
                  child: Container(
                    width: logoSize,
                    height: logoSize,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3),
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        50,
                      ), // Adjust the value to change roundness
                      child: Image.network(
                        _details.logo,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              color: AppColors.primary,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                    _details.nom,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ContactInfo(
                userName: _details.directeur,
                phoneNumber: _details.telephone,
                address:
                    '${_details.pays} - ${_details.ville} - ${_details.quartier}',
                email: _details.email,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextButton.icon(
                onPressed: () {
                  final String shareMessage =
                      'Découvre le produit ${widget.entreprise.nom} sur la plateforme E-Bom Market. '
                      'Clique juste sur le lien ci-contre - '
                      'https://ebom-market.com/entreprise/${widget.entreprise.typeEntrepriseId}/${widget.entreprise.typeEntreprise}/${widget.entreprise.id}/${widget.entreprise.nom}';

                  Share.share(shareMessage);
                },
                icon: const Icon(
                  Icons.share,
                  color: AppColors.primary,
                ),
                label: const Text(
                  'Partager',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary, // Couleur assortie à l'icône
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, // Pour coller au bord si nécessaire
                  alignment: Alignment.centerLeft, // Aligne le contenu à gauche
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _details.slogan,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(_details.description),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Les produits de ${_details.nom}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            FutureBuilder(
              future: _productCategories,
              builder: (context, snapshot) {
                return SnapshotLoader(
                  snapshot: snapshot,
                  // This is the message when we have no categories
                  notFoundMessage: 'Aucun produit pour ${_details.nom}',
                  builder: () {
                    return Column(
                      children: List.generate(snapshot.data!.length, (index) {
                        var item = snapshot.data![index];
                        return Column(
                          children: [
                            ProductsSwiper(
                              headerPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              title: Text(
                                item['nom'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: null,
                              categoryId: item['id'],
                              apiUri:
                                  'entreprise/${widget.entreprise.id}/produits',
                              canViewMore: false,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        );
                      }),
                    );
                  },
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Les services de ${_details.nom}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            FutureBuilder(
              future: _serviceCategories,
              builder: (context, snapshot) {
                return SnapshotLoader(
                  snapshot: snapshot,
                  // Message when we have no services category
                  notFoundMessage:
                      'Aucun service disponible pour ${_details.nom}',
                  builder: () {
                    return Column(
                      children: List.generate(snapshot.data!.length, (index) {
                        var item = snapshot.data![index];

                        return Column(
                          children: [
                            ServicesSwiper(
                              headerPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              title: Text(
                                item['nom'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: null,
                              categoryId: item['id'],
                              apiUri:
                                  'entreprise/${widget.entreprise.id}/services',
                              canViewMore: false,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        );
                      }),
                    );
                  },
                );
              },
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:ebom/src/components/button/button_with_icon.dart';
import 'package:ebom/src/components/contact/contact_info.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/models/entreprise.dart';
import 'package:ebom/src/screens/home_screen/products_swiper.dart';
import 'package:ebom/src/screens/home_screen/services_swiper.dart';
import 'package:ebom/src/services/entreprise_service.dart';
import 'package:flutter/material.dart';

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
  final EntrepriseService service = EntrepriseService();

  @override
  void initState() {
    super.initState();

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
            ProductsSwiper(
              title: const Text(
                'Les derniers produits',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              apiUri: 'entreprise/${_details.id}/produits',
            ),
            ServicesSwiper(
              title: const Text(
                'Les derniers services',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              apiUri: 'entreprise/${_details.id}/services',
            ),
          ],
        ),
      ),
    );
  }
}

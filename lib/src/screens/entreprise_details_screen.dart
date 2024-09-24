import 'package:ebom/src/components/contact_info.dart';
import 'package:ebom/src/resources/app_assets.dart';
import 'package:flutter/material.dart';

class EntrepriseDetailsScreen extends StatefulWidget {
  const EntrepriseDetailsScreen({super.key});

  @override
  State<EntrepriseDetailsScreen> createState() =>
      _EntrepriseDetailsScreenState();
}

class _EntrepriseDetailsScreenState extends State<EntrepriseDetailsScreen> {
  double bannerHeight = 180;
  double logoSize = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Positioned(
                  child: Column(
                    children: [
                      SizedBox(
                        height: bannerHeight,
                        width: double.infinity,
                        child: Image.asset(
                          AppAssets.companyBanner,
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
                      child: Image.asset(
                        AppAssets.productExample,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const ContactInfo(
                userName: 'John Doe',
                phoneNumber: '+1 555 123 4567',
                address: '123 Flutter St, Widget City',
                email: 'johndoe@example.com',
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Column(
                children: [
                  Text(
                    'This is a fake description of the company. The company should a provide details informations about themselve.',
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'This is a fake description of the company. The company should a provide details informations about themselve.',
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

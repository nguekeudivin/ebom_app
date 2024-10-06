import 'package:ebom/src/components/contact/contact_info.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/resources/app_assets.dart';
import 'package:flutter/material.dart';

class ServiceDetailsScreen extends StatefulWidget {
  const ServiceDetailsScreen({super.key});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetailsScreen> {
  double bannerHeight = 180;
  double logoSize = 100;

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
              child: Image.asset(
                AppAssets.servicesImages[0],
                fit: BoxFit.cover,
              ),
            ),
            Container(
              color: AppColors.primary,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text(
                "Service d'entretien",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
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

import 'package:ebom/src/components/contact/contact_detail.dart';
import 'package:ebom/src/components/logo.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'A propos de nous',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 32,
              ),
              Logo(),
              SizedBox(
                height: 16,
              ),
              Text(
                'E-bom est une entreprise qui permet à la pop-ulation Camerounaise de connaitre les pro-duits vendu par une ou plusieurs entreprises au sein de notre Pays.',
              ),
              SizedBox(height: 16),
              // Phone number
              ContactDetail(
                icon: Icons.phone,
                label: 'Phone',
                value: '+2379304234',
              ),

              SizedBox(height: 12),
              // Address
              ContactDetail(
                icon: Icons.location_on,
                label: 'Address',
                value: 'Douala, Makepe',
              ),
              SizedBox(height: 12),
              // Email address
              ContactDetail(
                icon: Icons.email,
                label: 'Email',
                value: 'ebom@gmail.com',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

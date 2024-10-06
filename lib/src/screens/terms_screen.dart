import 'package:ebom/src/components/logo/logo.dart';
import 'package:ebom/src/components/button/primary_button.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/register/register_screen.dart';
import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
            child: PrimaryButton(
              text: "J'accepte",
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
            ),
          ),
          body: const Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Logo(),
                  SizedBox(height: 16),
                  Text(
                    "Conditions d'utilisation",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 16),
                  Column(
                    children: [
                      Text(
                        '''1. Acceptation des conditions
En utilisant notre application, vous acceptez de respecter ces conditions.

2. Utilisation de l'application
Vous devez utiliser l'application uniquement à des fins légales et conformes.

3. Propriété intellectuelle
Tous les contenus de l'application sont protégés par les droits d'auteur.

4. Limitation de responsabilité
Nous ne serons pas responsables des dommages résultant de l'utilisation de l'application.

5. Modifications des conditions
Nous nous réservons le droit de modifier ces conditions à tout moment.''',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                  SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

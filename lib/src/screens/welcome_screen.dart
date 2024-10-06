import 'package:ebom/src/components/logo/logo.dart';
import 'package:ebom/src/components/button/primary_button.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/resources/app_assets.dart';
import 'package:ebom/src/screens/login/login_screen.dart';
import 'package:ebom/src/screens/terms_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Logo(),
              const SizedBox(
                height: 48,
              ),
              Image.asset(
                AppAssets.welcomeImage,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: Column(
                  children: [
                    const Text(
                      "Bienvenue sur Ebom ! Gagnez du temps en trouvant précisément le produit qu'il vous faut. Ebom simplifie votre recherche pour vous offrir une expérience rapide et efficace.",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    PrimaryButton(
                      text: 'Se Connecter',
                      onPressed: (context) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    PrimaryButton(
                      text: "S'inscrire",
                      backgroundColor: AppColors.secondary,
                      onPressed: (context) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TermsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

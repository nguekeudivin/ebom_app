import 'package:ebom/src/components/logo/logo.dart';
import 'package:ebom/src/components/button/primary_button.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/models/connexion.dart';
import 'package:ebom/src/resources/app_assets.dart';
import 'package:ebom/src/screens/app_layout.dart';
import 'package:ebom/src/screens/login/login_screen.dart';
import 'package:ebom/src/screens/terms_screen.dart';
import 'package:ebom/src/services/connexion_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    // Initialize the futures
    // nameCtl =
    // phoneNumberCtl =
    // emailCtl =

    ConnexionService connService = ConnexionService();

    Future.delayed(Duration.zero, () async {
      final Connexion? connexion = await connService.getConnexion();

      if (connexion != null) {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => AppLayout(),
          ),
        );
      } else {
        setState(() {
          loading = false;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ConnexionProvider>(context, listen: false).loadConnexion();
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          body: loading
              ? const Center(
                  child: Logo(),
                )
              : SingleChildScrollView(
                  child: SizedBox(
                    height: height,
                    child: Stack(
                      children: [
                        // Top Image Section
                        SizedBox(
                          height: height / 2 + 30,
                          width: double.infinity,
                          child: Image.asset(
                            AppAssets.bannerGirl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Positioned(
                          right: 16,
                          top: 16,
                          child: SizedBox(height: 50, child: Logo()),
                        ),
                        // Bottom Navigation Bar with Rounded Container
                        Positioned(
                          top: height / 2 -
                              30, // Adjust this value for the overlap
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50), // Top left radius
                                topRight:
                                    Radius.circular(50), // Top right radius
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32.0,
                              vertical: 16,
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                const Text(
                                  "Bienvenue sur Ebom ! Gagnez du temps en trouvant précisément le produit qu'il vous faut. Ebom simplifie votre recherche pour vous offrir une expérience rapide et efficace.",
                                  style: TextStyle(fontSize: 16),
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
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                PrimaryButton(
                                  text: "S'inscrire",
                                  backgroundColor: AppColors.darkBlue,
                                  onPressed: (context) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const TermsScreen(),
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
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

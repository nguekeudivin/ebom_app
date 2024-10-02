import 'package:ebom/src/components/form/input_text.dart';
import 'package:ebom/src/components/logo.dart';
import 'package:ebom/src/components/primary_button.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/login/opt_verification_screen.dart';
import 'package:ebom/src/screens/terms_screen.dart';
import 'package:ebom/src/manager/validation_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<LoginScreen> {
  final TextEditingController phoneNumberCtl = TextEditingController();

  final ValidationService validator = ValidationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Logo(),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Connexion',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 48,
                    ),
                    InputText(
                      controller: phoneNumberCtl,
                      label: 'Numero de telephone',
                      placeholder: '6*******',
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: PrimaryButton(
                        text: 'Connectez-vous',
                        onPressed: (context) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const OtpVerificationScreen(),
                            ),
                          );

                          // // Validate the phone number using the validation service.
                          // if (validator
                          //     .validatePhoneNumber(phoneNumberCtl.text)) {
                          //   // Navigator.push(
                          //   //   context,
                          //   //   MaterialPageRoute(
                          //   //     builder: (context) => const LoginScreen(),
                          //   //   ),
                          //   // );
                          // } else {
                          //   // Afficher le message d'erreur de validation.
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(
                          //       content: Text(
                          //         'Veuillez entre un numero de telephone valide.',
                          //       ),
                          //     ),
                          //   );
                          // }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Je n'ai pas encore de compte."),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TermsScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Je m'inscris",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue, // Underline color
                              decorationThickness: 2.0, //
                            ),
                          ),
                        ),
                      ],
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

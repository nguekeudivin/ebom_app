import 'package:ebom/src/components/form/input_text.dart';
import 'package:ebom/src/components/logo/logo.dart';
import 'package:ebom/src/components/button/primary_button.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/manager/auth_service.dart';
import 'package:ebom/src/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen2 extends StatefulWidget {
  final RegisterData data;
  const RegisterScreen2({required this.data, super.key});

  @override
  State<RegisterScreen2> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<RegisterScreen2> {
  TextEditingController phoneNumberCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();

  void submit(BuildContext context) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => AppLayout(),
    //   ),
    // );
    AuthService auth = AuthService();
    auth.register(
      RegisterData(
        nom: widget.data.nom,
        naissance: widget.data.naissance,
        sexe: widget.data.sexe,
        telephone: phoneNumberCtl.text,
        email: emailCtl.text,
      ),
    );

    // // Create a validator instance.
    // ValidationService validator = ValidationService();
    // // Define an array for storing errors.
    // List<String> errors = [];

    // Proceed to validation.

    // // Validate phone number.
    // if (!validator.isRequired(phoneNumberCtl.text)) {
    //   errors.add('Le numero de telephone est requis');
    // }

    // // Validate email.
    // if (!validator.isRequired(emailCtl.text)) {
    //   errors.add("L'addresse email est requise.");
    // }

    // // Check is there is errors and display them.
    // if (errors.isNotEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(errors[0]),
    //     ),
    //   );
    // } else {
    //   AuthService auth = AuthService();
    //   auth.register(
    //     RegisterData(
    //       nom: widget.data.nom,
    //       naissance: widget.data.naissance,
    //       sexe: widget.data.sexe,
    //       telephone: phoneNumberCtl.text,
    //       email: emailCtl.text,
    //     ),
    //   );
    //   // There is no errors then.
    //   // Go to the next step.
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.only(left: 16),
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: AppColors.primary,
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous screen
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Logo(),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Inscription',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Vos informations de contact',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputText(
                    controller: phoneNumberCtl,
                    label: 'Numero de telephone',
                    placeholder: '6*******',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InputText(
                    controller: emailCtl,
                    label: 'Addresse email (Facultatif)',
                    placeholder: 'afrikakemi@gmail.com',
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PrimaryButton(
                      text: "S'inscrire",
                      onPressed: submit,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment
                          .center, // Horizontally center the children
                      runAlignment: WrapAlignment
                          .center, // Vertically center the children
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text('Vous avez déjà un compte ?'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Connectez-vous',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue, // Underline color
                              decorationThickness: 2.0, // Underline thickness
                            ),
                          ),
                        ),
                      ],
                    ),
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

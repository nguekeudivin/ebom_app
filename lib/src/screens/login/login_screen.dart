import 'package:ebom/src/components/form/input_text.dart';
import 'package:ebom/src/components/logo/logo.dart';
import 'package:ebom/src/components/button/primary_button.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/app_layout.dart';
import 'package:ebom/src/screens/login/opt_verification_screen.dart';
import 'package:ebom/src/screens/terms_screen.dart';
import 'package:ebom/src/services/auth_service.dart';
import 'package:ebom/src/services/validation_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<LoginScreen> {
  final TextEditingController phoneNumberCtl = TextEditingController();
  List<String> _errors = [];
  bool _isLoading = false;

  final ValidationService validator = ValidationService();

  void showValidationErrors(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          //title: const Text('Erreur'),
          content: Container(
            //color: Colors.red,
            padding: const EdgeInsets.only(top: 16),
            child: Text(_errors[0], style: const TextStyle(color: Colors.red)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void submit(BuildContext context) {
    setState(() {
      _errors = [];
    });
    // Create a validator instance.
    ValidationService validator = ValidationService();
    // Define an array for storing errors.

    // Proceed to validation.

    // Validate the gender.
    if (!validator.validatePhoneNumber(phoneNumberCtl.text)) {
      setState(() {
        _errors.add('Le numero de telephone est invalide');
      });
    }

    // Check is there is errors and display them.
    if (_errors.isNotEmpty) {
      showValidationErrors(context);
    } else {
      AuthService auth = AuthService();

      auth.getDeviceId(context).then((deviceId) {
        RegisterData data = RegisterData(
          appareil: deviceId,
          telephone: phoneNumberCtl.text,
          role: 'client',
        );

        setState(() {
          _isLoading = true;
        });
        auth.login(data).then((response) {
          setState(() {
            _isLoading = false;
          });
          if (response.status) {
            // if it's a new session then we send the code to phone number.
            if (response.newSession) {
              Navigator.push(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      OtpVerificationScreen(mode: 'login', data: data),
                ),
              );
            } else {
              // If i's not a new session. We redirect the user to the applayout.
              Navigator.push(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (context) => AppLayout()),
              );
            }
          } else {
            setState(() {
              _errors.add(response.message);
            });
            // ignore: use_build_context_synchronously
            showValidationErrors(context);
          }
        }).catchError((error) {
          setState(() {
            _errors.add('Verifier votre connexion internet');
            _isLoading = false;
          });

          // ignore: use_build_context_synchronously
          showValidationErrors(context);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Logo(),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 48,
                        ),
                        InputText(
                          controller: phoneNumberCtl,
                          label: 'Entrez votre numero de telephone',
                          placeholder: '6*******',
                        ),
                        const SizedBox(
                          height: 48,
                        ),
                        PrimaryButton(
                          text: 'Recevoir le code de connexion',
                          onPressed: submit,
                          isLoading: _isLoading,
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
                                  decorationColor:
                                      Colors.blue, // Underline color
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
        ),
      ),
    );
  }
}

import 'package:ebom/src/components/form/input_select.dart';
import 'package:ebom/src/components/form/input_text.dart';
import 'package:ebom/src/components/button/primary_button.dart';
import 'package:ebom/src/components/form/input_date.dart';
import 'package:ebom/src/components/logo/logo.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/login/login_screen.dart';
import 'package:ebom/src/screens/login/opt_verification_screen.dart';
import 'package:ebom/src/services/auth_service.dart';
import 'package:ebom/src/services/validation_service.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<String> _errors = [];
  bool _isLoading = false;

  final List<SelectOption> _genderOptions = [
    SelectOption(label: 'Masculin', value: 'Masculin'),
    SelectOption(label: 'Feminin', value: 'Feminin'),
  ]; // Your dropdown item

  // Use the _nameCrl to handle input name.
  final TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneNumberCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();

  // Use direct handling for birthdate and gender because the component
  // That support theses inputs types  handles the control internally and
  // Provide a onChanged method.
  String birthdate = '';
  String gender = '';

  void showValidationErrors(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Container(
            color: Colors.red,
            padding: const EdgeInsets.all(8),
            child:
                Text(_errors[0], style: const TextStyle(color: Colors.white)),
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

    // Validate the name
    if (!validator.isRequired(nameCtl.text)) {
      setState(() {
        _errors.add('Le nom est requis');
      });
    }

    // Validate birthdate.
    if (!validator.isRequired(birthdate)) {
      setState(() {
        _errors.add('La date de naissance est requise');
      });
    }

    // Validate the gender.
    if (!validator.isRequired(gender)) {
      setState(() {
        _errors.add('Le genre est requis');
      });
    }

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

      auth.getDeviseId(context).then((deviceId) {
        RegisterData data = RegisterData(
          appareil: deviceId,
          nom: nameCtl.text,
          naissance: birthdate,
          sexe: gender,
          telephone: phoneNumberCtl.text,
          email: emailCtl.text,
          role: 'client',
        );

        setState(() {
          _isLoading = true;
        });
        auth.register(data).then((status) {
          setState(() {
            _isLoading = false;
          });
          if (status) {
            Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OtpVerificationScreen(mode: 'register', data: data),
              ),
            );
          } else {
            setState(() {
              _errors.add(
                "Une erreur c'est produite lors de la creation du compte",
              );
            });
            // ignore: use_build_context_synchronously
            showValidationErrors(context);
          }
        }).catchError((error) {
          setState(() {
            _isLoading = false;
          });
          setState(() {
            _errors.add(
              error,
            );
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                const Logo(),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputText(
                        controller: nameCtl,
                        label: 'Nom',
                        placeholder: 'Entrez votre nom',
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InputDate(
                        onChanged: (value) {
                          setState(() {
                            birthdate = value;
                          });
                        },
                        label: 'Date de naissace',
                        placeholder: 'Sélectionnez votre date de naissance',
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InputSelect(
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                        label: 'Sexe',
                        placeholder: 'Sélectionnez votre sexe',
                        options: _genderOptions,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InputText(
                        controller: phoneNumberCtl,
                        label: 'Numero de téléphone',
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
                      PrimaryButton(
                        text: 'Créer le compte',
                        onPressed: submit,
                        isLoading: _isLoading,
                        // onPressed: demo,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Center(
                        child: Column(
                          // Vertically center the children
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
                                  decorationColor:
                                      Colors.blue, // Underline color
                                  decorationThickness:
                                      2.0, // Underline thickness
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
        ),
      ),
    );
  }
}

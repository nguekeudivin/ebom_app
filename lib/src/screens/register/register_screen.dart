import 'package:ebom/src/components/form/input_select.dart';
import 'package:ebom/src/components/form/input_text.dart';
import 'package:ebom/src/components/button/primary_button.dart';
import 'package:ebom/src/components/form/input_date.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/app_layout.dart';
import 'package:ebom/src/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  void submit(BuildContext context) {
    // AuthService auth = AuthService();
    // auth.register(
    //   RegisterData(
    //     nom: 'Divin jordan',
    //     naissance: '1999-08-02',
    //     sexe: 'M',
    //     telephone: '237655660502',
    //     email: 'nguekeu3divin@gmail.com',
    //   ),
    // );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AppLayout()),
    );

    // // Create a validator instance.
    // ValidationService validator = ValidationService();
    // // Define an array for storing errors.
    // List<String> errors = [];

    // // Proceed to validation.

    // // Validate the name
    // if (!validator.isRequired(nameCtl.text)) {
    //   errors.add('Le nom est requis');
    // }

    // // Validate birthdate.
    // if (!validator.isRequired(birthdate)) {
    //   errors.add('La date de naissance est requise');
    // }

    // // Validate the gender.
    // if (!validator.isRequired(gender)) {
    //   errors.add('Le genre est requis');
    // }

    // // Check is there is errors and display them.
    // if (errors.isNotEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(errors[0]),
    //     ),
    //   );
    // } else {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => RegisterScreen2(
    //         data: RegisterData(
    //           nom: nameCtl.text,
    //           sexe: gender,
    //           naissance: birthdate,
    //         ),
    //       ),
    //     ),
    //   );
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

            // const Logo(),
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

            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputText(
                    controller: nameCtl,
                    label: 'Nom',
                    placeholder: 'Entre votre nom',
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
                    placeholder: 'Selectionnez votre date de naissance',
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
                    placeholder: 'Selectionnez votre sexe',
                    options: _genderOptions,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
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
                  PrimaryButton(
                    text: 'Creer le compte',
                    onPressed: submit,
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

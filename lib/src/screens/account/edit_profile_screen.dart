import 'dart:convert';

import 'package:ebom/src/components/button/primary_button.dart';
import 'package:ebom/src/components/form/gender_choice_chip.dart';
import 'package:ebom/src/components/form/input_date.dart';
import 'package:ebom/src/components/form/input_text.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/models/connexion.dart';
import 'package:ebom/src/services/connexion_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isLoading = false;

  final TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneNumberCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();

  String birthdate = '';
  String gender = '';

  // XFile? _imagePicked;

  // void pickImage(BuildContext context) {
  //   ImageService.showPickImage(
  //     context,
  //     onImagePicked: (file) {
  //       setState(() => _imagePicked = file);
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    // Initialize the futures
    // nameCtl =
    // phoneNumberCtl =
    // emailCtl =

    ConnexionService connService = ConnexionService();

    Future.delayed(Duration.zero, () async {
      final Connexion connexion = await connService.getConnexion() as Connexion;

      connService.getUser().then((user) {
        setState(() {
          if (user != null) {
            birthdate = user['naissance'];
            gender = user['sexe'];
          }
        });
      });

      setState(() {
        nameCtl.text = connexion.nom;
        phoneNumberCtl.text = connexion.telephone;
        emailCtl.text = connexion.email;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ConnexionProvider>(context, listen: false).loadConnexion();
    });
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is removed
    nameCtl.dispose();
    phoneNumberCtl.dispose();
    emailCtl.dispose();
    super.dispose();
  }

  void submit(BuildContext context) async {
    ConnexionService service = ConnexionService();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String device = prefs.getString('ebom_device') as String;

    setState(() {
      isLoading = true;
    });
    service
        .updateUser(
      json.encode(
        {
          'appareil': device,
          'nom': nameCtl.text,
          'telephone': phoneNumberCtl.text,
          'email': emailCtl.text,
          'naissance': birthdate,
          'sexe': gender,
          'role': 'client',
        },
      ),
    )
        .then((status) {
      // update connexion data.
      ConnexionService connService = ConnexionService();
      connService
          .update(
        json.decode(
          jsonEncode({
            'nom': nameCtl.text,
            'telephone': phoneNumberCtl.text,
            'email': emailCtl.text,
            'role': 'client',
          }),
        ),
      )
          .then((status) {
        // Now load the new connexion values.
        // ignore: use_build_context_synchronously
        Provider.of<ConnexionProvider>(context, listen: false).loadConnexion();
      });

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Succès',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            content:
                const Text('Vos informations ont été enregistrées avec succès'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(error),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Modifier Profile',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    // const Text(
                    //   'Photo de profile',
                    //   style: TextStyle(fontSize: 18),
                    // ),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    // Center(
                    //   child: _imagePicked == null
                    //       ? GestureDetector(
                    //           onTap: () => pickImage(context),
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(16),
                    //             child: Container(
                    //               width: 100,
                    //               height: 100,
                    //               decoration: BoxDecoration(
                    //                 color: AppColors.primary,
                    //                 borderRadius: BorderRadius.circular(96),
                    //               ),
                    //               child: const Center(
                    //                 child: Icon(
                    //                   Icons.add_a_photo,
                    //                   color: Colors.white,
                    //                   size: 32,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         )
                    //       : GestureDetector(
                    //           onTap: () => pickImage(context),
                    //           child: ClipRRect(
                    //             borderRadius: BorderRadius.circular(104),
                    //             child: kIsWeb
                    //                 ? Image.network(
                    //                     _imagePicked!.path,
                    //                     width: 100,
                    //                     height: 100,
                    //                     fit: BoxFit.cover,
                    //                   )
                    //                 : Image.file(
                    //                     File(_imagePicked!.path),
                    //                     width: 100,
                    //                     height: 100,
                    //                     fit: BoxFit.cover,
                    //                   ),
                    //           ),
                    //         ),
                    // ),
                    // const Divider(
                    //   color: AppColors.borderGray, // Line color
                    //   thickness: 1.0, // Line thickness
                    //   // Right spacing
                    // ),
                    Builder(
                      builder: (context) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            InputText(
                              controller: nameCtl,
                              label: 'Nom',
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            InputDate(
                              value: birthdate,
                              onChanged: (value) {
                                setState(() {
                                  birthdate = value;
                                });
                              },
                              label: 'Date de naissace',
                              placeholder: '',
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const Text(
                              'Sexe',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: GenderChoiceChip(
                                    text: 'Masculin',
                                    selectedValue: gender,
                                    onSelected: (value) {
                                      setState(() {
                                        gender = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: GenderChoiceChip(
                                    text: 'Feminin',
                                    selectedValue: gender,
                                    onSelected: (value) {
                                      setState(() {
                                        gender = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            InputText(
                              controller: phoneNumberCtl,
                              label: 'Numero de telephone',
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            InputText(
                              controller: emailCtl,
                              label: 'Addresse email (Facultatif)',
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            PrimaryButton(
                              text: 'Enregistrer',
                              onPressed: submit,
                              isLoading: isLoading,
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

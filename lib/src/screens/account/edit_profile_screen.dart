import 'dart:io';

import 'package:ebom/src/components/button/primary_button.dart';
import 'package:ebom/src/components/form/input_date.dart';
import 'package:ebom/src/components/form/input_select.dart';
import 'package:ebom/src/components/form/input_text.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/utils/image_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  XFile? _imagePicked;

  void pickImage(BuildContext context) {
    ImageService.showPickImage(
      context,
      onImagePicked: (file) {
        setState(() => _imagePicked = file);
      },
    );
  }

  final List<SelectOption> _genderOptions = [
    SelectOption(label: 'Masculin', value: 'Masculin'),
    SelectOption(label: 'Feminin', value: 'Feminin'),
  ];

  final TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneNumberCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();

  String birthdate = '';
  String gender = '';

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
                    const Text(
                      'Photo de profile',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: _imagePicked == null
                          ? GestureDetector(
                              onTap: () => pickImage(context),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(96),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () => pickImage(context),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(104),
                                child: kIsWeb
                                    ? Image.network(
                                        _imagePicked!.path,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(_imagePicked!.path),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                    ),
                    const Divider(
                      color: AppColors.borderGray, // Line color
                      thickness: 1.0, // Line thickness
                      // Right spacing
                    ),
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
                    InputSelect(
                      onChanged: (value) {
                        setState(() {
                          gender = value;
                        });
                      },
                      label: 'Sexe',
                      options: _genderOptions,
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
                      onPressed: (context) {
                        //
                      },
                    ),
                    const SizedBox(
                      height: 32,
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

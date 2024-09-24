import 'package:ebom/src/components/form/input_text_field.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:flutter/material.dart';

class InputSearch extends StatefulWidget {
  const InputSearch({super.key});

  @override
  State<InputSearch> createState() => _InputSearchState();
}

class _InputSearchState extends State<InputSearch> {
  TextEditingController inputCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InputTextField(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      hintText: 'Rechercher',
      controller: inputCtl,
      prefixIcon: const Icon(Icons.search, color: AppColors.primary),
    );
  }
}

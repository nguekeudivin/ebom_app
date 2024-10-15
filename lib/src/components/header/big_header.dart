import 'package:ebom/src/components/form/input_text_field.dart';
import 'package:ebom/src/components/header/header.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:flutter/material.dart';

class BigHeader extends StatefulWidget {
  final String title;
  final String searchPlaceholder;
  final TextEditingController searchController;
  const BigHeader({
    required this.title,
    required this.searchController,
    this.searchPlaceholder = '',
    super.key,
  });

  @override
  State<BigHeader> createState() => _BigHeaderState();
}

class _BigHeaderState extends State<BigHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(title: widget.title),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: InputTextField(
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  borderColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  hintText: widget.searchPlaceholder,
                  controller: widget.searchController,
                  // prefixIcon:
                  //     const Icon(Icons.search, color: AppColors.primary),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white, // Background color
                  shape: BoxShape
                      .circle, // Optional: to make the background circular
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

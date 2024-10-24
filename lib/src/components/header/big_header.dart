import 'package:ebom/src/components/form/input_text_field.dart';
import 'package:ebom/src/components/header/header.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/search/filter_screen.dart';
import 'package:flutter/material.dart';

class BigHeader extends StatefulWidget {
  final String title;
  final String searchPlaceholder;
  final TextEditingController searchController;
  final void Function() onSearch;
  final void Function(String filter) onFilter;
  final bool searchLoading;
  final String screen;
  const BigHeader({
    required this.title,
    required this.searchController,
    required this.onSearch,
    required this.onFilter,
    required this.screen,
    this.searchPlaceholder = '',
    this.searchLoading = false,
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
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InputTextField(
                    borderColor: Colors.white,
                    focusBorderColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    hintText: widget.searchPlaceholder,
                    controller: widget.searchController,
                    // prefixIcon:
                    //     const Icon(Icons.search, color: AppColors.primary),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white, // Background color
                    shape: BoxShape
                        .circle, // Optional: to make the background circular
                  ),
                  child: IconButton(
                    onPressed: () {
                      print(widget.screen);
                      Navigator.push(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) => FilterScreen(
                            onFilter: widget.onFilter,
                            screen: widget.screen,
                          ),
                        ),
                      );
                    },
                    icon:
                        const Icon(Icons.filter_list, color: AppColors.primary),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white, // Background color
                    shape: BoxShape
                        .circle, // Optional: to make the background circular
                  ),
                  child: IconButton(
                    onPressed: widget.onSearch,
                    icon: const Icon(Icons.search, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

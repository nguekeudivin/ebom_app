import 'package:ebom/src/components/form/input_text_field.dart';
import 'package:ebom/src/components/header/header.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/search/filter_screen.dart';
import 'package:ebom/src/screens/subscriptions/subscribe_modal.dart';
import 'package:ebom/src/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BigHeader extends StatefulWidget {
  final String title;
  final String searchPlaceholder;
  final TextEditingController searchController;
  final void Function() onSearch;
  final void Function() onFilter;
  final String screen;
  const BigHeader({
    required this.title,
    required this.searchController,
    required this.onSearch,
    required this.onFilter,
    required this.screen,
    this.searchPlaceholder = 'Entre un mot clé',
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
                    // onPressed: widget.onSearch,
                    onPressed: () {
                      Provider.of<SubscriptionProvider>(
                        context,
                        listen: false,
                      ).canSearch(context).then((value) {
                        if (!value) {
                          // Save the reference.
                          Provider.of<SubscriptionProvider>(
                            // ignore: use_build_context_synchronously
                            context,
                            listen: false,
                          ).start('@recherche');

                          showModalBottomSheet(
                            // ignore: use_build_context_synchronously
                            context: context,
                            isScrollControlled: true,
                            isDismissible: false,
                            scrollControlDisabledMaxHeightRatio: 0.81,
                            builder: (BuildContext context) {
                              return SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  child: const SubscribeModal(),
                                ),
                              );
                            },
                          );
                        } else {
                          widget.onSearch();
                        }
                      });
                    },
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

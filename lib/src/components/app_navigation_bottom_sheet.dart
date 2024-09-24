import 'package:flutter/material.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/resources/app_assets.dart';

class NavIcon {
  final String label;
  final dynamic icon;
  final String type;

  NavIcon({required this.label, required this.icon, this.type = 'icon'});
}

class AppNavigationBottomSheet extends StatefulWidget {
  const AppNavigationBottomSheet({super.key});

  @override
  State<AppNavigationBottomSheet> createState() =>
      _AppNavigationBottomSheetState();
}

class _AppNavigationBottomSheetState extends State<AppNavigationBottomSheet> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final List<NavIcon> icons = [
      NavIcon(
        label: 'Accueil',
        icon: AppAssets.logoSquare,
        type: 'image',
      ),
      NavIcon(
        label: 'Entreprises',
        icon: Icons.business,
      ),
      NavIcon(label: 'Services', icon: Icons.design_services),
      NavIcon(label: 'Products', icon: Icons.shopping_bag),
      NavIcon(
        label: 'Account',
        icon: Icons.account_circle,
      ),
    ];

    Widget buildIcon(BuildContext context, dynamic item) {
      switch (item.type) {
        case 'image':
          return Image.asset(item.icon, width: 24, height: 24);
        default:
          return Icon(
            item.icon,
            color: Colors.grey,
            size: 24,
          );
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: const Border(top: BorderSide(color: AppColors.borderGray)),
      ),
      child: Wrap(
        runSpacing: 16,
        children: List.generate(
          isExpanded ? icons.length : 5,
          (index) {
            return SizedBox(
              width: screenWidth / 5,
              child: Column(
                children: [
                  buildIcon(context, icons[index]),
                  Text(
                    icons[index].label,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

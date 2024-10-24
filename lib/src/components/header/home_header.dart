import 'package:ebom/src/components/connexion/user_avatar.dart';
import 'package:ebom/src/components/logo/logo_square.dart';
import 'package:ebom/src/screens/account/profile_screen.dart';
import 'package:ebom/src/services/connexion_service.dart';
import 'package:ebom/src/services/search_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  final double? paddingX;
  final Color? textColor;

  const HomeHeader({
    this.paddingX = 16,
    this.textColor = Colors.white,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(paddingX ?? 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Provider.of<SearchProvider>(context).keyword == ''
                  ? const LogoSquare()
                  : IconButton(
                      onPressed: () {
                        Provider.of<SearchProvider>(context, listen: false)
                            .setKeyword('');
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
            ],
          ),
          Consumer<ConnexionProvider>(
            builder: (context, provider, child) {
              return Row(
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Hello',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor ?? Colors.black,
                      ),
                      children: [
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: provider.connexion != null
                              ? provider.connexion?.nom
                              : '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ), // Bold style
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                    child: SizedBox.square(
                      dimension: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          shape:
                              BoxShape.circle, // Ensures the border is circular
                          border: Border.all(
                            color: Colors.white, // White border
                            width: 2, // Border width
                          ),
                        ),
                        child: const UserAvatar(), // Your custom avatar widget
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:ebom/src/components/button/primary_button.dart';
import 'package:ebom/src/components/connexion/user_avatar.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/account/about_screen.dart';
import 'package:ebom/src/screens/account/addresses_screen.dart';
import 'package:ebom/src/screens/account/edit_profile_screen.dart';
import 'package:ebom/src/screens/account/favorites_screen.dart';
import 'package:ebom/src/screens/account/history_screen.dart';
import 'package:ebom/src/screens/account/payment_methods_screen.dart';
import 'package:ebom/src/screens/account/settings_screen.dart';
import 'package:ebom/src/screens/welcome_screen.dart';
import 'package:ebom/src/services/connexion_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Center(
              child: Container(
                width: 110.0, // Slightly larger to include border
                height: 110.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Ensures the border is circular
                  border: Border.all(
                    color: AppColors.primary, // Set your border color
                    width: 3.0, // Border width
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0), // Rounded corners
                  child: const UserAvatar(
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              Provider.of<ConnexionProvider>(context).connexion?.nom ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            FittedBox(
              fit: BoxFit.none,
              child: PrimaryButton(
                text: 'Edit Profile',
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                onPressed: (context) {
                  // Apply edit profile action.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            const Divider(
              color: AppColors.borderGray, // Line color
              thickness: 1.0, // Line thickness
              indent: 16.0, // Left spacing
              endIndent: 16.0, // Right spacing
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  profileLink(
                    icon: Icons.settings,
                    text: 'Parametres',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  profileLink(
                    icon: Icons.history_outlined,
                    text: 'Historique',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HistoryScreen(),
                        ),
                      );
                    },
                  ),
                  profileLink(
                    icon: Icons.credit_card_outlined,
                    text: 'Methode de paiements',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentMethodsScreen(),
                        ),
                      );
                    },
                  ),
                  profileLink(
                    icon: Icons.pin_drop,
                    text: 'Adresse',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddressesScreen(),
                        ),
                      );
                    },
                  ),
                  profileLink(
                    icon: Icons.favorite_outlined,
                    text: 'Favoris',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoritesScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(
              color: AppColors.borderGray, // Line color
              thickness: 1.0, // Line thickness
              indent: 16.0, // Left spacing
              endIndent: 16.0, // Right spacing
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // profileLink(
                  //   icon: Icons.contact_mail_outlined,
                  //   text: 'Contactez-nous',
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => ContactScreen(),
                  //       ),
                  //     );
                  //   },
                  // ),
                  profileLink(
                    icon: Icons.group_outlined,
                    text: 'Inviter un proche',
                    onPressed: () {
                      Share.share("Decouvrez l'application ebom.com");
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const SettingsScreen(),
                      //   ),
                      // );
                    },
                  ),
                  profileLink(
                    icon: Icons.support_agent_outlined,
                    text: 'A propos de nous',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutScreen(),
                        ),
                      );
                    },
                  ),
                  // profileLink(
                  //   icon: Icons.feedback_outlined,
                  //   text: 'Feedback',
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => ContactScreen(),
                  //       ),
                  //     );
                  //   },
                  // ),
                  profileLink(
                    icon: Icons.logout_outlined,
                    text: 'Deconnexion',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Deconnexion'),
                            content: const Text('Voulez-vous vous deconnecter'),
                            actions: [
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      ConnexionService conn =
                                          ConnexionService();
                                      conn.logout().then((status) {
                                        // Remove connexion.
                                        Provider.of<ConnexionProvider>(
                                          // ignore: use_build_context_synchronously
                                          context,
                                          listen: false,
                                        ).removeConnexion();
                                        // Redirect to welcome screen.
                                        Navigator.push(
                                          // ignore: use_build_context_synchronously
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const WelcomeScreen(),
                                          ),
                                        );
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Oui',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Non',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 48,
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

Widget profileLink({
  required IconData icon,
  required String text,
  required void Function() onPressed,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: SizedBox(
      height: 48,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ), // Icon for the detail
              const SizedBox(width: 12),
              Text(text),
            ],
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    ),
  );
}

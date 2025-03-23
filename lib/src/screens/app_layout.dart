import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/account/profile_screen.dart';
import 'package:ebom/src/screens/categories/categories_screen.dart';
import 'package:ebom/src/screens/chat/chats_list_screen.dart';
import 'package:ebom/src/screens/entreprises/entreprises_screen.dart';
import 'package:ebom/src/screens/home_screen/home_screen_2.dart';
import 'package:ebom/src/screens/login/login_screen.dart';
import 'package:ebom/src/screens/products/products_screen.dart';
import 'package:ebom/src/screens/services/services_screen.dart';
import 'package:ebom/src/services/app_service.dart';
import 'package:ebom/src/services/connexion_service.dart';
import 'package:ebom/src/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppLayout extends StatefulWidget {
  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  static final List<Widget> _pages = <Widget>[
    const HomeScreen2(), // 0
    const EntreprisesScreen(), // 1
    const ServicesScreen(), // 2
    const ProductsScreen(), // 3
    const ChatsListScreen(), // 4
    const ProfileScreen(), //5
    const CategoriesScreen(), //6
  ];

  @override
  void initState() {
    super.initState();

    // Check login status.
    Future.delayed(Duration.zero, () async {
      // Check login status.
      ConnexionService connService = ConnexionService();

      connService.checkConnexionStatus().then((status) {
        if (!status) {
          connService.logout();
          Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        } else {
          // ignore: use_build_context_synchronously
          Provider.of<SubscriptionProvider>(context, listen: false)
              // ignore: use_build_context_synchronously
              .loadOngoing(context);
        }
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ConnexionProvider>(context, listen: false).loadConnexion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLayoutNavigationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: _pages[provider.active],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppColors.primary,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'Entreprises',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.design_services),
                label: 'Services',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Chats',
              ),
            ],
            currentIndex: provider.active,
            selectedItemColor: AppColors.secondaryLight,
            unselectedItemColor: Colors.white,
            onTap: (index) {
              provider.setActive(index);
            },
          ),
        );
      },
    );
  }
}

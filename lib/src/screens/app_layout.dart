import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/account/profile_screen.dart';
import 'package:ebom/src/screens/categories_screen.dart';
import 'package:ebom/src/screens/chat/chats_list_screen.dart';
import 'package:ebom/src/screens/entreprises/entreprises_screen.dart';
import 'package:ebom/src/screens/home_screen/home_screen_2.dart';
import 'package:ebom/src/screens/products/products_screen.dart';
import 'package:ebom/src/screens/services/services_screen.dart';
import 'package:flutter/material.dart';

class AppLayout extends StatefulWidget {
  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  // Pages for each bottom navigation link
  static final List<Widget> _pages = <Widget>[
    const HomeScreen2(), // 0
    const EntreprisesScreen(), // 1
    const ServicesScreen(), // 2
    const ProductsScreen(), // 3
    const ChatsListScreen(), // 4
    const ProfileScreen(), //5
    const CategoriesScreen(), //6
  ];
  int _currentIndex = 4;

  void _setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      // Display selected screen
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primary,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.secondaryLight,
        unselectedItemColor: Colors.white,
        onTap: _setCurrentIndex,
      ),
    );
  }
}

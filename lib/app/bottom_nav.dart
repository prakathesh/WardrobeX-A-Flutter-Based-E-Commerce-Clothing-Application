import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home/home_screen.dart';
import 'categories/categories_screen.dart';
import 'cart/cart_screen.dart';
import 'settings/settings_screen.dart';
import '../../providers/cart_provider.dart';

class BottomNav extends StatefulWidget {
  final String? selectedCategory;

  const BottomNav({this.selectedCategory, super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int index = 0;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    final screens = [
      HomeScreen(selectedCategory: selectedCategory),
      CategoriesScreen(),
      CartScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) {
          setState(() {
            index = i;

            // RESET HOME FILTER WHEN HOME BUTTON PRESSED
            if (i == 0) {
              selectedCategory = null;
            }
          });
        },
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart),
                if (cart.totalItems > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        cart.totalItems.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            label: "Cart",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

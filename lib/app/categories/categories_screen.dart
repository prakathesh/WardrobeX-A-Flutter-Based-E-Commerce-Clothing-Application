import 'package:flutter/material.dart';
import '../bottom_nav.dart';

class CategoriesScreen extends StatelessWidget {
  final categories = const [
    {'name': 'Women', 'icon': Icons.woman},
    {'name': 'Men', 'icon': Icons.man},
    {'name': 'Shoes', 'icon': Icons.directions_run},
    {'name': 'Accessories', 'icon': Icons.watch},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("All Categories"),
        backgroundColor: Colors.black,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemBuilder: (context, index) {
          final item = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      BottomNav(selectedCategory: item['name'] as String),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'] as IconData,
                      color: Colors.tealAccent, size: 40),
                  SizedBox(height: 10),
                  Text(
                    item['name'] as String,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

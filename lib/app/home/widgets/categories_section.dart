import 'package:flutter/material.dart';
import '../../bottom_nav.dart';

class CategoriesSection extends StatelessWidget {
  final categories = const [
  {'name': 'Women', 'icon': Icons.woman},
  {'name': 'Men', 'icon': Icons.man},
  {'name': 'Kids', 'icon': Icons.child_care},   // ⭐ NEW
  {'name': 'Shoes', 'icon': Icons.directions_run},
  {'name': 'Accessories', 'icon': Icons.watch},
];


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BottomNav(),
                  ),
                );
              },
              child: Text(
                'See all',
                style: TextStyle(color: Colors.tealAccent),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),

        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final item = categories[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BottomNav(
                      selectedCategory: item['name'] as String,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: Colors.tealAccent,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    item['name'] as String,
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

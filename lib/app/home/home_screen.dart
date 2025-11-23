import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/dummy_products.dart';
import '../../../models/product.dart';
import '../../../providers/cart_provider.dart';

import 'widgets/search_bar.dart';
import 'widgets/categories_section.dart';
import 'widgets/product_list.dart';

class HomeScreen extends StatefulWidget {
  final String? selectedCategory;

  const HomeScreen({this.selectedCategory, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Start with all products
    List<Product> products = List.from(dummyProducts);

    // Filter by category if selected
    if (widget.selectedCategory != null &&
        widget.selectedCategory!.isNotEmpty) {
      products = products
          .where((p) => p.category.toLowerCase() ==
              widget.selectedCategory!.toLowerCase())
          .toList();
    }

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      products = products
          .where((p) =>
              p.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top heading
              Text(
                widget.selectedCategory == null
                    ? "Find your style"
                    : widget.selectedCategory!,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              
              

              const SizedBox(height: 16),

              // Search bar
              HomeSearchBar(
                onSearch: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Show categories only when no category is selected
              if (widget.selectedCategory == null) ...[
                CategoriesSection(),
                const SizedBox(height: 20),
              ],

              // Product results
              products.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 80),
                        child: Text(
                          "No products found",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    )
                  : ProductList(products: products),
            ],
          ),
        ),
      ),
    );
  }
}

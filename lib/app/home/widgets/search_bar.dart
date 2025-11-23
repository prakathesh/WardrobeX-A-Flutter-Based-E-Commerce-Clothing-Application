import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const HomeSearchBar({required this.onSearch, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onSearch,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search for products...',
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: const Icon(Icons.search, color: Colors.white54),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

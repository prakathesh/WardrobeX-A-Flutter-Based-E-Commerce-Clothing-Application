import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  final String? size;
  int quantity;

  CartItem({
    required this.product,
    required this.size,
    required this.quantity,
  });
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  // Add to cart (product + selected size)
  void addToCart(Product product, {String? size}) {
    final key = "${product.id}_${size ?? 'nosize'}";

    if (_items.containsKey(key)) {
      _items[key]!.quantity++;
    } else {
      _items[key] = CartItem(
        product: product,
        size: size,
        quantity: 1,
      );
    }

    notifyListeners();
  }

  // Increase quantity
  void increaseQty(String key) {
    if (_items.containsKey(key)) {
      _items[key]!.quantity++;
      notifyListeners();
    }
  }

  // Decrease quantity
  void decreaseQty(String key) {
    if (!_items.containsKey(key)) return;

    if (_items[key]!.quantity > 1) {
      _items[key]!.quantity--;
    } else {
      _items.remove(key);
    }
    notifyListeners();
  }

  // Remove item
  void removeItem(String key) {
    _items.remove(key);
    notifyListeners();
  }

  // Clear cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Total items
  int get totalItems {
    int total = 0;
    _items.forEach((key, item) {
      total += item.quantity;
    });
    return total;
  }

  // Total price
  double get totalPrice {
    double total = 0.0;
    _items.forEach((key, item) {
      total += item.product.price * item.quantity;
    });
    return total;
  }
}

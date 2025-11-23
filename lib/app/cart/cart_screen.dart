import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final itemsMap = cart.items;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Your Cart"),
        backgroundColor: Colors.black,
      ),
      body: itemsMap.isEmpty
          ? Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: itemsMap.length,
              itemBuilder: (context, index) {
                final key = itemsMap.keys.elementAt(index);
                final cartItem = itemsMap[key]!;

                return Card(
                  color: Colors.grey[900],
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: Image.asset(
                      cartItem.product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      cartItem.product.name,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (cartItem.size != null)
                          Text(
                            "Size: ${cartItem.size}",
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        Text(
                          "\$${cartItem.product.price.toStringAsFixed(2)}",
                          style: TextStyle(color: Colors.tealAccent),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // decrease
                        GestureDetector(
                          onTap: () => cart.decreaseQty(key),
                          child: Icon(Icons.remove, color: Colors.tealAccent),
                        ),
                        SizedBox(width: 12),
                        Text(
                          cartItem.quantity.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(width: 12),
                        // increase
                        GestureDetector(
                          onTap: () => cart.increaseQty(key),
                          child: Icon(Icons.add, color: Colors.tealAccent),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: itemsMap.isEmpty
          ? null
          : Container(
              padding: EdgeInsets.all(16),
              color: Colors.grey[900],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total: \$${cart.totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/checkout');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      foregroundColor: Colors.black,
                    ),
                    child: Text("Checkout"),
                  ),
                ],
              ),
            ),
    );
  }
}

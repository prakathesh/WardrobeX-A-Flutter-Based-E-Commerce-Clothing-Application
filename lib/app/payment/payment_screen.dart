import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../providers/cart_provider.dart';

enum PaymentMethod { applePay, card }

class PaymentScreen extends StatefulWidget {
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.applePay;

  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  bool _isPaying = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _handlePay() async {
    final cart = Provider.of<CartProvider>(context, listen: false);

    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Your cart is empty")));
      return;
    }

    if (_selectedMethod == PaymentMethod.card &&
        !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isPaying = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("You must be logged in to complete payment")));
        return;
      }

      // Convert cart to savable list
      final List<Map<String, dynamic>> orderItems = cart.items.values.map((ci) {
        final product = ci.product;

        return {
          "productId": product.id,
          "name": product.name,
          "price": product.price,
          "quantity": ci.quantity,
          "size": ci.size,
          "imageUrl": product.imageUrl,
        };
      }).toList();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("orders")
          .add({
        "items": orderItems,
        "total": cart.totalPrice,
        "paymentMethod":
            _selectedMethod == PaymentMethod.applePay ? "Apple Pay" : "Card",
        "createdAt": FieldValue.serverTimestamp(),
      });

      cart.clearCart();

      setState(() => _isPaying = false);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text("Order Confirmed",
              style: TextStyle(color: Colors.white)),
          content: const Text("Thank you! Your order has been placed.",
              style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child:
                  const Text("Close", style: TextStyle(color: Colors.tealAccent)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushNamed(context, "/orders");
              },
              child: const Text("View Orders",
                  style: TextStyle(color: Colors.tealAccent)),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() => _isPaying = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Payment failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total: \$${cart.totalPrice.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.tealAccent,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text("${cart.totalItems} item(s)",
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),

            const Text("Choose payment method",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            // Apple Pay
            RadioListTile(
              value: PaymentMethod.applePay,
              groupValue: _selectedMethod,
              onChanged: (val) => setState(() => _selectedMethod = val!),
              activeColor: Colors.tealAccent,
              title: const Text("Apple Pay", style: TextStyle(color: Colors.white)),
              subtitle: const Text("Fast checkout",
                  style: TextStyle(color: Colors.white54)),
            ),

            // Card
            RadioListTile(
              value: PaymentMethod.card,
              groupValue: _selectedMethod,
              onChanged: (val) => setState(() => _selectedMethod = val!),
              activeColor: Colors.tealAccent,
              title: const Text("Credit / Debit Card",
                  style: TextStyle(color: Colors.white)),
            ),

            if (_selectedMethod == PaymentMethod.card)
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _cardNumberController,
                      decoration: const InputDecoration(labelText: "Card Number"),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) =>
                          value == null || value.length < 12
                              ? "Enter valid card number"
                              : null,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _expiryController,
                            decoration:
                                const InputDecoration(labelText: "Expiry MM/YY"),
                            style: const TextStyle(color: Colors.white),
                            validator: (value) =>
                                value == null || value.isEmpty
                                    ? "Required"
                                    : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _cvvController,
                            decoration: const InputDecoration(labelText: "CVV"),
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            validator: (value) =>
                                value == null || value.length < 3
                                    ? "Invalid"
                                    : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isPaying ? null : _handlePay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isPaying
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text("Pay Now",
                        style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

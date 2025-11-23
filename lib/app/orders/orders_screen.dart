import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // If user not logged in
    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("My Orders"),
          backgroundColor: Colors.black,
        ),
        body: const Center(
          child: Text(
            "Please log in to view orders",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('orders')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(color: Colors.tealAccent),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error loading orders",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No orders found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final total = order['total'] ?? 0.0;
              final method = order['paymentMethod'] ?? '';
              final createdAt = order['createdAt']?.toDate();

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order #${order.id.substring(0, 6)}",
                      style: const TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Total: \$${total.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Payment: $method",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    if (createdAt != null)
                      Text(
                        "Date: ${createdAt.toLocal()}",
                        style: const TextStyle(color: Colors.white54),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

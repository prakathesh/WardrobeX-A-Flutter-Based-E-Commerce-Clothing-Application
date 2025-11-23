import 'package:flutter/material.dart';
import '../settings/account_screen.dart';
import '../orders/orders_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),

          // ACCOUNT
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: const Text(
              'Account',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AccountScreen()),
              );
            },
          ),

          Divider(color: Colors.white12, thickness: 0.5),

          // MY ORDERS
          ListTile(
            leading: const Icon(Icons.receipt_long, color: Colors.tealAccent),
            title: const Text(
              'My Orders',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>  OrdersScreen()),
              );
            },
          ),

          Divider(color: Colors.white12, thickness: 0.5),

          // MORE OPTIONS (future)
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.white),
            title: const Text(
              'Help & Support',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),

          Divider(color: Colors.white12, thickness: 0.5),

          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white),
            title: const Text(
              'About',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

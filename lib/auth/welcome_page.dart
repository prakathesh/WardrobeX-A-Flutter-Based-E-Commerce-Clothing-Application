import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WardrobeX'), backgroundColor: Colors.black),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('WardrobeX',
                style: TextStyle(fontSize: 28, color: Colors.white)),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent),
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: Text('Login', style: TextStyle(color: Colors.black)),
            ),
            SizedBox(height: 20),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.tealAccent)),
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: Text('Sign Up',
                  style: TextStyle(color: Colors.tealAccent)),
            ),
          ],
        ),
      ),
    );
  }
}

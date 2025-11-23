import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmController = TextEditingController();
  bool loading = false;

  Future<void> signup() async {
    if (passController.text.trim() != confirmController.text.trim()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Passwords do not match")));
      return;
    }

    try {
      setState(() => loading = true);

      // 1. Create User
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      // 2. Save to Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(cred.user!.uid)
          .set({
        "email": emailController.text.trim(),
        "name": "",
        "phone": "",
        "createdAt": DateTime.now(),
      });

      // 3. Navigate to Main App
      Navigator.pushReplacementNamed(context, '/mainApp');

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? "Signup error")));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              SizedBox(height: 15),
              TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
              ),
              SizedBox(height: 15),
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Confirm Password"),
              ),
              SizedBox(height: 25),
              loading
                  ? CircularProgressIndicator(color: Colors.tealAccent)
                  : ElevatedButton(
                      onPressed: signup,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent),
                      child: Text("Create Account",
                          style: TextStyle(color: Colors.black)),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

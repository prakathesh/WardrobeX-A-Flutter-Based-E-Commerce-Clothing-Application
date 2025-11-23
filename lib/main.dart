import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';

// Provider
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';

// Auth Screens
import 'auth/welcome_page.dart';
import 'auth/login_page.dart';
import 'auth/signup_page.dart';
import 'auth/forgot_password_page.dart';

// Main App Screens
import 'app/bottom_nav.dart';
import 'app/payment/payment_screen.dart';
import 'app/orders/orders_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Wrap the whole app with MultiProvider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WardrobeX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.tealAccent),
          ),
        ),
      ),

      // IF logged in → BottomNav, ELSE → Welcome page
      home: FirebaseAuth.instance.currentUser == null
          ? WelcomePage()
          : BottomNav(),

      routes: {
        '/welcome': (context) => WelcomePage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/forgot': (context) => ForgotPasswordPage(),
        '/mainApp': (context) => BottomNav(),

        // ❌ FIXED: removed const (OrdersScreen is not const)
        '/orders': (context) => OrdersScreen(),

        '/checkout': (context) => PaymentScreen(),
      },
    );
  }
}

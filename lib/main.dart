import 'package:flutter/material.dart';

// صفحات البداية والتسجيل وتسجيل الدخول
import 'screens/auth/welcome_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/login_screen.dart';

// صفحات الإدمن والمستخدم
import 'screens/admin/admin_screen.dart';
import 'screens/user/user_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DZ SHOPING',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/admin': (context) => const AdminScreen(), // صفحة الإدمن
        '/user_home': (context) => const UserHome(), // صفحة المستخدم
      },
    );
  }
}

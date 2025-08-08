import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// صفحات المستخدم
import 'screens/auth/welcome_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/user/user_home.dart';

// صفحات الإدمن
import 'screens/admin/admin_screen.dart';
import 'screens/admin/user_management_screen.dart';
import 'screens/admin/product_management_screen.dart';

// الـ Providers
import 'providers/user_provider.dart';
import 'providers/product_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DZ SHOPING',
        theme: ThemeData(primarySwatch: Colors.teal),
        initialRoute: '/',
        routes: {
          '/': (context) => const WelcomeScreen(),
          '/register': (context) => const RegisterScreen(),
          '/login': (context) => const LoginScreen(),
          '/user_home': (context) => const UserHome(),

          // مسارات الإدمن
          '/admin': (context) => const AdminScreen(),
          '/admin/users': (context) => const UserManagementScreen(),
          '/admin/products': (context) => const ProductManagementScreen(),
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/user_provider.dart';

import 'screens/auth/welcome_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/login_screen.dart';

import 'screens/user/user_home.dart';
import 'screens/user/recharge_request_screen.dart';   // <-- أضف هذا السطر

import 'screens/admin/admin_screen.dart';
import 'screens/admin/user_management_screen.dart';
import 'screens/admin/product_management_screen.dart';

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
      ],
      child: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          Widget startScreen = const WelcomeScreen();

          if (userProvider.currentUser != null) {
            if (userProvider.currentUser!.id == "0") {
              startScreen = const AdminScreen();
            } else {
              startScreen = const UserHome();
            }
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'DZ SHOPING',
            theme: ThemeData(primarySwatch: Colors.teal),
            home: startScreen,
            routes: {
              '/register': (context) => const RegisterScreen(),
              '/login': (context) => const LoginScreen(),
              '/user_home': (context) => const UserHome(),
              '/recharge_request': (context) => const RechargeRequestScreen(),   // <-- أضف هذا السطر
              '/admin': (context) => const AdminScreen(),
              '/admin/users': (context) => const UserManagementScreen(),
              '/admin/products': (context) => const ProductManagementScreen(),
            },
          );
        },
      ),
    );
  }
}

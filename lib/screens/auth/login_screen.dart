import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // تفقد بيانات الإدمن الصريحة
    if (email == 'larbilarabi06@gmail.com' && password == 'Miral1992Miro') {
      Navigator.pushReplacementNamed(context, '/admin');
      return;
    }

    // تحقق من مستخدم عادي عبر UserProvider
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final user = userProv.authenticate(email, password);
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/user_home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('بيانات خاطئة أو المستخدم غير موجود')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الدخول'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'البريد الإلكتروني')),
            const SizedBox(height: 10),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'كلمة المرور'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, minimumSize: const Size(double.infinity, 50)),
              child: const Text('دخول', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

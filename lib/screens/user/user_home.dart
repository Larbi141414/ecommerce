import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'recharge_request_screen.dart'; // تأكد من صحة مسار الاستيراد

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context);
    final currentUser = userProv.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفحة الرئيسية للمستخدم'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'تسجيل الخروج',
            onPressed: () async {
              await userProv.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: currentUser == null
            ? const Center(child: Text('لم يتم تسجيل الدخول'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مرحبًا، ${currentUser.name}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'رصيدك الحالي: ${currentUser.balance.toStringAsFixed(2)} دج',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RechargeRequestScreen(),
                        ),
                      );
                    },
                    child: const Text('طلب شحن الرصيد'),
                  ),
                ],
              ),
      ),
    );
  }
}

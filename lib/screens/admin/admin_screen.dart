import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم الأدمن'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade50, Colors.red.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAdminButton(
              context,
              label: 'إدارة المستخدمين',
              onPressed: () => Navigator.pushNamed(context, '/admin/users'),
            ),
            const SizedBox(height: 20),
            _buildAdminButton(
              context,
              label: 'إدارة المنتجات',
              onPressed: () => Navigator.pushNamed(context, '/admin/products'),
            ),
            const SizedBox(height: 20),
            _buildAdminButton(
              context,
              label: 'طلبات شحن الرصيد',
              onPressed: () => Navigator.pushNamed(context, '/admin/recharge_requests'),
            ),
            // يمكنك إضافة أزرار إضافية هنا بسهولة
          ],
        ),
      ),
    );
  }

  Widget _buildAdminButton(BuildContext context,
      {required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: Text(label),
      ),
    );
  }
}

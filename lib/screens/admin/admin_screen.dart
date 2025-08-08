import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم الإدمن'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text('إدارة المستخدمين'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () => Navigator.pushNamed(context, '/admin/users'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.inventory_2),
              label: const Text('إدارة المنتجات'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () => Navigator.pushNamed(context, '/admin/products'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.receipt_long),
              label: const Text('عرض الطلبات (مؤقت)'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                // هنا يمكنك فتح شاشة الطلبات لاحقًا
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('واجهة الطلبات ستكون هنا')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

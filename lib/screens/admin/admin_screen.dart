import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("لوحة تحكم الإدمن"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Center(
            child: Text(
              "مرحبًا بك أيها الإدمن",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('إدارة المنتجات'),
            onTap: () {
              // انتقل لصفحة إدارة المنتجات
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('عرض الطلبات'),
            onTap: () {
              // انتقل لصفحة عرض الطلبات
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('إدارة المستخدمين'),
            onTap: () {
              // انتقل لصفحة إدارة المستخدمين
            },
          ),
        ],
      ),
    );
  }
}

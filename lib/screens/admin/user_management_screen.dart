import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _idController = TextEditingController();
  final _amountController = TextEditingController();
  final _deleteIdController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _amountController.dispose();
    _deleteIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستخدمين'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'تسجيل الخروج',
            onPressed: () async {
              await userProv.logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // إضافة رصيد
          const Text(
            'إضافة رصيد لمستخدم (أدخل ID والمبلغ)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _idController,
            decoration: const InputDecoration(labelText: 'User ID'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'المبلغ (دج)'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final id = _idController.text.trim();
              final amount = double.tryParse(_amountController.text.trim()) ?? -1;

              if (id.isEmpty || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ادخل ID صحيح ومبلغ أكبر من 0'),
                  ),
                );
                return;
              }

              final ok = await userProv.addBalance(id, amount);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    ok ? 'تم إضافة الرصيد' : 'لم يتم العثور على المستخدم',
                  ),
                ),
              );
              if (ok) {
                _idController.clear();
                _amountController.clear();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: const Text('إضافة رصيد'),
          ),
          const Divider(height: 30),

          // حذف مستخدم
          const Text(
            'حذف مستخدم (أدخل ID)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _deleteIdController,
            decoration: const InputDecoration(labelText: 'User ID'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final id = _deleteIdController.text.trim();
              if (id.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ادخل ID صحيح')),
                );
                return;
              }
              final ok = await userProv.deleteUser(id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    ok ? 'تم حذف المستخدم' : 'لم يتم العثور على المستخدم',
                  ),
                ),
              );
              if (ok) _deleteIdController.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: const Text('حذف مستخدم'),
          ),
          const Divider(height: 30),

          // قائمة المستخدمين
          const Text(
            'قائمة المستخدمين',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...userProv.allUsers.map((u) {
            return Card(
              child: ListTile(
                title: Text('${u.name} (${u.email})'),
                subtitle: Text(
                  'ID: ${u.id} — رصيد: ${u.balance.toStringAsFixed(2)} دج',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('تأكيد الحذف'),
                        content: Text('هل تريد حذف المستخدم ${u.name}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('إلغاء'),
                          ),
                          TextButton(
                            onPressed: () async {
                              final ok = await userProv.deleteUser(u.id);
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(ok
                                      ? 'تم حذف المستخدم'
                                      : 'لم يتم العثور على المستخدم'),
                                ),
                              );
                            },
                            child: const Text(
                              'حذف',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

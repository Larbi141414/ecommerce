import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class RechargeRequestsScreen extends StatelessWidget {
  const RechargeRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('طلبات شحن الرصيد'),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder(
        future: userProv.loadRechargeRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userProv.rechargeRequests.isEmpty) {
            return const Center(child: Text('لا توجد طلبات شحن حالياً'));
          }

          return ListView.builder(
            itemCount: userProv.rechargeRequests.length,
            itemBuilder: (context, index) {
              final request = userProv.rechargeRequests[index];
              final user = userProv.allUsers.firstWhere(
                (u) => u.id == request.userId,
                orElse: () => User(id: 'unknown', name: 'مستخدم غير معروف', email: '', balance: 0.0),
              );

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  title: Text(
                    '${user.name} (${user.email.isNotEmpty ? user.email : "بدون بريد إلكتروني"})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('المبلغ المطلوب: ${request.amount.toStringAsFixed(2)} دج',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      if (request.receiptImagePath.isNotEmpty && File(request.receiptImagePath).existsSync())
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(request.receiptImagePath),
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        const Text('لا توجد صورة'),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        tooltip: 'قبول الطلب',
                        onPressed: () async {
                          await userProv.approveRechargeRequest(request.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تمت إضافة الرصيد وقبول الطلب')),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        tooltip: 'رفض الطلب',
                        onPressed: () async {
                          await userProv.removeRechargeRequest(request.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم رفض الطلب وحذفه')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

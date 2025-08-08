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
                orElse: () => null,
              );

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(user != null ? '${user.name} (${user.email})' : 'مستخدم غير معروف'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('المبلغ المطلوب: ${request.amount.toStringAsFixed(2)} دج'),
                      const SizedBox(height: 8),
                      if (request.receiptImagePath.isNotEmpty)
                        Image.file(
                          File(request.receiptImagePath),
                          height: 150,
                          fit: BoxFit.cover,
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

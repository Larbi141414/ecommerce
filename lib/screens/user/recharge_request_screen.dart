import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class RechargeRequestScreen extends StatefulWidget {
  const RechargeRequestScreen({super.key});

  @override
  State<RechargeRequestScreen> createState() => _RechargeRequestScreenState();
}

class _RechargeRequestScreenState extends State<RechargeRequestScreen> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('طلب شحن الرصيد'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'طريقة الدفع عبر Baridimob',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'المبلغ المراد شحنه (دج)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                final amount = double.tryParse(_amountController.text.trim()) ?? 0;
                if (amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('يرجى إدخال مبلغ صالح أكبر من 0')),
                  );
                  return;
                }

                // هنا يمكنك إرسال الطلب إلى الإدارة أو تخزينه مؤقتًا
                // مثلاً يمكن إضافة وظيفة في UserProvider لحفظ طلبات الشحن أو إرسالها

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم إرسال طلب الشحن، سيتم المراجعة من قبل الإدارة')),
                );
                _amountController.clear();
              },
              child: const Text('إرسال طلب الشحن'),
            ),
          ],
        ),
      ),
    );
  }
}

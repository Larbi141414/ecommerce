import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class RechargeRequestScreen extends StatefulWidget {
  const RechargeRequestScreen({super.key});

  @override
  State<RechargeRequestScreen> createState() => _RechargeRequestScreenState();
}

class _RechargeRequestScreenState extends State<RechargeRequestScreen> {
  final _amountController = TextEditingController();
  File? _receiptImage;

  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      setState(() {
        _receiptImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context);
    final currentUser = userProv.currentUser;

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
            const SizedBox(height: 8),
            const Text(
              'يرجى إرسال المبلغ مع صورة الإيصال إلى رقم الحساب التالي:',
            ),
            const SizedBox(height: 8),
            SelectableText(
              '00799999001880013078',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'المبلغ المراد شحنه (دج)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo),
              label: const Text('اختر صورة الإيصال'),
            ),

            const SizedBox(height: 12),

            if (_receiptImage != null)
              SizedBox(
                height: 150,
                child: Image.file(_receiptImage!),
              ),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () async {
                final amount = double.tryParse(_amountController.text.trim()) ?? 0;

                if (amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('الرجاء إدخال مبلغ صحيح')),
                  );
                  return;
                }

                if (_receiptImage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('يرجى اختيار صورة الإيصال')),
                  );
                  return;
                }

                if (currentUser == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('يجب تسجيل الدخول أولاً')),
                  );
                  return;
                }

                // توليد ID فريد للطلب
                final requestId = DateTime.now().millisecondsSinceEpoch.toString();

                // إنشاء طلب الشحن
                final newRequest = RechargeRequest(
                  id: requestId,
                  userId: currentUser.id,
                  amount: amount,
                  receiptImagePath: _receiptImage!.path,
                );

                // إضافة الطلب عبر المزود
                await userProv.addRechargeRequest(newRequest);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إرسال طلب الشحن، سيتم التواصل معك قريبًا'),
                  ),
                );

                // إعادة تعيين الحقول
                _amountController.clear();
                setState(() {
                  _receiptImage = null;
                });
              },
              child: const Text('إرسال طلب الشحن'),
            ),
          ],
        ),
      ),
    );
  }
}

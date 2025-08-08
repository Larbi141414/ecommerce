import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../models/recharge_request.dart';  // استيراد نموذج بيانات الطلب

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
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
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
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'طريقة الدفع عبر Baridimob',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'يرجى إرسال المبلغ مع صورة الإيصال إلى رقم الحساب التالي:',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    SelectableText(
                      '00799999001880013078',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'المبلغ المراد شحنه (دج)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('اختر صورة الإيصال'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 15),
            if (_receiptImage != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _receiptImage!,
                    height: 180,
                    width: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (_receiptImage == null)
              Center(
                child: Text(
                  'لم يتم اختيار صورة الإيصال',
                  style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                ),
              ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 6,
                  shadowColor: Colors.red.shade700,
                ),
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

                  final requestId = DateTime.now().millisecondsSinceEpoch.toString();

                  final newRequest = RechargeRequest(
                    id: requestId,
                    userId: currentUser.id,
                    amount: amount,
                    receiptImagePath: _receiptImage!.path,
                  );

                  await userProv.addRechargeRequest(newRequest);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إرسال طلب الشحن، سيتم التواصل معك قريبًا'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 3),
                    ),
                  );

                  _amountController.clear();
                  setState(() {
                    _receiptImage = null;
                  });
                },
                child: const Text(
                  'إرسال طلب الشحن',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

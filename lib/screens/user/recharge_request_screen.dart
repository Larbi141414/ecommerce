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
              style: TextStyle(fontWeight: FontWeight.bold)

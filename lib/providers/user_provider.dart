import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../models/recharge_request.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  User? currentUser;

  List<RechargeRequest> _rechargeRequests = [];

  List<User> get allUsers => _users;
  List<RechargeRequest> get rechargeRequests => _rechargeRequests;

  // تحميل المستخدمين من SharedPreferences
  Future<void> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('users');
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      _users = decoded.map((e) => User.fromMap(e)).toList();
    }
    notifyListeners();
  }

  // حفظ المستخدمين
  Future<void> saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> mapped = _users.map((e) => e.toMap()).toList();
    await prefs.setString('users', jsonEncode(mapped));
  }

  // تسجيل مستخدم جديد
  Future<bool> register(String name, String email, String password) async {
    final exists = _users.any((u) => u.email == email);
    if (exists) return false;

    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      balance: 0,
    );

    _users.add(newUser);
    await saveUsers();
    notifyListeners();
    return true;
  }

  // تسجيل الدخول (تجاهل كلمة المرور هنا)
  Future<bool> login(String email, String password) async {
    try {
      final user = _users.firstWhere((u) => u.email == email);
      currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // إضافة رصيد
  Future<bool> addBalance(String userId, double amount) async {
    final user = _users.firstWhere(
      (u) => u.id == userId,
      orElse: () => User(id: '', name: '', email: ''),
    );
    if (user.id.isEmpty) return false;

    user.balance += amount;
    await saveUsers();
    notifyListeners();
    return true;
  }

  // حذف مستخدم
  Future<bool> deleteUser(String userId) async {
    _users.removeWhere((u) => u.id == userId);
    await saveUsers();
    notifyListeners();
    return true;
  }

  // تحميل طلبات الشحن
  Future<void> loadRechargeRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('rechargeRequests');
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      _rechargeRequests = decoded.map((e) => RechargeRequest.fromMap(e)).toList();
    }
    notifyListeners();
  }

  // حفظ طلبات الشحن
  Future<void> saveRechargeRequests() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> mapped = _rechargeRequests.map((e) => e.toMap()).toList();
    await prefs.setString('rechargeRequests', jsonEncode(mapped));
  }

  // إضافة طلب شحن جديد
  Future<void> addRechargeRequest(RechargeRequest request) async {
    _rechargeRequests.add(request);
    await saveRechargeRequests();
    notifyListeners();
  }

  // إزالة طلب شحن
  Future<void> removeRechargeRequest(String id) async {
    _rechargeRequests.removeWhere((r) => r.id == id);
    await saveRechargeRequests();
    notifyListeners();
  }

  // الموافقة على طلب شحن (إضافة الرصيد ثم حذف الطلب)
  Future<void> approveRechargeRequest(String requestId) async {
    final request = _rechargeRequests.firstWhere(
      (r) => r.id == requestId,
      orElse: () => RechargeRequest(id: '', userId: '', amount: 0, receiptImagePath: ''),
    );
    if (request.id.isEmpty) return;

    await addBalance(request.userId, request.amount);
    await removeRechargeRequest(requestId);
  }

  // تسجيل الخروج
  Future<void> logout() async {
    currentUser = null;
    notifyListeners();
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String id;
  final String name;
  final String email;
  double balance;

  User({required this.id, required this.name, required this.email, this.balance = 0.0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'balance': balance,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      balance: (map['balance'] ?? 0).toDouble(),
    );
  }
}

class RechargeRequest {
  final String id; // رقم فريد
  final String userId;
  final double amount;
  final String receiptImagePath;

  RechargeRequest({
    required this.id,
    required this.userId,
    required this.amount,
    required this.receiptImagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'receiptImagePath': receiptImagePath,
    };
  }

  factory RechargeRequest.fromMap(Map<String, dynamic> map) {
    return RechargeRequest(
      id: map['id'],
      userId: map['userId'],
      amount: (map['amount'] ?? 0).toDouble(),
      receiptImagePath: map['receiptImagePath'],
    );
  }
}

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
    // تحقق من وجود البريد مسبقاً
    final exists = _users.any((u) => u.email == email);
    if (exists) return false;

    // إنشاء مستخدم جديد (يمكنك هنا إضافة تشفير كلمة المرور لو أردت)
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

  // تسجيل الدخول
  Future<bool> login(String email, String password) async {
    // البحث عن المستخدم بالبريد (تجاهل كلمة المرور هنا، قم بتعديل حسب الحاجة)
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String id;
  String name;
  String email;
  String password;
  double balance;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.balance = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'balance': balance,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      balance: (map['balance'] ?? 0).toDouble(),
    );
  }
}

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  User? _currentUser;

  User? get currentUser => _currentUser;

  // Getter لتوافق الكود مع الشاشة
  List<User> get users => _users;

  UserProvider() {
    _init();
  }

  Future<void> _init() async {
    await loadUsers();
    await loadCurrentUser();
  }

  // تحميل المستخدمين من التخزين
  Future<void> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? usersData = prefs.getString('users');
    if (usersData != null) {
      List<dynamic> decoded = jsonDecode(usersData);
      _users = decoded.map((userMap) => User.fromMap(userMap)).toList();
    }
    notifyListeners();
  }

  // حفظ المستخدمين
  Future<void> saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> mappedUsers =
        _users.map((u) => u.toMap()).toList();
    await prefs.setString('users', jsonEncode(mappedUsers));
  }

  // حفظ المستخدم الحالي
  Future<void> saveCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentUser != null) {
      await prefs.setString('currentUserId', _currentUser!.id);
    } else {
      await prefs.remove('currentUserId');
    }
  }

  // تحميل المستخدم الحالي
  Future<void> loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('currentUserId');
    if (userId != null) {
      if (userId == "0") {
        _currentUser = User(
          id: "0",
          name: "Admin",
          email: "larbilarabi06@gmail.com",
          password: "Miral1992Miro",
        );
      } else {
        _currentUser = _users.firstWhere(
          (u) => u.id == userId,
          orElse: () => User(id: '', name: '', email: '', password: ''),
        );
        if (_currentUser!.id.isEmpty) _currentUser = null;
      }
    }
    notifyListeners();
  }

  // تسجيل مستخدم جديد
  Future<bool> register(String name, String email, String password) async {
    await loadUsers();
    bool exists = _users.any((u) => u.email == email);
    if (exists) return false;

    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
    );

    _users.add(newUser);
    await saveUsers();
    return true;
  }

  // تسجيل الدخول
  Future<bool> login(String email, String password) async {
    await loadUsers();

    // تسجيل دخول كإدمن
    if (email == "larbilarabi06@gmail.com" && password == "Miral1992Miro") {
      _currentUser = User(
        id: "0",
        name: "Admin",
        email: email,
        password: password,
      );
      await saveCurrentUser();
      notifyListeners();
      return true;
    }

    // تسجيل دخول كمستخدم عادي
    final user = _users.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => User(id: '', name: '', email: '', password: ''),
    );

    if (user.id.isNotEmpty) {
      _currentUser = user;
      await saveCurrentUser();
      notifyListeners();
      return true;
    }

    return false;
  }

  // تسجيل الخروج
  Future<void> logout() async {
    _currentUser = null;
    await saveCurrentUser();
    notifyListeners();
  }

  // إضافة رصيد مع إرجاع true/false
  Future<bool> addBalance(String userId, double amount) async {
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      _users[index].balance += amount;
      await saveUsers();
      notifyListeners();
      return true;
    }
    return false;
  }

  // حذف مستخدم مع إرجاع true/false
  Future<bool> deleteUser(String userId) async {
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      _users.removeAt(index);
      await saveUsers();
      notifyListeners();
      return true;
    }
    return false;
  }
}

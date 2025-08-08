import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  final List<AppUser> _users = [
    // حساب الإدمن الافتراضي (للتجربة)
    AppUser(
      id: 'admin',
      name: 'Administrator',
      email: 'larbilarabi06@gmail.com',
      password: 'Miral1992Miro',
      balance: 0.0,
    ),
    // مستخدم تجريبي
    AppUser(
      id: 'u1',
      name: 'Ali',
      email: 'ali@example.com',
      password: 'pass123',
      balance: 500.0,
    ),
  ];

  List<AppUser> get users => List.unmodifiable(_users);

  AppUser? getById(String id) {
    try {
      return _users.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }

  AppUser? getByEmail(String email) {
    try {
      return _users.firstWhere((u) => u.email == email);
    } catch (e) {
      return null;
    }
  }

  AppUser? authenticate(String email, String password) {
    try {
      return _users.firstWhere((u) => u.email == email && u.password == password);
    } catch (e) {
      return null;
    }
  }

  bool addUser(AppUser user) {
    if (getById(user.id) != null || getByEmail(user.email) != null) return false;
    _users.add(user);
    notifyListeners();
    return true;
  }

  bool deleteUser(String id) {
    final idx = _users.indexWhere((u) => u.id == id);
    if (idx == -1) return false;
    _users.removeAt(idx);
    notifyListeners();
    return true;
  }

  bool addBalance(String id, double amount) {
    final user = getById(id);
    if (user == null) return false;
    user.balance += amount;
    notifyListeners();
    return true;
  }
}

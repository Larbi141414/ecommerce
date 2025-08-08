class AppUser {
  String id;
  String name;
  String email;
  String password;
  double balance;

  AppUser({
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

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'] ?? '',
      balance: (map['balance'] ?? 0).toDouble(),
    );
  }
}

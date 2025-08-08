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
}

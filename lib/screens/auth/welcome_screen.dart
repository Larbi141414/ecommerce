import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // الشريط العلوي
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.white, Colors.teal],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // عنوان التطبيق في الوسط
                  const Text(
                    'DZ SHOPING',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),

                  // زر تسجيل الدخول على اليسار كزر ElevatedButton صغير
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.teal.shade700,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),

                  // زر تسجيل على اليمين كزر OutlinedButton صغير
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'تسجيل',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // محتوى الصفحة
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7F9), Color(0xFFB2DFDB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // شعار التطبيق (ضع صورة شعارك في assets/images/logo.png)
              Image.asset(
                'assets/images/logo.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 24),
              const Text(
                'DZ SHOPING',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'أفضل منصة للتسوق الإلكتروني، تسوق بكل سهولة وأمان.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 36),

              // زر تسجيل الدخول
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'تسجيل الدخول',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),

              // زر التسجيل
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.teal.shade700),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'إنشاء حساب جديد',
                  style: TextStyle(fontSize: 18, color: Colors.teal.shade700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

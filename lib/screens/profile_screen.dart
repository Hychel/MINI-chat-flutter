import 'package:flutter/material.dart';
import '../core/app_strings.dart';
import '../repositories/auth_repository.dart';
import '../core/services/analytics_service.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static final AuthRepository _auth = AuthRepository();

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      AnalyticsService.logSignOut();

      // ✅ ТВОЯ ЛОГІКА — Очищаємо стек навігації
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
            (route) => false,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Помилка виходу: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          AppStrings.profileTitle ?? 'Профіль',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,  // ✅ Зліва як на скріні
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ ПРОСТИЙ АВАТАР З СКРІНУ
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white, size: 60),
              ),
              const SizedBox(height: 20),

              // ✅ ТЕКСТ ІМ'Я З СКРІНУ
              Text(
                user?.displayName ?? 'John Doe',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),

              // ✅ EMAIL З СКРІНУ
              Text(
                user?.email ?? 'example@gmail.com',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 28),

              // ✅ ЧОРНА КНОПКА З СКРІНУ
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => _signOut(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppStrings.signOutButton ?? 'Вийти з акаунта',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

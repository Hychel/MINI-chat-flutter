import 'package:flutter/material.dart';
import '../core/app_strings.dart';
import '../core/validators.dart';
import '../repositories/auth_repository.dart';
import '../core/services/analytics_service.dart';
import 'navigation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignUp = true; // true = Register, false = Sign In
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  bool _isLoading = false;

  final AuthRepository _auth = AuthRepository();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    return FormValidators.validateEmail(v);
  }
  String? _validatePassword(String? v) {
    return FormValidators.validatePassword(v);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      UserCredential? credential;
      Exception? authError;

      if (isSignUp) {
        // РЕЄСТРАЦІЯ
        try {
          credential = await _auth.signUp(
            email: _emailCtrl.text.trim(),
            password: _passCtrl.text,
          );
          AnalyticsService.logSignUp();
        } catch (e) {
          authError = e as Exception;
        }
      } else {
        // ВХІД
        try {
          credential = await _auth.signIn(
            email: _emailCtrl.text.trim(),
            password: _passCtrl.text,
          );
          AnalyticsService.logLogin();
        } catch (e) {
          authError = e as Exception;
        }
      }

      if (credential != null && mounted) {
        // УСПІШНА АВТОРИЗАЦІЯ
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => NavigationScreen()),
        );
      } else if (authError != null && mounted) {
        // ПОМИЛКА АВТОРИЗАЦІЇ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authError.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // НЕОЧІКУВАНА ПОМИЛКА
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An unexpected error occurred. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade400),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Text(
                    AppStrings.appTitle,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    isSignUp ? AppStrings.signupTitle : AppStrings.loginTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isSignUp
                        ? 'Enter your email to sign up for this app'
                        : 'Enter your credentials to sign in',
                    style: TextStyle(color: Colors.black.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // ПОЛЕ EMAIL
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                    decoration: InputDecoration(
                      hintText: AppStrings.emailHint,
                      isDense: true,
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      enabledBorder: inputBorder,
                      focusedBorder: inputBorder.copyWith(
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      errorBorder: inputBorder.copyWith(
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // ПОЛЕ ПАРОЛЯ
                  TextFormField(
                    controller: _passCtrl,
                    validator: _validatePassword,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      hintText: AppStrings.passwordHint,
                      isDense: true,
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      enabledBorder: inputBorder,
                      focusedBorder: inputBorder.copyWith(
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      errorBorder: inputBorder.copyWith(
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  // КНОПКА УХІД/РЕЄСТРАЦІЯ
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        isSignUp
                            ? AppStrings.registerButton
                            : AppStrings.loginButton,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // ПОЛІТИКА КОНФІДЕНЦІАЛЬНОСТІ
                  Text(
                    AppStrings.termsAndPolicy,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black.withOpacity(0.55),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  // РОЗДІЛ "АБО"
                  Row(
                    children: const [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('or'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // ПЕРЕКЛЮЧЕННЯ МІЖ РЕЄСТРАЦІЄЮ/ЛОГІНОМ
                  GestureDetector(
                    onTap: () => setState(() => isSignUp = !isSignUp),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black.withOpacity(0.8)),
                        children: [
                          TextSpan(
                            text: isSignUp
                                ? 'Already have an account? '
                                : 'Don\'t have an account? ',
                          ),
                          TextSpan(
                            text: isSignUp ? 'Sign In' : 'Register',
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

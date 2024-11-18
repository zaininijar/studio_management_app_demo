import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studio_management/providers/auth_provider.dart';
import 'package:studio_management/screens/home_screen.dart';
import 'package:studio_management/screens/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final isAuth = context.read<AuthProvider>().isAuthenticated;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => isAuth ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

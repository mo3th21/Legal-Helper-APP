import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qanon/providers/auth_provider_interface.dart';
import 'package:qanon/screens/login_screen.dart';
import 'package:qanon/screens/bottom_nav_screen.dart';
import 'package:qanon/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounce;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _bounce = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      final auth = context.read<AuthProviderInterface>();
      if (auth.isAuthenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const BottomNavScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fade.value,
              child: Transform.scale(
                scale: _bounce.value,
                child: child,
              ),
            );
          },
          child: Image.asset(
            'assets/images/splash_logo1.png',
            width: 340,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
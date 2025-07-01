import 'dart:async';
import 'package:flutter/material.dart';
import '../routes/route_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    // 1. إعداد أنيميشن Fade-In قصير
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    // 2. الانتقال بعد ثانيتين
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          RouteManager.roleSelection, // الوجهة التالية
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
      backgroundColor: Colors.white, // نفس خلفية التصميم
      body: FadeTransition(
        opacity: _fade,
        child: Center(
          child: Image.asset(
            'assets/splash/meditrack_splash.png',
            width: MediaQuery.of(context).size.width * 0.7,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

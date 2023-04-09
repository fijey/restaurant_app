import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/common/restaurant_theme.dart';
import 'package:restaurant_app/screen/homepage/home_page.dart';
import 'package:restaurant_app/widget/lottie_files.dart';
import 'package:restaurant_app/widget/scale_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final int _currentSlogan = 0;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const Center(
        child: const Text(
          "Eatsie",
          style: TextStyle(
            fontSize: 50.0,
            fontWeight: FontWeight.bold,
            color: RestaurantTheme.primary,
          ),
        ),
      ),
    );
  }
}

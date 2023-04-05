import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/screen/homepage/home_page.dart';
import 'package:restaurant_app/widget/lottie_files.dart';
import 'package:restaurant_app/widget/scale_text.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  int _currentSlogan = 0;

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieFile(asset: "assets/splash-logo.json"),
            // Animasi nama restaurant
            Text(
              "Eatsie",
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 20.0),
            // Selogan restaurant
            ScaleText(text: [
              ScaleAnimatedText("MURAH"),
              ScaleAnimatedText("ENAK!"),
              ScaleAnimatedText("PUAS"),
              ScaleAnimatedText("NAMBAH LAGI")
            ])
          ],
        ),
      ),
    );
  }
}

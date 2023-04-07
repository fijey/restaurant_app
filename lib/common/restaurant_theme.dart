import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RestaurantTheme {
  // Color palette
  static const Color primary = Color(0xFF2B2D42);
  static const Color tertiary = Color(0xFFBBDEFB);
  static const Color secondary = Color(0xFF8D99AE);
  static const Color text = Color.fromARGB(255, 255, 255, 255); // dark grey
  static const Color heading = Color.fromARGB(255, 255, 255, 255); // black
  static const Color heading2 = Color(0xFFF8F32B);

  // Typography
  static TextStyle welcomeText = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: heading2,
    fontStyle: FontStyle.italic,
    shadows: const [
      Shadow(
        color: Colors.grey,
        blurRadius: 2,
        offset: Offset(1, 1),
      ),
    ],
  );

  static TextStyle titleOnCard = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: heading2,
  );

  static TextStyle styleHeadingPrimary = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: primary,
  );
}

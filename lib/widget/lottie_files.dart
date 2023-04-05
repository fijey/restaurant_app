import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lottie/lottie.dart';

class LottieFile extends StatelessWidget {
  String asset;
  LottieFile({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(asset);
  }
}

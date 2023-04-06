import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class ScaleText extends StatelessWidget {
  List<AnimatedText> text;
  ScaleText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(width: 20.0, height: 100.0),
        Center(
          child: Container(
            child: DefaultTextStyle(
              style: const TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0)),
              child: AnimatedTextKit(
                animatedTexts: text,
                repeatForever: true,
                pause: const Duration(milliseconds: 500),
                onTap: () {
                  print("Tap Event");
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

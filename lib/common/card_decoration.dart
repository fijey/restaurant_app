import 'package:flutter/material.dart';
import 'package:restaurant_app/common/restaurant_theme.dart';

class ContainerDecoration {
  static BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: RestaurantTheme.secondary,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: RestaurantTheme.primary.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}

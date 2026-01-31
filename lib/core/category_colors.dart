import 'package:flutter/material.dart';

class CategoryColors {
  static const Map<String, Color> colors = {
    'Food': Color(0xFF4CAF50),          // Green
    'Transport': Color(0xFF2196F3),     // Blue
    'Shopping': Color(0xFF9C27B0),      // Purple
    'Bills': Color(0xFFFF9800),         // Orange
    'Entertainment': Color(0xFFE91E63), // Pink
    'Others': Color(0xFF9E9E9E),         // Grey
  };

  static Color get(String category) {
    return colors[category] ?? const Color(0xFF9E9E9E);
  }
}

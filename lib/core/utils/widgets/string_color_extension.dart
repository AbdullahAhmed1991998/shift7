import 'package:flutter/material.dart';

extension StringColorExtension on String {
  Color toColor() {
    final hexRegExp = RegExp(r'^#?([0-9a-fA-F]{6}|[0-9a-fA-F]{3})$');
    final colorMap = {
      'red': Colors.red,
      'blue': Colors.blue,
      'green': Colors.green,
      'black': Colors.black,
      'white': Colors.white,
      'yellow': Colors.yellow,
      'grey': Colors.grey,
      'gray': Colors.grey,
      'orange': Colors.orange,
      'purple': Colors.purple,
      'brown': Colors.brown,
      'pink': Colors.pink,
    };

    final cleaned = trim().toLowerCase();

    if (hexRegExp.hasMatch(cleaned.replaceFirst('#', ''))) {
      String hex = cleaned.replaceFirst('#', '');
      if (hex.length == 3) {
        hex = hex.split('').map((c) => '$c$c').join();
      }
      return Color(int.parse('FF$hex', radix: 16));
    }

    return colorMap[cleaned] ?? Colors.transparent;
  }
}

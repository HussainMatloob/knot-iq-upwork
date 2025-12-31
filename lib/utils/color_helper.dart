import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorHelper {
  static Color hexToColor(String? hex, {Color fallback = Colors.grey}) {
    if (hex == null) return fallback;

    try {
      hex = hex.replaceAll('#', '');

      if (hex.length == 6) {
        return Color(int.parse('0xFF$hex'));
      } else if (hex.length == 8) {
        return Color(int.parse('0x$hex'));
      }
    } catch (_) {}

    return fallback;
  }
}

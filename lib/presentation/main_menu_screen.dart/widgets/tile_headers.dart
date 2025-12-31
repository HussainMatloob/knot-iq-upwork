import 'package:flutter/material.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class TileHeaders extends StatelessWidget {
  final String title;
  TileHeaders({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Appcolors.blackColor,
          fontSize: bodyfontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

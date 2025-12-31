import 'package:flutter/material.dart';

import 'package:knot_iq/utils/colors.dart';

class ReminderTileWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  const ReminderTileWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFDDF2F2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 0), // IMPORTANT → shadow on all sides
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 8,
            width: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF2CB9B0),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8),

          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Appcolors.blackColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Appcolors.blackColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

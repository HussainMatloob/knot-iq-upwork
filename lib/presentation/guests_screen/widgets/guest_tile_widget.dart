import 'dart:math';

import 'package:flutter/material.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class GuestTileWidget extends StatelessWidget {
  String name;
  String? status;
  String? guestCount;
  VoidCallback? onTap;
  GuestTileWidget({
    super.key,
    required this.name,
    this.status,
    this.guestCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Appcolors.whiteColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Appcolors.randomColors[Random().nextInt(4)],
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty ? name[0] : "",
                  style: TextStyle(
                    color: Appcolors.whiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Appcolors.blackColor,
                    fontSize: headdingfontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  status ?? "",
                  style: TextStyle(
                    color: Appcolors.blackColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Appcolors.greenColor,
              ),
              child: Center(
                child: Text(
                  guestCount ?? "",
                  style: TextStyle(
                    color: Appcolors.whiteColor,
                    fontSize: bodyfontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

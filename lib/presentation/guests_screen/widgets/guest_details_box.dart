import 'package:flutter/material.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class GuestDetailsBox extends StatelessWidget {
  String title;
  String value;
  GuestDetailsBox({super.key, this.title = "", this.value = ""});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 30,
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Appcolors.whiteColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Appcolors.blackColor,
                fontSize: headdingfontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 14),
            Text(
              value,
              style: TextStyle(
                color: Appcolors.blackColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

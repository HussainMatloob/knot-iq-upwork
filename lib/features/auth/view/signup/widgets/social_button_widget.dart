import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:knot_iq/utils/constants.dart';

class SocialButtonWidget extends StatelessWidget {
  IconData? icon;
  String? iconAsset;
  String text;
  Color background;
  Color textColor;
  Color? borderColor;
  VoidCallback? onTap;
  SocialButtonWidget({
    super.key,
    this.icon,
    this.iconAsset,
    required this.text,
    required this.background,
    required this.textColor,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 51,
      child: OutlinedButton.icon(
        icon: iconAsset != null
            ? SvgPicture.asset(iconAsset ?? "", semanticsLabel: '')
            : Icon(icon, color: textColor, size: 30),
        label: Text(
          text,
          style: TextStyle(
            fontSize: headdingfontSize,
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: borderColor ?? Colors.transparent,
            width: borderColor != null ? 1.2 : 0,
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:knot_iq/utils/colors.dart';

class CustomTileWidget extends StatelessWidget {
  final String iconPath;
  final String title;
  String? trailingText;
  VoidCallback? onTap;
  bool isIcon;
  CustomTileWidget({
    super.key,
    required this.iconPath,
    required this.title,
    this.trailingText,
    this.onTap,
    this.isIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Appcolors.whiteColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isIcon
                ? SvgPicture.asset(iconPath)
                : Icon(Icons.login_outlined, color: Appcolors.slateGray),

            const SizedBox(width: 12),

            /// MAIN TITLE
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Appcolors.blackColor,
                ),
              ),
            ),

            /// TRAILING TEXT (optional)
            if (trailingText != null && trailingText!.isNotEmpty) ...[
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  trailingText!,
                  maxLines: 2,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Appcolors.darkGreyColor,
                  ),
                ),
              ),
            ],

            const SizedBox(width: 12),

            if (isIcon)
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: Appcolors.darkGreyColor,
              ),
          ],
        ),
      ),
    );
  }
}

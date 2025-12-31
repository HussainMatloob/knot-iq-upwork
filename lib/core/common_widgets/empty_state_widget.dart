import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class EmptyStateWidget extends StatelessWidget {
  final String iconPath;
  final String heading;
  final String subheading;

  const EmptyStateWidget({
    super.key,
    required this.iconPath,
    required this.heading,
    required this.subheading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// Icon
        SvgPicture.asset(iconPath),

        SizedBox(height: 24),

        /// Heading
        Text(
          heading,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Appcolors.blackColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 12),

        /// Subheading
        Text(
          subheading,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Appcolors.darkGreyColor,
            fontSize: headdingfontSize,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

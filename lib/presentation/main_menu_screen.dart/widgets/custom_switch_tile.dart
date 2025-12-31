import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:knot_iq/core/common_widgets/switch_button.dart';
import 'package:knot_iq/utils/colors.dart';

class CustomSwitchTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  const CustomSwitchTile({
    super.key,
    required this.iconPath,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Appcolors.whiteColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(iconPath),
          const SizedBox(width: 12),

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
          const SizedBox(width: 8),

          CustomSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

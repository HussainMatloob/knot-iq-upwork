import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:knot_iq/utils/colors.dart';

class CustomBottomBarItems extends StatelessWidget {
  final int itemKey;
  final String iconPath;
  final String activeIconPath;
  final String label;
  final int currentIndex;
  final Function(int) onTap;
  const CustomBottomBarItems({
    super.key,
    required this.itemKey,
    required this.iconPath,
    required this.activeIconPath,
    required this.label,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = currentIndex == itemKey;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(itemKey),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const SizedBox(height: 12),
              // Icon
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isSelected
                      ? Appcolors.naviBlue
                      : Appcolors.transparentColor,
                ),
                child: SvgPicture.asset(
                  height: 24,
                  width: 24,
                  isSelected ? activeIconPath : iconPath,
                  colorFilter: ColorFilter.mode(
                    isSelected
                        ? Appcolors.primaryColor
                        : Appcolors.darkGreyColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Label
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Appcolors.blackColor
                      : Appcolors.darkGreyColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

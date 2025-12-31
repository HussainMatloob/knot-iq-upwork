import 'package:flutter/material.dart';
import 'package:knot_iq/utils/colors.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeThumbColor;
  final Color activeTrackColor;
  final Color inactiveThumbColor;
  final Color inactiveTrackColor;
  final EdgeInsetsGeometry padding;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeThumbColor = Appcolors.whiteColor,
    this.activeTrackColor = Appcolors.primaryColor,
    this.inactiveThumbColor = Colors.white,
    this.inactiveTrackColor = Colors.grey,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Switch(
        value: value,
        onChanged: onChanged,
        padding: padding,
        activeThumbColor: activeThumbColor,
        activeTrackColor: activeTrackColor,
        inactiveThumbColor: inactiveThumbColor,
        inactiveTrackColor: inactiveTrackColor,
      ),
    );
  }
}

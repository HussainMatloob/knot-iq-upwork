import 'package:flutter/material.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class ActionButton extends StatelessWidget {
  final String buttonText;
  final TextStyle textStyle;
  final double height;
  final double width;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    this.buttonText = "Submit",
    this.textStyle = const TextStyle(
      fontSize: bodyfontSize,
      fontWeight: FontWeight.w600,
      color: Appcolors.whiteColor,
    ),
    this.height = 51,
    this.width = double.infinity,
    this.backgroundColor = Appcolors.primaryColor,
    this.borderColor = Appcolors.transparentColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Appcolors.transparentColor,
      child: InkWell(
        splashColor: Appcolors.blackColor.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: backgroundColor,
            border: Border.all(color: borderColor),
          ),
          child: Center(child: Text(buttonText, style: textStyle)),
        ),
      ),
    );
  }
}

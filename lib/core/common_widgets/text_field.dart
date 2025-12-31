import 'package:flutter/material.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hintText;
  final TextStyle? hintStyle;
  final Color fillColor;
  final void Function(String)? onChanged;
  final EdgeInsetsGeometry contentPadding;
  final double borderRadius;
  final bool autofocus;
  final Widget? prefix;
  final Widget? suffix;
  final bool isMultiline; // 👈 new option
  final double? styleFontSize;

  const CustomSearchField({
    super.key,
    this.focusNode,
    this.controller,
    this.hintText = 'Search...',
    this.hintStyle,
    this.fillColor = Colors.white,
    this.onChanged,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 10.0,
      horizontal: 10,
    ),
    this.borderRadius = 10.0,
    this.autofocus = false,
    this.prefix,
    this.suffix,
    this.isMultiline = false, // default false
    this.styleFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isMultiline ? null : 50, // use dynamic height if multiline
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        minLines: isMultiline ? 4 : 1, // minimum lines for multiline
        maxLines: isMultiline ? null : 1, // unlimited lines if multiline
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              hintStyle ??
              TextStyle(
                fontSize: styleFontSize ?? headdingfontSize,
                color: Appcolors.darkGreyColor,
                fontWeight: FontWeight.w400,
              ),
          prefixIcon: prefix,
          suffixIcon: suffix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: fillColor,
          contentPadding: contentPadding,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

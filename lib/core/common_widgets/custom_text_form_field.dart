import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class CustomTextFormField extends StatefulWidget {
  final String? iconPath;
  final String hint;
  final Widget? suffixWidget;
  final VoidCallback? suffixTapAction;
  final Icon? icon;
  final VoidCallback? obSecureTap;
  final bool? isObSecure;
  final String? Function(String?)? validateFunction;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final int? multiLine;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Color fillColor;
  final Color hintTextColor;
  final Color iconColor;
  final Color editTextColor;
  final bool isReedOnly;

  CustomTextFormField({
    super.key,
    this.iconPath,
    required this.hint,
    this.suffixWidget,
    this.suffixTapAction,
    this.icon,
    this.obSecureTap,
    this.isObSecure,
    this.validateFunction,
    this.controller,
    this.onTap,
    this.multiLine,
    this.keyboardType,
    this.inputFormatters,
    this.fillColor = Colors.white,
    this.hintTextColor = Appcolors.darkGreyColor,
    this.iconColor = Colors.grey,
    this.editTextColor = Appcolors.blackColor,
    this.isReedOnly = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType ?? TextInputType.text,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.multiLine ?? 1,
      onTap: widget.onTap,
      controller: widget.controller,
      validator: widget.validateFunction,
      obscureText: widget.isObSecure ?? false,
      cursorColor: Appcolors.primaryColor,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        prefixIcon: widget.iconPath != null
            ? Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 5,
                  bottom: 16,
                  top: 16,
                ),
                child: SvgPicture.asset(
                  widget.iconPath ?? "",
                  semanticsLabel: '',
                ),
              )
            : null,
        // ↓ Remove extra space when prefixIcon is null
        prefixIconConstraints: widget.iconPath != null
            ? const BoxConstraints(minWidth: 0, minHeight: 0)
            : const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon:
            widget.suffixWidget ??
            (widget.suffixTapAction != null
                ? InkWell(onTap: widget.suffixTapAction, child: widget.icon)
                : widget.obSecureTap != null
                ? InkWell(
                    onTap: widget.obSecureTap,
                    child: widget.isObSecure!
                        ? Icon(
                            Icons.visibility_off_outlined,
                            color: widget.iconColor,
                          )
                        : Icon(Icons.remove_red_eye, color: widget.iconColor),
                  )
                : null),
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: widget.hintTextColor,
          fontSize: headdingfontSize,
          fontWeight: FontWeight.w400,
        ),

        //  Move all container styling here
        filled: true,
        fillColor: widget.fillColor,

        // Shadow & radius effect
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Appcolors.primaryColor,
            width: 1.6,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.6),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.6),
        ),

        contentPadding: EdgeInsets.symmetric(
          horizontal: widget.iconPath != null ? 16 : 10,
          vertical: 12,
        ),
      ),
      style: TextStyle(fontSize: headdingfontSize, color: widget.editTextColor),
      readOnly: widget.isReedOnly,
    );
  }
}

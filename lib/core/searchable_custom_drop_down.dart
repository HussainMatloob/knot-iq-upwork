import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knot_iq/main.dart';
import 'package:knot_iq/utils/colors.dart';

class SearchAbleCustomDropDownButton<T extends GetxController>
    extends StatefulWidget {
  final double? dropDownListTextSize;
  final double? height;
  final double? width;
  final Color? textColor;
  final double? textSize;
  final FontWeight? textFw;
  final List<String>? dropDownButtonList;
  final String? text;
  final bool? isShowingCustomNames;
  final T controller;
  final String? selectedValue;
  final String valueType;
  final Color? buttonColor;
  final String? color;
  final String? icon;

  const SearchAbleCustomDropDownButton({
    super.key,
    this.dropDownButtonList,
    this.text,
    this.height,
    this.width,
    this.textColor,
    this.textSize,
    this.textFw,
    this.isShowingCustomNames = false,
    this.dropDownListTextSize,
    required this.controller,
    required this.selectedValue,
    required this.valueType,
    this.buttonColor,
    this.color,
    this.icon,
  });
  @override
  State<SearchAbleCustomDropDownButton> createState() =>
      _SearchAbleCustomDropDownButtonState<T>();
}

class _SearchAbleCustomDropDownButtonState<T extends GetxController>
    extends State<SearchAbleCustomDropDownButton<T>> {
  late MediaQueryData mediaQuery;

  @override
  Widget build(BuildContext context) {
    // Convert hex string to Color
    Color containerColor = Appcolors.lavenderGray; // default color
    try {
      if (widget.color != null) {
        containerColor = Color(
          int.parse(widget.color!.replaceFirst("#", "0x")),
        );
      }
    } catch (_) {}
    mq = MediaQuery.sizeOf(context);
    return GetBuilder<T>(
      init: widget.controller,
      builder: (dropDownController) {
        final customController = dropDownController as dynamic;

        return Container(
          decoration: BoxDecoration(
            color: widget.buttonColor ?? Appcolors.whiteColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownSearch<String>(
            selectedItem: widget.selectedValue,
            onChanged: (value) {
              customController.selectValueFromSearchAbleDropDown(
                widget.valueType,
                value,
              );
            },
            items: (filter, _) => widget.dropDownButtonList!
                .where(
                  (item) => item.toLowerCase().contains(filter.toLowerCase()),
                )
                .toList(),

            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                hintText: widget.text,
                hintStyle: TextStyle(
                  fontSize: widget.textSize,
                  color: widget.textColor,
                  fontWeight: widget.textFw,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Center(
                        child: SizedBox(
                          width: 15,
                          height: 15,
                          child: Image.network(
                            "http://51.20.212.163:8906${widget.icon}",
                            fit: BoxFit
                                .cover, // <-- FIX: force same size, crop extra area
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                  child: SizedBox(
                                    width: 15, // smaller width
                                    height: 15, // smaller height
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2, // thin line
                                      color: Appcolors.whiteColor, // your color
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.image,
                                size: 15,
                                color: Appcolors.darkGreyColor,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Container(
                  //   padding: EdgeInsets.all(5),
                  //   decoration: BoxDecoration(
                  //     color: Appcolors.redColor.withAlpha(10),
                  //     borderRadius: BorderRadius.circular(6),
                  //   ),
                  //   child: SvgPicture.asset(
                  //     AssetPath.walletIcon,
                  //     colorFilter: const ColorFilter.mode(
                  //       Appcolors.redColor,
                  //       BlendMode.srcIn,
                  //     ),
                  //   ),
                  // ),
                ),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.transparent, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.transparent, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Appcolors.primaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),
            popupProps: PopupProps.menu(
              showSearchBox: true,
              itemBuilder: (context, item, isDisabled, isSelected) {
                return ListTile(
                  title: Text(
                    item,
                    style: TextStyle(fontSize: 12, color: Appcolors.blackColor),
                  ),
                );
              },

              fit: FlexFit.loose,
              constraints: BoxConstraints(),
              containerBuilder: (ctx, popupWidget) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Material(
                    color: Appcolors.whiteColor,
                    child: popupWidget,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

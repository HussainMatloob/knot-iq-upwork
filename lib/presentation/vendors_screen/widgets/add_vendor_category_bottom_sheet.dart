import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:get/get.dart';
import 'package:knot_iq/controllers/vendor_controller.dart';
import 'package:knot_iq/core/common_widgets/bottom_sheet.dart';
import 'package:knot_iq/core/common_widgets/custom_delete_dialog.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/models/category_data_model.dart';
import 'package:knot_iq/presentation/vendors_screen/widgets/choose_image_source_bottom_sheet.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class AddVendorCategoryBottomSheet extends StatefulWidget {
  final bool isUpdate;
  CategoriesDataModel? categoryData;
  final String? id;
  AddVendorCategoryBottomSheet({
    super.key,
    this.isUpdate = false,
    this.categoryData,
    this.id,
  });

  @override
  State<AddVendorCategoryBottomSheet> createState() =>
      _AddVendorCategoryBottomSheetState();
}

class _AddVendorCategoryBottomSheetState
    extends State<AddVendorCategoryBottomSheet> {
  VendorController vendorController = Get.put(VendorController());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorController>(
      builder: (vendorController) {
        return Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// LEFT - Cancel
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!.cancelText,
                          style: const TextStyle(
                            color: Appcolors.blackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    /// CENTER - TITLE (Flexible + Ellipsis)
                    Expanded(
                      child: Text(
                        widget.isUpdate
                            ? AppLocalizations.of(context)!.updateCategory
                            : AppLocalizations.of(context)!.addCategory,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Appcolors.blackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    /// RIGHT - Save / Update / Loader
                    vendorController.isCategoryAdd ||
                            vendorController.isCategoryUpdatae
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Appcolors.primary2Color,
                                ),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                if (widget.isUpdate) {
                                  vendorController.updateCategory(
                                    context,
                                    widget.id ?? "",
                                  );
                                } else {
                                  vendorController.addCategory(context);
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.isUpdate
                                    ? AppLocalizations.of(context)!.updateText
                                    : AppLocalizations.of(context)!.saveText,
                                style: TextStyle(
                                  color: Appcolors.primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),

                SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.categoryTitle,
                  style: TextStyle(
                    color: Appcolors.darkGreyColor,
                    fontSize: bodyfontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 6),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: vendorController.categoryController,
                  validator: (value) =>
                      vendorController.taskTitleValidate(value, context),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.categoryHint,
                    hintStyle: TextStyle(
                      color: Appcolors.darkGreyColor,
                      fontSize: headdingfontSize,
                      fontWeight: FontWeight.w400,
                    ),

                    filled: true,
                    fillColor: Appcolors.whiteColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),

                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Appcolors.redColor,
                        width: 1.5,
                      ),
                    ),

                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Appcolors.redColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.supplierText,
                  style: TextStyle(
                    color: Appcolors.darkGreyColor,
                    fontSize: bodyfontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),

                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      vendorController.supplierNameValidate(value, context),
                  controller: vendorController.supplierController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.supplerHint,
                    hintStyle: TextStyle(
                      color: Appcolors.darkGreyColor,
                      fontSize: headdingfontSize,
                      fontWeight: FontWeight.w400,
                    ),

                    filled: true,
                    fillColor: Appcolors.whiteColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),

                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Appcolors.redColor,
                        width: 1.5,
                      ),
                    ),

                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Appcolors.redColor,
                        width: 1.5,
                      ),
                    ),

                    prefixIcon: InkWell(
                      onTap: () {
                        showCustomBottomSheet(
                          minChildSize: 0.3,
                          context: context,
                          initialChildSize: 0.3,
                          maxChildSize: 0.4,
                          child: ChooseImageSourceBottomSheet(),
                        );
                      },
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Appcolors.purpleColor.withAlpha(30),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Appcolors.blueColor,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // =================== OPEN COLOR PICKER ===================
                Text(
                  AppLocalizations.of(context)!.colorText,
                  style: TextStyle(
                    color: Appcolors.darkGreyColor,
                    fontSize: bodyfontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 6),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        Color tempColor = vendorController.selectedColor;
                        return Dialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              5,
                            ), // Border radius 5
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                              20,
                            ), // Dialog inner padding
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.colorHint,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Color Picker
                                  SingleChildScrollView(
                                    child: ColorPicker(
                                      pickerColor: tempColor,
                                      onColorChanged: (color) =>
                                          tempColor = color,
                                      enableAlpha: false,
                                      labelTypes: const [],
                                      pickerAreaHeightPercent: 0.8,
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Buttons Row
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.cancelText,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      const SizedBox(width: 10),
                                      TextButton(
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.selectText,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        onPressed: () {
                                          vendorController.updateColor(
                                            tempColor,
                                          );
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 48,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Appcolors.whiteColor,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Appcolors.purpleColor.withAlpha(30),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.color_lens,
                              color: Appcolors.blueColor,
                              size: 15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          AppLocalizations.of(context)!.colorHint,
                          style: TextStyle(
                            color: Appcolors.darkGreyColor,
                            fontSize: headdingfontSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  height: 100,
                  width: 600,
                  color: vendorController.selectedColor,
                ),

                const SizedBox(height: 20),

                widget.isUpdate
                    ? vendorController.isCategoryDelete
                          ? Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Appcolors.redColor,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                customDeleteDialog(
                                  context,
                                  onTap: () {
                                    Navigator.pop(context);
                                    vendorController.deleteCategory(
                                      context,
                                      widget.id ?? "",
                                    );
                                  },
                                );
                              },
                              child: Container(
                                height: 50,
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Appcolors.redColor.withAlpha(20),
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.deleteText,
                                    style: TextStyle(
                                      color: Appcolors.redColor,
                                      fontSize: headdingfontSize,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }
}

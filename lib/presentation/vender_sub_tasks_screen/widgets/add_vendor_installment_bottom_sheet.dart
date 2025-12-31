import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/vendor_sub_task_controller.dart';
import 'package:knot_iq/core/common_widgets/custom_text_form_field.dart';
import 'package:knot_iq/core/common_widgets/switch_button.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';
import 'package:knot_iq/utils/date_helper.dart';

class AddVendorInstallmentBottomSheet extends StatefulWidget {
  final bool isUpdate;
  final int index;
  const AddVendorInstallmentBottomSheet({
    super.key,
    required this.isUpdate,
    required this.index,
  });

  @override
  State<AddVendorInstallmentBottomSheet> createState() =>
      _AddInstallmentBottomSheetState();
}

class _AddInstallmentBottomSheetState
    extends State<AddVendorInstallmentBottomSheet> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  VendorSubTaskController vendorSubTaskController = Get.put(
    VendorSubTaskController(),
  );
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: GetBuilder<VendorSubTaskController>(
        builder: (vendorSubTaskController) {
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
                              ? AppLocalizations.of(context)!.updateText
                              : AppLocalizations.of(context)!.addText,
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
                      InkWell(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            vendorSubTaskController
                                .addOrUpdateVendorInstallment(
                                  context,
                                  widget.isUpdate,
                                  index: widget.index,
                                );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.isUpdate
                                ? AppLocalizations.of(context)!.updateText
                                : AppLocalizations.of(context)!.saveText,
                            style: const TextStyle(
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
                    AppLocalizations.of(context)!.amountText,
                    style: TextStyle(
                      color: Appcolors.darkGreyColor,
                      fontSize: bodyfontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 6),
                  CustomTextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,100}$'),
                      ),
                    ],
                    validateFunction: (value) => vendorSubTaskController
                        .installmentAmountValidate(value, context),
                    hint: "\$0.0",
                    controller:
                        vendorSubTaskController.installmentAmountController,
                  ),

                  const SizedBox(height: 20),
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Appcolors.whiteColor,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AssetPath.tagIcon,
                          colorFilter: const ColorFilter.mode(
                            Appcolors.primaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.paidText,
                          style: TextStyle(
                            color: Appcolors.darkGreyColor,
                            fontSize: headdingfontSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        CustomSwitch(
                          value: vendorSubTaskController.isInstallmentPaid,
                          onChanged: (value) {
                            vendorSubTaskController.setInstalmentPaid(value);
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        flex: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.startDate,
                              style: TextStyle(
                                color: Appcolors.darkGreyColor,
                                fontSize: bodyfontSize,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: () async {
                                vendorSubTaskController.pickDateTime(
                                  context,
                                  isStart: true,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 12,
                                ),
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Appcolors.whiteColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        vendorSubTaskController
                                                    .selectedStartDateTime ==
                                                null
                                            ? DateHelper.formatStringToDisplay(
                                                DateTime.now()
                                                    .toUtc()
                                                    .toIso8601String(),
                                              )
                                            : DateHelper.formatStringToDisplay(
                                                vendorSubTaskController
                                                    .selectedStartDateTime,
                                              ),
                                        style: TextStyle(
                                          color:
                                              vendorSubTaskController
                                                      .selectedStartDateTime ==
                                                  null
                                              ? Appcolors.darkGreyColor
                                              : Appcolors.blackColor,
                                          fontSize: bodyfontSize,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SvgPicture.asset(AssetPath.calendarIcon),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.dueDate,
                              style: TextStyle(
                                color: Appcolors.darkGreyColor,
                                fontSize: bodyfontSize,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: () async {
                                vendorSubTaskController.pickDateTime(context);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 12,
                                ),
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Appcolors.whiteColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        vendorSubTaskController
                                                    .selectedEndDateTime ==
                                                null
                                            ? DateHelper.formatStringToDisplay(
                                                DateTime.now()
                                                    .toUtc()
                                                    .toIso8601String(),
                                              )
                                            : DateHelper.formatStringToDisplay(
                                                vendorSubTaskController
                                                    .selectedEndDateTime,
                                              ),
                                        style: TextStyle(
                                          color:
                                              vendorSubTaskController
                                                      .selectedEndDateTime ==
                                                  null
                                              ? Appcolors.darkGreyColor
                                              : Appcolors.blackColor,
                                          fontSize: bodyfontSize,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SvgPicture.asset(AssetPath.calendarIcon),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    height: 50,
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Appcolors.whiteColor,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AssetPath.flagIcon,
                          colorFilter: const ColorFilter.mode(
                            Appcolors.redColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.taskRemindMe,
                          style: TextStyle(
                            color: Appcolors.darkGreyColor,
                            fontSize: headdingfontSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        CustomSwitch(
                          value: vendorSubTaskController.isInstallmentRemindMe,
                          onChanged: (value) {
                            vendorSubTaskController.setInstallmentRemindMe(
                              value,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.note,
                    style: TextStyle(
                      color: Appcolors.darkGreyColor,
                      fontSize: bodyfontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 6),
                  CustomTextFormField(
                    validateFunction: (value) => vendorSubTaskController
                        .installmentNoteValidate(value, context),
                    hint: AppLocalizations.of(context)!.installmentNoteHintText,
                    controller:
                        vendorSubTaskController.installmentNoteController,
                  ),
                  SizedBox(height: widget.isUpdate ? 20 : 0),
                  widget.isUpdate
                      ? GestureDetector(
                          onTap: () {
                            vendorSubTaskController.removeInstallment(
                              widget.index,
                              context,
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
                      : SizedBox(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

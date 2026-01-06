import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/expense_controller.dart';
import 'package:knot_iq/core/common_widgets/custom_text_form_field.dart';
import 'package:knot_iq/core/common_widgets/switch_button.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';
import 'package:knot_iq/utils/date_helper.dart';

class AddInstallmentBottomSheet extends StatefulWidget {
  final bool isUpdate;
  final int? index;
  const AddInstallmentBottomSheet({
    super.key,
    required this.isUpdate,
    this.index,
  });

  @override
  State<AddInstallmentBottomSheet> createState() =>
      _AddInstallmentBottomSheetState();
}

class _AddInstallmentBottomSheetState extends State<AddInstallmentBottomSheet> {
  ExpenseController expenseController = Get.put(ExpenseController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpenseController>(
      builder: (expenseController) {
        return Form(
          key: formKey,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// CENTER - TITLE (Flexible + Ellipsis)
                      Text(
                        widget.isUpdate
                            ? AppLocalizations.of(context)!.updateInstallment
                            : AppLocalizations.of(context)!.addInstallment,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Appcolors.blackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

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
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+$')),
                    ],
                    validateFunction: (value) =>
                        expenseController.amountValidate(value, context),
                    hint: "${AppLocalizations.of(context)!.currencySymbol}${0}",
                    controller: expenseController.installmentAmountController,
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
                          value: expenseController.isPaid,
                          onChanged: (value) {
                            expenseController.paidSwitch(value);
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    AppLocalizations.of(context)!.paymentDate,
                    style: TextStyle(
                      color: Appcolors.darkGreyColor,
                      fontSize: bodyfontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () async {
                      expenseController.selectInstallmentDate(context);
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              expenseController.selectedDateTime == null
                                  ? DateHelper.formatStringToDisplay(
                                      DateTime.now().toUtc().toIso8601String(),
                                    )
                                  : DateHelper.formatStringToDisplay(
                                      expenseController.selectedDateTime,
                                    ),
                              style: TextStyle(
                                color:
                                    expenseController.selectedDateTime == null
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
                          value: expenseController.isRemindMe,
                          onChanged: (value) {
                            expenseController.remindMeSwitch(value);
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
                    validateFunction: (value) =>
                        expenseController.noteValidate(value, context),
                    hint: AppLocalizations.of(context)!.noteHint,
                    controller: expenseController.installmentNoteController,
                  ),

                  SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.isUpdate
                          ? Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  expenseController.removeInstallment(
                                    widget.index!,
                                    context,
                                  );
                                },
                                child: Container(
                                  height: 40,
                                  padding: EdgeInsets.all(8),
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
                              ),
                            )
                          : const SizedBox.shrink(),
                      Visibility(
                        visible: widget.isUpdate,
                        child: SizedBox(width: 30),
                      ),

                      /// RIGHT - Save / Update / Loader
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              expenseController.addOrUpdateBudgetInstallment(
                                context,
                                widget.isUpdate,
                                index: widget.index,
                              );
                            }
                          },
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.all(8),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Appcolors.primary2Color,
                            ),
                            child: Center(
                              child: Text(
                                widget.isUpdate
                                    ? AppLocalizations.of(context)!.updateText
                                    : AppLocalizations.of(context)!.saveText,
                                style: const TextStyle(
                                  color: Appcolors.whiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

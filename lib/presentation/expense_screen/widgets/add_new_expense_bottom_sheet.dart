import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/expense_controller.dart';
import 'package:knot_iq/core/common_widgets/bottom_sheet.dart';
import 'package:knot_iq/core/common_widgets/custom_delete_dialog.dart';
import 'package:knot_iq/core/common_widgets/custom_text_form_field.dart';
import 'package:knot_iq/core/searchable_custom_drop_down.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/models/expense_data_model.dart';
import 'package:knot_iq/presentation/expense_screen/widgets/add_installment_bottom_sheet.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';
import 'package:knot_iq/utils/date_helper.dart';

class AddNewExpenseBottomSheet extends StatefulWidget {
  final ExpenseDataModel? expense;
  final bool isUpdate;
  const AddNewExpenseBottomSheet({
    super.key,
    this.isUpdate = false,
    this.expense,
  });

  @override
  State<AddNewExpenseBottomSheet> createState() =>
      _AddNewExpenseBottomSheetState();
}

class _AddNewExpenseBottomSheetState extends State<AddNewExpenseBottomSheet> {
  ExpenseController expenseController = Get.put(ExpenseController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      expenseController.getCategoryData(widget.isUpdate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: formKey,
        child: GetBuilder<ExpenseController>(
          builder: (expenseController) {
            return Container(
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
                            ? AppLocalizations.of(context)!.updateExpense
                            : AppLocalizations.of(context)!.newExpense,
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
                    controller: expenseController.amountController,
                  ),

                  const SizedBox(height: 20),

                  DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      color: Appcolors.darkGreyColor, // border color
                      strokeWidth: 1.0, // border thickness
                      dashPattern: [6, 6], // 6px line, 3px gap
                      radius: Radius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        expenseController.clearOrInitializeInstallmentFields(
                          false,
                        );
                        showCustomBottomSheet(
                          minChildSize: 0.8,
                          context: context,
                          initialChildSize: 0.8,
                          maxChildSize: 0.9,
                          child: AddInstallmentBottomSheet(isUpdate: false),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        // padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white, // your container color
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Appcolors.darkGreyColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                AppLocalizations.of(context)!.addInstallment,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Appcolors.darkGreyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  expenseController.budgetInstallments.isEmpty
                      ? SizedBox()
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.addPaymentText,
                                  style: TextStyle(
                                    color: Appcolors.darkGreyColor,
                                    fontSize: bodyfontSize,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    expenseController.clearBudgetInstallments();
                                  },
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.deletePaymentText,

                                    style: TextStyle(
                                      color: Appcolors.redColor,
                                      fontSize: bodyfontSize,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  expenseController.budgetInstallments.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    expenseController
                                        .clearOrInitializeInstallmentFields(
                                          true,
                                          installment: expenseController
                                              .budgetInstallments[index],
                                        );
                                    showCustomBottomSheet(
                                      minChildSize: 0.8,
                                      context: context,
                                      initialChildSize: 0.8,
                                      maxChildSize: 0.9,
                                      child: AddInstallmentBottomSheet(
                                        isUpdate: true,
                                        index: index,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Appcolors.grey4Color,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                "${expenseController.budgetInstallments[index]["note"]}",
                                                style: TextStyle(
                                                  color:
                                                      Appcolors.darkGreyColor,
                                                  fontSize: bodyfontSize,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 20),

                                            Flexible(
                                              child: Text(
                                                "${AppLocalizations.of(context)!.currencySymbol}${expenseController.budgetInstallments[index]["amount"].toString()}",
                                                style: TextStyle(
                                                  color:
                                                      Appcolors.darkGreyColor,
                                                  fontSize: bodyfontSize,
                                                  fontWeight: FontWeight.w400,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${AppLocalizations.of(context)!.dateText}: ${DateHelper.formatStringToDisplay(expenseController.budgetInstallments[index]["startDate"])}",
                                              style: TextStyle(
                                                color: Appcolors.darkGreyColor,
                                                fontSize: bodyfontSize,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              expenseController
                                                          .budgetInstallments[index]["isPaid"] ==
                                                      true
                                                  ? AppLocalizations.of(
                                                      context,
                                                    )!.paidText
                                                  : AppLocalizations.of(
                                                      context,
                                                    )!.unPaidText,
                                              style: TextStyle(
                                                color: Appcolors.darkGreyColor,
                                                fontSize: bodyfontSize,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.expenseTitleText,
                    style: TextStyle(
                      color: Appcolors.darkGreyColor,
                      fontSize: bodyfontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 6),
                  CustomTextFormField(
                    validateFunction: (value) =>
                        expenseController.expenseTitleValidate(value, context),
                    hint: AppLocalizations.of(context)!.hintTextTitle,
                    controller: expenseController.expenseTitleController,
                  ),

                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.categoryText,
                    style: TextStyle(
                      color: Appcolors.darkGreyColor,
                      fontSize: bodyfontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SearchAbleCustomDropDownButton(
                    selectedValue: expenseController.selectedCategory,
                    dropDownButtonList: expenseController.categories,
                    text: AppLocalizations.of(context)!.categoryHint,
                    textColor: Appcolors.darkGreyColor,
                    textSize: 16,
                    textFw: FontWeight.w400,
                    controller: expenseController,
                    valueType: "Category",
                    icon: expenseController.categoryIcon,
                    color: expenseController.categoryColor,
                  ),

                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.descriptionText,
                    style: TextStyle(
                      color: Appcolors.darkGreyColor,
                      fontSize: bodyfontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 6),
                  CustomTextFormField(
                    multiLine: 4,
                    // validateFunction: (value) =>
                    //     expenseController.noteValidate(value, context),
                    hint: AppLocalizations.of(context)!.hintTextDescription,
                    controller: expenseController.noteController,
                  ),

                  SizedBox(height: 30),

                  expenseController.isBudgetAdd ||
                          expenseController.isBudgetUpdate ||
                          expenseController.isExpenseDelete
                      ? Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: expenseController.isExpenseDelete
                                  ? Appcolors.redColor
                                  : Appcolors.primary2Color,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.isUpdate
                                ? Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        customDeleteDialog(
                                          context,
                                          onTap: () {
                                            Navigator.pop(context);
                                            expenseController.deleteExpense(
                                              context,
                                              widget.expense!,
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        height: 40,
                                        padding: EdgeInsets.all(8),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color: Appcolors.redColor.withAlpha(
                                            20,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.deleteText,
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
                                    if (widget.isUpdate) {
                                      expenseController.updateBudgetExpense(
                                        context,
                                        widget.expense!,
                                      );
                                    } else {
                                      expenseController.addBudgetExpense(
                                        context,
                                      );
                                    }
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
                                          ? AppLocalizations.of(
                                              context,
                                            )!.updateText
                                          : AppLocalizations.of(
                                              context,
                                            )!.saveText,
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
            );
          },
        ),
      ),
    );
  }
}

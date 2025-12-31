import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/vendor_sub_task_controller.dart';
import 'package:knot_iq/core/common_widgets/bottom_sheet.dart';
import 'package:knot_iq/core/common_widgets/custom_delete_dialog.dart';
import 'package:knot_iq/core/common_widgets/custom_text_form_field.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/models/category_data_model.dart';
import 'package:knot_iq/models/vendor_expenses_model.dart';
import 'package:knot_iq/presentation/vender_sub_tasks_screen/documents_screen.dart';
import 'package:knot_iq/presentation/vender_sub_tasks_screen/widgets/add_vendor_installment_bottom_sheet.dart';
import 'package:knot_iq/presentation/vender_sub_tasks_screen/widgets/document_widget_card.dart';

import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';
import 'package:knot_iq/utils/date_helper.dart';

class AddVendorNewExpenseBottomSheet extends StatefulWidget {
  final CategoriesDataModel cateGoryData;
  final VendorExpensesModel? vendorData;
  final bool isUpdate;
  const AddVendorNewExpenseBottomSheet({
    super.key,
    required this.cateGoryData,
    this.vendorData,
    this.isUpdate = false,
  });

  @override
  State<AddVendorNewExpenseBottomSheet> createState() =>
      _AddNewExpenseBottomSheetState();
}

class _AddNewExpenseBottomSheetState
    extends State<AddVendorNewExpenseBottomSheet> {
  VendorSubTaskController vendorSubTaskController = Get.put(
    VendorSubTaskController(),
  );

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorSubTaskController>(
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
                        widget.cateGoryData.name ?? "",
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
                          if (widget.isUpdate) {
                            vendorSubTaskController.updateVendorExpense(
                              context,
                              widget.cateGoryData,
                              widget.vendorData!,
                            );
                          } else {
                            vendorSubTaskController.addVendorExpense(
                              context,
                              widget.cateGoryData,
                            );
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            vendorSubTaskController.isExpenseAdd ||
                                vendorSubTaskController.isVendorUpdate
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
                            : Text(
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
                  "${widget.cateGoryData.name ?? ""} ${AppLocalizations.of(context)!.nameText}",
                  style: TextStyle(
                    color: Appcolors.darkGreyColor,
                    fontSize: bodyfontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 6),
                CustomTextFormField(
                  validateFunction: (value) =>
                      vendorSubTaskController.venuNameValidate(value, context),
                  hint: AppLocalizations.of(context)!.enterNameHint,
                  controller: vendorSubTaskController.venuNameController,
                ),

                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.totalBudgetText,
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
                      .totalBudgetValidate(value, context),
                  hint: "\$0.0",
                  controller: vendorSubTaskController.totalBudGetController,
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
                      vendorSubTaskController
                          .clearOrInitializeInstallmentFields(false);
                      showCustomBottomSheet(
                        minChildSize: 0.2,
                        context: context,
                        initialChildSize: 0.8,
                        maxChildSize: 0.9,
                        child: AddVendorInstallmentBottomSheet(
                          isUpdate: false,
                          index: -1,
                        ),
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

                vendorSubTaskController.vendorInstallments.isEmpty
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
                                  vendorSubTaskController
                                      .clearVendorInstallments();
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
                            itemCount: vendorSubTaskController
                                .vendorInstallments
                                .length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  vendorSubTaskController
                                      .clearOrInitializeInstallmentFields(
                                        true,
                                        installment: vendorSubTaskController
                                            .vendorInstallments[index],
                                      );
                                  showCustomBottomSheet(
                                    minChildSize: 0.2,
                                    context: context,
                                    initialChildSize: 0.8,
                                    maxChildSize: 0.9,
                                    child: AddVendorInstallmentBottomSheet(
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
                                          Container(
                                            width: 245,
                                            child: Text(
                                              "${vendorSubTaskController.vendorInstallments[index]["note"]}",
                                              style: TextStyle(
                                                color: Appcolors.darkGreyColor,
                                                fontSize: bodyfontSize,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),

                                          Container(
                                            width: 50,
                                            child: Text(
                                              "\$${double.parse(vendorSubTaskController.vendorInstallments[index]["amount"].toString()).toStringAsFixed(2)}",
                                              style: TextStyle(
                                                color: Appcolors.darkGreyColor,
                                                fontSize: bodyfontSize,
                                                fontWeight: FontWeight.w400,
                                                overflow: TextOverflow.ellipsis,
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
                                            "${AppLocalizations.of(context)!.dateText}: ${DateHelper.formatStringToDisplay(vendorSubTaskController.vendorInstallments[index]["startDate"])}",
                                            style: TextStyle(
                                              color: Appcolors.darkGreyColor,
                                              fontSize: bodyfontSize,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            vendorSubTaskController
                                                        .vendorInstallments[index]["isPaid"] ==
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
                  AppLocalizations.of(context)!.contactPersonName,

                  style: TextStyle(
                    color: Appcolors.darkGreyColor,
                    fontSize: bodyfontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 6),
                CustomTextFormField(
                  validateFunction: (value) => vendorSubTaskController
                      .contactNameValidate(value, context),
                  hint: AppLocalizations.of(context)!.enterNameHint,
                  controller: vendorSubTaskController.contactNameController,
                ),

                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.contactNumber,
                  style: TextStyle(
                    color: Appcolors.darkGreyColor,
                    fontSize: bodyfontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 6),

                CustomTextFormField(
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\+?\d{0,15}$')),
                  ],
                  validateFunction: (value) => vendorSubTaskController
                      .contactNumberValidate(value, context),
                  hint: AppLocalizations.of(context)!.numberHint,
                  controller: vendorSubTaskController.contactNumberController,
                ),

                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.writeNoteText,
                  style: TextStyle(
                    color: Appcolors.darkGreyColor,
                    fontSize: bodyfontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 6),
                CustomTextFormField(
                  multiLine: 4,
                  validateFunction: (value) =>
                      vendorSubTaskController.noteValidate(value, context),
                  hint: AppLocalizations.of(context)!.noteHint,
                  controller: vendorSubTaskController.noteController,
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
                      vendorSubTaskController.pickDocument();
                      // print("clicked");
                      // showCustomBottomSheet(
                      //   minChildSize: 0.2,
                      //   context: context,
                      //   initialChildSize: 0.3,
                      //   maxChildSize: 0.4,
                      //   child: AddVendorDocumentBottomSheet(),
                      // );
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
                              AppLocalizations.of(context)!.addDocument,
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
                Text(
                  AppLocalizations.of(context)!.docSizeText,
                  style: TextStyle(
                    color: Appcolors.redColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 5),
                vendorSubTaskController.selectedDocuments.isEmpty
                    ? SizedBox()
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.attachDocText,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: Appcolors.darkGreyColor,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => DocumentsScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.seeAllText,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Appcolors.darkGreyColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          DocumentWidgetCard(
                            documents:
                                vendorSubTaskController.selectedDocuments[0],
                            isSingle: true,
                          ),
                        ],
                      ),
                SizedBox(height: widget.isUpdate ? 20 : 0),
                widget.isUpdate
                    ? vendorSubTaskController.isVendorDelete
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Appcolors.redColor,
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                customDeleteDialog(
                                  context,
                                  onTap: () {
                                    Navigator.pop(context);
                                    vendorSubTaskController.deleteVendor(
                                      context,
                                      widget.cateGoryData,
                                      widget.vendorData!,
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
                const SizedBox(height: 60),
              ],
            ),
          ),
        );
      },
    );
  }
}

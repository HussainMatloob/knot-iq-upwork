import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/vendor_sub_task_controller.dart';
import 'package:knot_iq/core/common_widgets/bottom_sheet.dart';
import 'package:knot_iq/core/common_widgets/empty_state_widget.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/models/category_data_model.dart';
import 'package:knot_iq/presentation/notification_screen/notification_screen.dart';
import 'package:knot_iq/presentation/vender_sub_tasks_screen/widgets/add_vendor_new_expense_bottom_sheet.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/color_helper.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class VenderSubTaskScreen extends StatefulWidget {
  final CategoriesDataModel categoryData;
  const VenderSubTaskScreen({super.key, required this.categoryData});

  @override
  State<VenderSubTaskScreen> createState() => _VenderSubTaskScreenState();
}

class _VenderSubTaskScreenState extends State<VenderSubTaskScreen> {
  VendorSubTaskController vendorSubTaskController = Get.put(
    VendorSubTaskController(),
  );
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vendorSubTaskController.getVendorExpenseData(
        isGetData: true,
        widget.categoryData,
      );
    });

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == 0)
        return; // prevent trigger when not scrollable

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        vendorSubTaskController.getVendorExpenseData(
          loadMore: true,
          widget.categoryData,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorSubTaskController>(
      builder: (vendorSubTaskController) {
        return Scaffold(
          backgroundColor: Appcolors.blackColor,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 35),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Platform.isAndroid
                            ? Icons.arrow_back
                            : Icons.arrow_back_ios_new_rounded,
                        color: Appcolors.whiteColor,
                        size: 24,
                      ),
                    ),
                    Text(
                      widget.categoryData.name ?? "",
                      style: TextStyle(
                        color: Appcolors.whiteColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NotificationScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        margin: EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Appcolors.darkGreyColor,
                        ),
                        child: SvgPicture.asset(
                          AssetPath.notificationActiveIcon,
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Appcolors.backgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: vendorSubTaskController.isLoadVendorExpenseData
                        ? Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Appcolors.primaryColor,
                              ),
                            ),
                          )
                        : vendorSubTaskController.vendorExpenseData.isEmpty
                        ? // // Empty state / main content
                          Center(
                            child: EmptyStateWidget(
                              iconPath: AssetPath.notFoundIcon,
                              heading:
                                  "${AppLocalizations.of(context)!.noAddedVendor} ${widget.categoryData.name}",
                              subheading:
                                  "${AppLocalizations.of(context)!.vendorEmptyScreen} ${widget.categoryData.name}.",
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: BouncingScrollPhysics(),

                            controller: _scrollController,
                            itemCount:
                                vendorSubTaskController
                                    .vendorExpenseData
                                    .length +
                                (vendorSubTaskController.hasExpenseMoreData
                                    ? 1
                                    : 0),
                            itemBuilder: (context, index) {
                              if (index <
                                  vendorSubTaskController
                                      .vendorExpenseData
                                      .length) {
                                // final expense = vendorSubTaskController
                                //     .vendorExpenseData[index];

                                num raw =
                                    vendorSubTaskController
                                        .vendorExpenseData[index]
                                        .budget
                                        .percentage ??
                                    0;

                                // Round percentage (0.5 rounds up)
                                double percent = raw.roundToDouble();
                                return GestureDetector(
                                  onTap: () {
                                    vendorSubTaskController
                                        .initializeExistingData(
                                          vendorSubTaskController
                                              .vendorExpenseData[index],
                                        );
                                    showCustomBottomSheet(
                                      minChildSize: 0.9,
                                      context: context,
                                      initialChildSize:
                                          0.9, // 95% of screen height
                                      maxChildSize: 0.9, // 95% of screen height
                                      child: AddVendorNewExpenseBottomSheet(
                                        cateGoryData: widget.categoryData,
                                        vendorData: vendorSubTaskController
                                            .vendorExpenseData[index],
                                        isUpdate: true,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 16),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Appcolors.whiteColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: ColorHelper.hexToColor(
                                                  widget.categoryData.color,
                                                ),

                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Center(
                                                  child: SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: Image.network(
                                                      "http://51.20.212.163:8906${widget.categoryData.icon}",
                                                      fit: BoxFit
                                                          .cover, // <-- FIX: force same size, crop extra area
                                                      loadingBuilder:
                                                          (
                                                            context,
                                                            child,
                                                            loadingProgress,
                                                          ) {
                                                            if (loadingProgress ==
                                                                null)
                                                              return child;
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets.all(
                                                                    5.0,
                                                                  ),
                                                              child: Center(
                                                                child: SizedBox(
                                                                  width:
                                                                      15, // smaller width
                                                                  height:
                                                                      15, // smaller height
                                                                  child: CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2, // thin line
                                                                    color: Appcolors
                                                                        .whiteColor, // your color
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return const Icon(
                                                              Icons.image,
                                                              size: 20,
                                                              color: Appcolors
                                                                  .darkGreyColor,
                                                            );
                                                          },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                widget.categoryData.name ?? "",
                                                style: TextStyle(
                                                  color: Appcolors.blackColor,
                                                  fontSize: headdingfontSize,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "${AppLocalizations.of(context)!.currencySymbol}${(vendorSubTaskController.vendorExpenseData[index].budget.total ?? 0).round()} ${AppLocalizations.of(context)!.useText}",
                                              style: TextStyle(
                                                color: Appcolors.blackColor,
                                                fontSize: headdingfontSize,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${AppLocalizations.of(context)!.budget} : ${AppLocalizations.of(context)!.currencySymbol}${(vendorSubTaskController.vendorExpenseData[index].totalBudget ?? 0).round()}",
                                              style: TextStyle(
                                                color: Appcolors.blackColor,
                                                fontSize: bodyfontSize,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "${AppLocalizations.of(context)!.currencySymbol}${(vendorSubTaskController.vendorExpenseData[index].budget.remaining ?? 0).round()} ${AppLocalizations.of(context)!.leftText}",
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Appcolors.blackColor,
                                                  fontSize: bodyfontSize,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),

                                            Text(
                                              "${(vendorSubTaskController.vendorExpenseData[index].budget.percentage ?? 0).round()}%",
                                              style: TextStyle(
                                                color: Appcolors.blackColor,
                                                fontSize: bodyfontSize,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 14),
                                        Stack(
                                          children: [
                                            Container(
                                              height: 8,
                                              width: double
                                                  .infinity, // grey bar fills parent
                                              decoration: BoxDecoration(
                                                color: Appcolors.grey2Color,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                            LayoutBuilder(
                                              builder: (context, constraints) {
                                                return Container(
                                                  height: 8,
                                                  width:
                                                      constraints.maxWidth *
                                                      (percent /
                                                          100), // fraction of grey bar
                                                  decoration: BoxDecoration(
                                                    color: Appcolors.greenColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          100,
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                // Loader at the end
                                return Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Appcolors.primaryColor,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Appcolors.primaryColor, width: 2),
            ),
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: Appcolors.primary2Color,
              shape: const CircleBorder(),
              onPressed: () {
                vendorSubTaskController.clearAllFields();
                showCustomBottomSheet(
                  minChildSize: 0.9,
                  context: context,
                  initialChildSize: 0.9, // 95% of screen height
                  maxChildSize: 0.9, // 95% of screen height
                  child: AddVendorNewExpenseBottomSheet(
                    cateGoryData: widget.categoryData,
                  ),
                );
              },
              child: const Icon(Icons.add, color: Appcolors.whiteColor),
            ),
          ),
        );
      },
    );
  }
}

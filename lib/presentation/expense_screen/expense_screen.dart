import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/expense_controller.dart';
import 'package:knot_iq/core/common_widgets/bottom_sheet.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/presentation/expense_screen/widgets/add_new_expense_bottom_sheet.dart';
import 'package:knot_iq/presentation/expense_screen/widgets/expense_detail_box.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/color_helper.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  ExpenseController expenseController = Get.put(ExpenseController());

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      expenseController.getExpenseData(isGetData: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == 0)
        return; // prevent trigger when not scrollable

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        expenseController.getExpenseData(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: GetBuilder<ExpenseController>(
        builder: (expenseController) {
          return Stack(
            children: [
              // Main content
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                decoration: const BoxDecoration(
                  color: Appcolors.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tabs
                    Row(
                      children: [
                        ExpenseDetailBox(
                          title: AppLocalizations.of(context)!.plannedText,
                          value:
                              "\$${(expenseController.budgetData?.summary.planned ?? 0.0).toStringAsFixed(1)}",
                        ),
                        SizedBox(width: 16),
                        ExpenseDetailBox(
                          title: AppLocalizations.of(context)!.spentText,
                          value:
                              "\$${(expenseController.budgetData?.summary.spent ?? 0.0).toStringAsFixed(1)}",
                        ),
                        SizedBox(width: 16),
                        ExpenseDetailBox(
                          title: AppLocalizations.of(context)!.remainingText,
                          value:
                              "\$${(expenseController.budgetData?.summary.remaining ?? 0.0).toStringAsFixed(1)}",
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Appcolors.whiteColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.overAllBudgetUsage,
                                style: TextStyle(
                                  color: Appcolors.blackColor,
                                  fontSize: bodyfontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "${(expenseController.budgetData?.summary.percentage ?? 0.0).toStringAsFixed(1)}%",
                                style: TextStyle(
                                  color: Appcolors.blackColor,
                                  fontSize: bodyfontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          Stack(
                            children: [
                              Container(
                                height: 12,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Appcolors.grey2Color,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final pct =
                                      expenseController
                                          .budgetData
                                          ?.summary
                                          .percentage ??
                                      0;
                                  final safePct = pct > 0 ? pct / 100 : 0;
                                  return Container(
                                    height: 12,
                                    width:
                                        constraints.maxWidth *
                                        safePct, // fraction of grey bar
                                    decoration: BoxDecoration(
                                      color: Appcolors.primary2Color,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "\$${(expenseController.budgetData?.summary.spent ?? 0.0).toStringAsFixed(1)} ${AppLocalizations.of(context)!.spentLowerText} \$${(expenseController.budgetData?.summary.planned ?? 0.0).toStringAsFixed(1)} ${AppLocalizations.of(context)!.plannedLowerText}",
                              style: TextStyle(
                                color: Appcolors.blackColor,
                                fontSize: bodySmallfontSize,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      AppLocalizations.of(context)!.categoryBreakDown,
                      style: TextStyle(
                        color: Appcolors.blackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    expenseController.isExpenseLoading
                        ? Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Appcolors.primaryColor,
                              ),
                            ),
                          )
                        : Expanded(
                            child: expenseController.expensData.isEmpty
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    physics: BouncingScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 20),
                                        SvgPicture.asset(
                                          AssetPath.notFoundIcon,
                                        ),
                                        SizedBox(height: 24),
                                        Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.noAddedBudget,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Appcolors.blackColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.budgetEmptyScreenMessage,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Appcolors.darkGreyColor,
                                            fontSize: headdingfontSize,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    controller: _scrollController,
                                    itemCount:
                                        expenseController.expensData.length +
                                        (expenseController.hasExpenseMoreData
                                            ? 1
                                            : 0),
                                    itemBuilder: (context, index) {
                                      if (index <
                                          expenseController.expensData.length) {
                                        final expense =
                                            expenseController.expensData[index];
                                        num raw =
                                            expense.budget.percentage ?? 0;

                                        // Round percentage (0.5 rounds up)
                                        double percent = raw.roundToDouble();
                                        // Convert hex string to Color

                                        return GestureDetector(
                                          onTap: () {
                                            expenseController
                                                .initializeExistingDataForUpdate(
                                                  expense,
                                                );
                                            showCustomBottomSheet(
                                              minChildSize: 0.2,
                                              context: context,
                                              initialChildSize: 0.8,
                                              maxChildSize: 0.9,
                                              child: AddNewExpenseBottomSheet(
                                                expense: expense,
                                                isUpdate: true,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 16),
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Appcolors.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                                                        color:
                                                            ColorHelper.hexToColor(
                                                              expense
                                                                  .categoryId
                                                                  .color,
                                                            ),

                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        child: Center(
                                                          child: SizedBox(
                                                            width: 30,
                                                            height: 30,
                                                            child: Image.network(
                                                              "http://51.20.212.163:8906${expense.categoryId.icon}",
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
                                                                            color:
                                                                                Appcolors.whiteColor, // your color
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
                                                                      Icons
                                                                          .image,
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
                                                        expense.title ?? "",
                                                        style: TextStyle(
                                                          color: Appcolors
                                                              .blackColor,
                                                          fontSize:
                                                              headdingfontSize,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      "\$${(expense.budget.spent ?? 0).toStringAsFixed(2)} ${AppLocalizations.of(context)!.useText}",
                                                      style: TextStyle(
                                                        color: Appcolors
                                                            .blackColor,
                                                        fontSize:
                                                            headdingfontSize,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${AppLocalizations.of(context)!.budget} : \$${(expense.budget.total ?? 0).toStringAsFixed(2)}",
                                                      style: TextStyle(
                                                        color: Appcolors
                                                            .blackColor,
                                                        fontSize: bodyfontSize,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),

                                                    Text(
                                                      "\$${(expense.budget.remaining ?? 0).toStringAsFixed(2)} ${AppLocalizations.of(context)!.leftText}",
                                                      style: TextStyle(
                                                        color: Appcolors
                                                            .blackColor,
                                                        fontSize: bodyfontSize,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${expense.budget.percentage}%",
                                                      style: TextStyle(
                                                        color: Appcolors
                                                            .blackColor,
                                                        fontSize: bodyfontSize,
                                                        fontWeight:
                                                            FontWeight.w400,
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
                                                        color: Appcolors
                                                            .grey2Color,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              100,
                                                            ),
                                                      ),
                                                    ),
                                                    LayoutBuilder(
                                                      builder: (context, constraints) {
                                                        return Container(
                                                          height: 8,
                                                          width:
                                                              constraints
                                                                  .maxWidth *
                                                              (percent /
                                                                  100), // fraction of grey bar
                                                          decoration: BoxDecoration(
                                                            color: Appcolors
                                                                .greenColor,
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
                  ],
                ),
              ),

              // Floating Action Button
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Appcolors.primaryColor, width: 2),
                  ),
                  child: FloatingActionButton(
                    elevation: 0,
                    backgroundColor: Appcolors.primary2Color,
                    shape: const CircleBorder(),
                    onPressed: () {
                      expenseController.clearAllFields();
                      showCustomBottomSheet(
                        minChildSize: 0.2,
                        context: context,
                        initialChildSize: 0.8,
                        maxChildSize: 0.9,
                        child: AddNewExpenseBottomSheet(isUpdate: false),
                      );
                    },
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

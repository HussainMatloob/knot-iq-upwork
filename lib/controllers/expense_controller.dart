import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:knot_iq/data/response_results.dart';
import 'package:knot_iq/data/server_exceptions.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/models/budget_data_model.dart';
import 'package:knot_iq/models/expense_data_model.dart';
import 'package:knot_iq/services/apis_request.dart';
import 'package:knot_iq/utils/app_url.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/flush_message.dart';

class ExpenseController extends GetxController {
  TextEditingController amountController = TextEditingController();
  TextEditingController expenseTitleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController installmentAmountController = TextEditingController();
  TextEditingController installmentNoteController = TextEditingController();
  String? selectedDateTime;
  bool isPaid = false;
  bool isRemindMe = false;
  bool isBudgetAdd = false;
  bool isBudgetUpdate = false;
  var categoryList = [];
  bool isExpenseDelete = false;
  List<Map<String, dynamic>> budgetInstallments = [];
  String? categoryId;
  String? selectedCategory;
  List<ExpenseDataModel> expensData = [];

  String? categoryColor;
  String? categoryIcon;

  List<String> categories = [];
  Set<String> uniqueCategories = {};
  bool isExpenseLoading = false;

  bool isLoadExpenseExpenseData = false;
  BudgetDataModel? budgetData;

  /*--------------------------------------------------------------*/
  /*                        date time picker                      */
  /*--------------------------------------------------------------*/
  /// Opens a time picker and returns the selected time

  static Future<TimeOfDay?> pickTime(BuildContext context) async {
    final now = TimeOfDay.now();
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: now,
    );
    return selectedTime;
  }

  static Future<DateTime?> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    return selectedDate;
  }

  /// Opens both date and time pickers, and returns formatted string like "25 Oct , 09:00 PM"
  Future<void> selectInstallmentDate(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    final localDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    //  Convert to ISO UTC for DB
    final isoDateTime = localDateTime.toUtc().toIso8601String();

    selectedDateTime = isoDateTime;

    update();
  }

  /*--------------------------------------------------------------*/
  /*             initialize existing data for update              */
  /*--------------------------------------------------------------*/
  void initializeExistingDataForUpdate(ExpenseDataModel expense) {
    amountController.text = expense.amount.toString();
    expenseTitleController.text = expense.title ?? "";
    noteController.text = expense.note ?? "";
    selectedDateTime = expense.createdAt;
    budgetInstallments = expense.installments
        .map((doc) => doc.toJson())
        .toList();
    categoryId = expense.categoryId.id ?? "";

    update();
  }

  void clearAllFields() {
    amountController.clear();
    expenseTitleController.clear();
    noteController.clear();
    selectedDateTime = null;
    budgetInstallments.clear();
    selectedCategory = null;
    categoryId = null;
    categoryColor = null;
    categoryIcon = null;
    update();
  }

  /*--------------------------------------------------------------*/
  /*                  remove installment from list                */
  /*--------------------------------------------------------------*/
  void removeInstallment(int index, BuildContext context) {
    budgetInstallments.removeAt(index);
    update();
    Navigator.pop(context);
  }

  /*--------------------------------------------------------------*/
  /*                         clear installment                    */
  /*--------------------------------------------------------------*/
  void clearBudgetInstallments() {
    budgetInstallments.clear();
    update();
  }

  /*--------------------------------------------------------------*/
  /*   clear or initialize existing instalmenst for add or update  */
  /*--------------------------------------------------------------*/
  void clearOrInitializeInstallmentFields(
    bool isUpdate, {
    Map<String, dynamic>? installment,
  }) {
    if (!isUpdate) {
      installmentAmountController.clear();
      installmentNoteController.clear();
      selectedDateTime = null;
      isPaid = false;
      isRemindMe = false;
      update();
    } else {
      try {
        installmentAmountController.text = "${installment?["amount"]}";
        installmentNoteController.text = "${installment?["note"]}";
        selectedDateTime = installment?["startDate"];
        isPaid = installment?["isPaid"] ?? false;
        isUpdate = installment?["remindMe"] ?? false;
        update();
      } catch (e) {
        print(e);
      }
    }
  }

  /*--------------------------------------------------------------*/
  /*                add or update budget installment              */
  /*--------------------------------------------------------------*/
  void addOrUpdateBudgetInstallment(
    BuildContext context,
    bool isUpdate, {
    int? index,
  }) {
    double budgetAmount = 0.0; // default value

    if (amountController.text.isNotEmpty) {
      try {
        budgetAmount = double.parse(amountController.text);
      } catch (e) {
        // optional: log error or show warning
        budgetAmount = 0.0; // fallback
      }
    }
    double installmentAmount = double.parse(installmentAmountController.text);
    if (budgetAmount < installmentAmount) {
      FlushMessages.commonToast(
        AppLocalizations.of(context)!.installmentAmountValidate,

        backGroundColor: Appcolors.darkGreyColor,
      );
    } else if (selectedDateTime == null) {
      FlushMessages.commonToast(
        AppLocalizations.of(context)!.paymentDateValidate,
        backGroundColor: Appcolors.darkGreyColor,
      );
    } else {
      final startUtc = DateTime.parse(selectedDateTime!).toUtc();

      if (isUpdate) {
        budgetInstallments[index!] = {
          "amount": installmentAmountController.text.trim(),
          "startDate": startUtc.toIso8601String(),
          "isPaid": isPaid,
          "remindMe": isRemindMe,
          "note": installmentNoteController.text.trim(),
        };
        update();
        Navigator.of(context).pop();
      } else {
        budgetInstallments.add({
          "amount": installmentAmountController.text.trim(),
          "startDate": startUtc.toIso8601String(),
          "isPaid": isPaid,
          "remindMe": isRemindMe,
          "note": installmentNoteController.text.trim(),
        });
        update();
        Navigator.of(context).pop();
      }
    }
  }

  /*--------------------------------------------------------------*/
  /*                           add budget                         */
  /*--------------------------------------------------------------*/
  Future<void> addBudgetExpense(BuildContext context) async {
    try {
      // if (budgetInstallments.isEmpty) {
      //   FlushMessages.commonToast(
      //     "Please add at least one installment",
      //     backGroundColor: Appcolors.darkGreyColor,
      //   );
      // } else
      if (selectedCategory == null || categoryId == null) {
        FlushMessages.commonToast(
          AppLocalizations.of(context)!.categoryValidation,
          backGroundColor: Appcolors.darkGreyColor,
        );
      } else {
        isBudgetAdd = true;
        update();

        final Map<String, dynamic> queryParams = {
          "categoryId": categoryId,
          "title": expenseTitleController.text,
          "amount": amountController.text,
          "note": noteController.text,
          "installments": budgetInstallments,
        };

        final response = await ApiRequest().postRequest(
          queryParameters: queryParams,
          AppUrl.getAddUpdateAndDeleteBudgetEndPoint,
          isAuthenticated: true,
        );
        if (response.statusCode == 201) {
          FlushMessages.commonToast(
            AppLocalizations.of(context)!.addBudget,
            backGroundColor: Appcolors.primaryColor,
          );
          getExpenseData(isGetData: true);
          Navigator.pop(context);
        } else {
          FlushMessages.commonToast(
            "${response.data['message']}",
            backGroundColor: Appcolors.darkGreyColor,
          );
        }
      }
    } on AppException catch (error) {
      FlushMessages.commonToast(
        error.message,
        backGroundColor: Appcolors.darkGreyColor,
      );
      ResponseResult.failure(error);
    } catch (error) {
      FlushMessages.commonToast(
        "$error",
        backGroundColor: Appcolors.darkGreyColor,
      );
      ResponseResult.failure(UnknownException());
    } finally {
      isBudgetAdd = false;
      update();
    }
  }

  /*----------------------------------------------------------------*/
  /*                select value from search able dropdown          */
  /*----------------------------------------------------------------*/

  void selectValueFromSearchAbleDropDown(String valueType, String value) {
    if (valueType == 'Category') {
      selectedCategory = value;
      getCateGoryIdfromName(value);
      update();
    }
  }

  void getCateGoryIdfromName(String name) {
    for (int i = 0; i < categoryList.length; i++) {
      if (categoryList[i]['name'] == name) {
        categoryId = categoryList[i]['_id'];
        categoryColor = categoryList[i]['color'];
        categoryIcon = categoryList[i]['icon'];
      }
    }
    update();
  }

  void getCategoryNameFromId(String id) {
    for (int i = 0; i < categoryList.length; i++) {
      if (categoryList[i]['_id'] == id) {
        selectedCategory = categoryList[i]['name'];
        categoryColor = categoryList[i]['color'];
        categoryIcon = categoryList[i]['icon'];
      }
    }
    update();
  }

  /*--------------------------------------------------------------*/
  /*                paid and remind me switch logic               */
  /*--------------------------------------------------------------*/
  void paidSwitch(value) {
    isPaid = value;
    isRemindMe = false;
    update();
  }

  void remindMeSwitch(value) {
    isRemindMe = value;
    isPaid = false;
    update();
  }

  /*--------------------------------------------------------------*/
  /*                        check and validations                 */
  /*--------------------------------------------------------------*/

  String? amountValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.amountValidate;
    }
    return null;
  }

  String? expenseTitleValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.expenseTitleValidate;
    }
    return null;
  }

  String? noteValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.noteValidate;
    }
    return null;
  }

  /*-----------------------------------------------------------*/
  /*                      get category data                    */
  /*-----------------------------------------------------------*/

  Future<void> getCategoryData(bool isUpdate) async {
    try {
      uniqueCategories.clear();
      categories.clear();
      update();
      final response = await ApiRequest().getRequest(
        AppUrl.getCategoriesEndPoint,
        isAuthenticated: true,
      );

      if (response.statusCode == 200) {
        categoryList = response.data["data"]?["categories"] ?? [];

        for (int i = 0; i < categoryList.length; i++) {
          String categoryName = categoryList[i]['name'];
          if (uniqueCategories.add(categoryName)) {
            categories.add(categoryName);
          }
        }
        update();
        if (isUpdate) {
          getCategoryNameFromId(categoryId!);
        }
      }
    } catch (error) {}
  }

  //ExpenseDataModel

  /*-----------------------------------------------------------*/
  /*                      get Expensees data                   */
  /*-----------------------------------------------------------*/

  int limit = 15; // page size
  int page = 1; // starting page
  bool isLoadingMore = false;
  bool hasExpenseMoreData = true;

  Future<void> getExpenseData({
    bool loadMore = false,
    isGetData = false,
  }) async {
    if (isGetData) {
      getBudgetData();
      isExpenseLoading = true;
      expensData.clear();

      update();
    }

    if (loadMore) {
      if (isLoadingMore || !hasExpenseMoreData) return;
      isLoadingMore = true;
      page++;
    } else {
      page = 1;
      expensData.clear();
      hasExpenseMoreData = true;
    }

    try {
      final response = await ApiRequest().getRequest(
        "${AppUrl.getAddUpdateAndDeleteBudgetEndPoint}?page=$page&limit=$limit",
        isAuthenticated: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> categoryList =
            response.data["data"]["expenses"] ?? [];

        final List<ExpenseDataModel> newExpense = categoryList
            .map((e) => ExpenseDataModel.fromJson(e))
            .toList();

        if (loadMore) {
          expensData.addAll(newExpense);
        } else {
          expensData = newExpense;
        }

        hasExpenseMoreData = newExpense.length == limit;
      } else {
        hasExpenseMoreData = false;
      }
    } catch (error) {
      hasExpenseMoreData = false;
    } finally {
      isLoadingMore = false;
      isExpenseLoading = false;
      update();
    }
  }

  /*--------------------------------------------------------------*/
  /*                        update budget                         */
  /*--------------------------------------------------------------*/
  Future<void> updateBudgetExpense(
    BuildContext context,
    ExpenseDataModel expense,
  ) async {
    try {
      // if (budgetInstallments.isEmpty) {
      //   FlushMessages.commonToast(
      //     "Please add at least one installment",
      //     backGroundColor: Appcolors.darkGreyColor,
      //   );
      //}
      // else
      if (selectedCategory == null || categoryId == null) {
        FlushMessages.commonToast(
          AppLocalizations.of(context)!.categoryValidation,
          backGroundColor: Appcolors.darkGreyColor,
        );
      } else {
        isBudgetUpdate = true;
        update();

        final Map<String, dynamic> queryParams = {
          "categoryId": categoryId,
          "title": expenseTitleController.text,
          "amount": amountController.text,
          "note": noteController.text,
          "installments": budgetInstallments,
        };

        final response = await ApiRequest().putRequest(
          data: queryParams,
          "${AppUrl.getAddUpdateAndDeleteBudgetEndPoint}${expense.id}",
          isAuthenticated: true,
        );
        if (response.statusCode == 200) {
          FlushMessages.commonToast(
            AppLocalizations.of(context)!.updateBudgetSuccess,
            backGroundColor: Appcolors.primaryColor,
          );
          getExpenseData(isGetData: true);
          Navigator.pop(context);
        } else {
          FlushMessages.commonToast(
            "${response.data['message']}",
            backGroundColor: Appcolors.darkGreyColor,
          );
        }
      }
    } on AppException catch (error) {
      FlushMessages.commonToast(
        error.message,
        backGroundColor: Appcolors.darkGreyColor,
      );
      ResponseResult.failure(error);
    } catch (error) {
      FlushMessages.commonToast(
        "$error",
        backGroundColor: Appcolors.darkGreyColor,
      );
      ResponseResult.failure(UnknownException());
    } finally {
      isBudgetUpdate = false;
      update();
    }
  }

  /*-----------------------------------------------------------*/
  /*                     delete  expense  record               */
  /*-----------------------------------------------------------*/
  Future<void> deleteExpense(
    BuildContext context,
    ExpenseDataModel expense,
  ) async {
    try {
      isExpenseDelete = true;
      update();
      final response = await ApiRequest().deleteRequest(
        "${AppUrl.getAddUpdateAndDeleteBudgetEndPoint}${expense.id}",

        isAuthenticated: true,
      );
      if (response.statusCode == 200) {
        FlushMessages.commonToast(
          AppLocalizations.of(context)!.budgetDeletedSuccess,

          backGroundColor: Appcolors.primaryColor,
        );
        Navigator.pop(context);
        getExpenseData(isGetData: true);
      } else {
        FlushMessages.commonToast(
          "${response.data['message']}",
          backGroundColor: Appcolors.darkGreyColor,
        );
      }
    } on AppException catch (error) {
      FlushMessages.commonToast(
        error.message,
        backGroundColor: Appcolors.darkGreyColor,
      );
      ResponseResult.failure(error);
    } catch (error) {
      FlushMessages.commonToast(
        "$error",
        backGroundColor: Appcolors.darkGreyColor,
      );
      ResponseResult.failure(UnknownException());
    } finally {
      isExpenseDelete = false;
      update();
    }
  }
  /*-----------------------------------------------------------*/
  /*                   get  budget data data                   */
  /*-----------------------------------------------------------*/

  Future<void> getBudgetData() async {
    try {
      final response = await ApiRequest().getRequest(
        AppUrl.getBudgetEndPoint,
        isAuthenticated: true,
      );

      if (response.statusCode == 200) {
        var categoryList = response.data["data"];

        budgetData = BudgetDataModel.fromJson(categoryList);
      }
    } catch (error) {
      print(error);
      ResponseResult.failure(UnknownException());
    }
  }
}

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:knot_iq/controllers/vendor_controller.dart';
import 'package:knot_iq/data/response_results.dart';
import 'package:knot_iq/data/server_exceptions.dart'
    show AppException, UnknownException;
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/models/category_data_model.dart';
import 'package:knot_iq/models/vendor_expenses_model.dart';
import 'package:knot_iq/services/apis_request.dart';
import 'package:knot_iq/utils/app_url.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/flush_message.dart';

class VendorSubTaskController extends GetxController {
  TextEditingController venuNameController = TextEditingController();
  TextEditingController totalBudGetController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController installmentAmountController = TextEditingController();
  TextEditingController installmentNoteController = TextEditingController();
  List<VendorExpensesModel> vendorExpenseData = [];

  String? filePath;
  String? fileName;
  bool isInstallmentPaid = false;
  bool isInstallmentRemindMe = false;
  List<Map<String, dynamic>> selectedDocuments = [];
  List<Map<String, dynamic>> vendorInstallments = [];
  bool isVendorUpdate = false;

  String? selectedStartDateTime;
  String? selectedEndDateTime;
  bool isLoadVendorExpenseData = false;
  bool isExpenseAdd = false;
  bool isVendorDelete = false;

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
  Future<void> pickDateTime(
    BuildContext context, {
    bool isStart = false,
  }) async {
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

    if (isStart) {
      selectedStartDateTime = isoDateTime;
    } else {
      selectedEndDateTime = isoDateTime;
    }

    update();
  }

  void setInstalmentPaid(value) {
    isInstallmentPaid = value;
    isInstallmentRemindMe = false;
    update();
  }

  void setInstallmentRemindMe(value) {
    isInstallmentRemindMe = value;
    isInstallmentPaid = false;
    update();
  }

  /*--------------------------------------------------------------*/
  /*                  remove installment from list                */
  /*--------------------------------------------------------------*/
  void removeInstallment(int index, BuildContext context) {
    vendorInstallments.removeAt(index);
    update();
    Navigator.pop(context);
  }

  /*--------------------------------------------------------------*/
  /*            initialize existing  data for update              */
  /*--------------------------------------------------------------*/
  void initializeExistingData(VendorExpensesModel vendorData) {
    venuNameController.text = vendorData.name ?? "";
    totalBudGetController.text = vendorData.totalBudget.toString();
    contactNameController.text = vendorData.contactName ?? "";
    contactNumberController.text = vendorData.contactNumber ?? "";
    noteController.text = vendorData.note ?? "";
    selectedDocuments = vendorData.documents
        .map((doc) => doc.toJson())
        .toList();

    vendorInstallments = vendorData.installments
        .map((doc) => doc.toJson())
        .toList();
    update();
  }

  void clearAllFields() {
    venuNameController.clear();
    totalBudGetController.clear();
    contactNameController.clear();
    contactNumberController.clear();
    noteController.clear();
    selectedDocuments = [];
    vendorInstallments = [];
    clearOrInitializeInstallmentFields(false);
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
      selectedStartDateTime = null;
      selectedEndDateTime = null;
      isInstallmentPaid = false;
      isInstallmentRemindMe = false;
      update();
    } else {
      try {
        installmentAmountController.text = "${installment?["amount"]}";
        installmentNoteController.text = "${installment?["note"]}";
        selectedStartDateTime = installment?["startDate"];
        selectedEndDateTime = installment?["dueDate"];
        isInstallmentPaid = installment?["isPaid"] ?? false;
        isInstallmentRemindMe = installment?["remindMe"] ?? false;
        update();
      } catch (e) {
        print(e);
      }
    }
  }

  /*--------------------------------------------------------------*/
  /*                    add or update installment                 */
  /*--------------------------------------------------------------*/
  void addOrUpdateVendorInstallment(
    BuildContext context,
    bool isUpdate, {
    int? index,
  }) {
    if (selectedStartDateTime == null) {
      FlushMessages.commonToast(
        AppLocalizations.of(context)!.startDateValidate,
        backGroundColor: Appcolors.darkGreyColor,
      );
    } else if (selectedEndDateTime == null) {
      FlushMessages.commonToast(
        AppLocalizations.of(context)!.endDateValidate,
        backGroundColor: Appcolors.darkGreyColor,
      );
    } else {
      final start = DateTime.parse(selectedStartDateTime!).toUtc();
      final end = DateTime.parse(selectedEndDateTime!).toUtc();

      double budgetAmount = 0.0; // default value

      if (totalBudGetController.text.isNotEmpty) {
        try {
          budgetAmount = double.parse(totalBudGetController.text);
        } catch (e) {
          // optional: log error or show warning
          budgetAmount = 0.0; // fallback
        }
      }

      double installmentAmount = double.parse(installmentAmountController.text);

      if (budgetAmount < installmentAmount) {
        FlushMessages.commonToast(
          AppLocalizations.of(context)!.vendorInstallmentAmountValidate,
          backGroundColor: Appcolors.darkGreyColor,
        );
      } else if (start.isAfter(end)) {
        FlushMessages.commonToast(
          AppLocalizations.of(context)!.startEndDateValidate,
          backGroundColor: Appcolors.darkGreyColor,
        );
      } else {
        if (isUpdate) {
          vendorInstallments[index!] = {
            "amount": installmentAmountController.text.trim(),
            "startDate": start.toIso8601String(),
            "dueDate": end.toIso8601String(),
            "isPaid": isInstallmentPaid,
            "remindMe": isInstallmentRemindMe,
            "note": installmentNoteController.text.trim(),
          };
          update();
          Navigator.of(context).pop();
        } else {
          vendorInstallments.add({
            "amount": installmentAmountController.text.trim(),
            "startDate": start.toIso8601String(),
            "dueDate": end.toIso8601String(),
            "isPaid": isInstallmentPaid,
            "remindMe": isInstallmentRemindMe,
            "note": installmentNoteController.text.trim(),
          });
          update();
          Navigator.of(context).pop();
        }
      }
    }
  }

  /*--------------------------------------------------------------*/
  /*                         clear installment                    */
  /*--------------------------------------------------------------*/
  void clearVendorInstallments() {
    vendorInstallments.clear();
    update();
  }

  /*--------------------------------------------------------------*/
  /*                       clear all documents                    */
  /*--------------------------------------------------------------*/

  void clearDocumentsSelection() {
    selectedDocuments.clear();
    update();
  }

  /*--------------------------------------------------------------*/
  /*                         mbs converter                        */
  /*--------------------------------------------------------------*/

  String formatNetworkFileSize(double mbValue) {
    double kb = mbValue * 1024;
    double bytes = mbValue * 1024 * 1024;

    // If less than 1 KB → show Bytes
    if (kb < 1) {
      return "${bytes.toStringAsFixed(2)} Bytes";
    }

    // If less than 1 MB → show KB
    if (mbValue < 1) {
      return "${kb.toStringAsFixed(2)} KB";
    }

    // If less than 1024 MB → show MB
    if (mbValue < 1024) {
      return "${mbValue.toStringAsFixed(2)} MB";
    }

    // Convert MB → GB
    double gb = mbValue / 1024;
    return "${gb.toStringAsFixed(2)} GB";
  }
  /*--------------------------------------------------------------*/
  /*                         pick a document.                     */
  /*--------------------------------------------------------------*/

  String formatLocalFileSize(int bytes) {
    if (bytes < 1024) return "$bytes Bytes";
    double kb = bytes / 1024;
    if (kb < 1024) return "${kb.toStringAsFixed(2)} KB";
    double mb = kb / 1024;
    if (mb < 1024) return "${mb.toStringAsFixed(2)} MB";
    double gb = mb / 1024;
    return "${gb.toStringAsFixed(2)} GB";
  }

  Future<void> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any, // Show all files in native picker
    );

    if (result != null) {
      for (var file in result.files) {
        final ext = file.name.split('.').last.toLowerCase();

        // Allowed extensions: docs + images only
        final allowed = [
          'pdf',
          'doc',
          'docx',
          'xls',
          'xlsx',
          'ppt',
          'pptx',
          'txt',
          'csv',
          'rtf',
          'json',
          'jpg',
          'jpeg',
          'png',
          'gif',
          'bmp',
          'webp',
        ];

        if (!allowed.contains(ext)) {
          print("Skipping ${file.name} (audio/video or unsupported)");
          continue;
        }

        // Reject files > 10 MB
        if (file.size > 10 * 1024 * 1024) {
          continue;
        }

        // Add valid file
        selectedDocuments.add({
          "url": file.path,
          "name": file.name,
          "size": formatLocalFileSize(file.size),
        });
      }

      update();
    } else {
      print("User canceled the picker");
    }
  }

  /*--------------------------------------------------------------*/
  /*                      remove single document                  */
  /*--------------------------------------------------------------*/
  void removeDocument(int index, bool isSingle) {
    if (isSingle) {
      selectedDocuments.removeAt(0);
      update();
    } else {
      selectedDocuments.removeAt(index);
      update();
    }
  }

  /*--------------------------------------------------------------*/
  /*                        check and validations                 */
  /*--------------------------------------------------------------*/

  String? venuNameValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.vendorNameValidate;
    }
    return null;
  }

  String? totalBudgetValidate(String? value, context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.budgetValidade;
    }
    return null;
  }

  String? contactNameValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.contactPersonValidate;
    }
    return null;
  }

  String? contactNumberValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.contactValidate;
    }
    return null;
  }

  String? noteValidate(String? value, context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.noteValidate;
    }
    return null;
  }

  String? installmentAmountValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.validateInstallmentAmount;
    }
    return null;
  }

  String? installmentNoteValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.noteValidate;
    }
    return null;
  }

  String? documentNameValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter document name";
    }
    return null;
  }

  /*-----------------------------------------------------------*/
  /*                    add vendor expense data                */
  /*-----------------------------------------------------------*/

  Future<void> addVendorExpense(
    BuildContext context,
    CategoriesDataModel cateGoryData,
  ) async {
    try {
      // if (vendorInstallments.isEmpty) {
      //   FlushMessages.commonToast(
      //     "Please add at least one installment",
      //     backGroundColor: Appcolors.darkGreyColor,
      //   );
      //}
      // if (selectedDocuments.isEmpty) {
      //   FlushMessages.commonToast(
      //     "Please add at least one document",
      //     backGroundColor: Appcolors.darkGreyColor,
      //   );
      // } else {
      isExpenseAdd = true;
      update();

      if (selectedDocuments.isEmpty) {
        final Map<String, dynamic> queryParams = {
          "categoryId": cateGoryData.id,
          "name": venuNameController.text.trim(),
          "totalBudget": totalBudGetController.text.trim(),
          "paymentType": "installments",
          "installments": vendorInstallments,
          "contactName": contactNameController.text.trim(),
          "contactNumber": contactNumberController.text.trim(),
          "note": noteController.text.trim(),
          "documents": [],
        };

        final response = await ApiRequest().postRequest(
          queryParameters: queryParams,
          AppUrl.getAddUpdateAndDeleteVendorEndPoint,
          isAuthenticated: true,
        );
        if (response.statusCode == 201) {
          FlushMessages.commonToast(
            AppLocalizations.of(context)!.addVendorSuccess,
            backGroundColor: Appcolors.primaryColor,
          );
          await getVendorExpenseData(isGetData: true, cateGoryData);
          Navigator.pop(context);
          final VendorController controller =
              Get.isRegistered<VendorController>()
              ? Get.find<VendorController>()
              : Get.put(VendorController());
          controller.getCategoryData();
        } else {
          FlushMessages.commonToast(
            "${response.data['message']}",
            backGroundColor: Appcolors.darkGreyColor,
          );
        }
      } else {
        final fileList = selectedDocuments.map((e) => File(e["url"])).toList();
        final imageResponse = await ApiRequest().mediaListmulticastPostRequest(
          AppUrl.addMultipleMediaEndPoint,
          isAuthenticated: true,
          mediaFiles: fileList,
        );

        if (imageResponse.statusCode == 201) {
          final images = imageResponse.data["data"]["media"];
          List<Map<String, dynamic>> selectedReadyDocuments = [];
          for (int i = 0; i < images.length; i++) {
            selectedReadyDocuments.add({
              "name": images[i]["filename"],
              "url": images[i]["url"],
              "size": images[i]["size"],
            });
          }

          final Map<String, dynamic> queryParams = {
            "categoryId": cateGoryData.id,
            "name": venuNameController.text.trim(),
            "totalBudget": totalBudGetController.text.trim(),
            "paymentType": "installments",
            "installments": vendorInstallments,
            "contactName": contactNameController.text.trim(),
            "contactNumber": contactNumberController.text.trim(),
            "note": noteController.text.trim(),
            "documents": selectedReadyDocuments,
          };

          final response = await ApiRequest().postRequest(
            queryParameters: queryParams,
            AppUrl.getAddUpdateAndDeleteVendorEndPoint,
            isAuthenticated: true,
          );
          if (response.statusCode == 201) {
            FlushMessages.commonToast(
              AppLocalizations.of(context)!.addVendorSuccess,
              backGroundColor: Appcolors.primaryColor,
            );
            await getVendorExpenseData(isGetData: true, cateGoryData);
            Navigator.pop(context);
            final VendorController controller =
                Get.isRegistered<VendorController>()
                ? Get.find<VendorController>()
                : Get.put(VendorController());
            controller.getCategoryData();
          } else {
            FlushMessages.commonToast(
              "${response.data['message']}",
              backGroundColor: Appcolors.darkGreyColor,
            );
          }
        } else {
          FlushMessages.commonToast(
            "${imageResponse.data['message']}",
            backGroundColor: Appcolors.darkGreyColor,
          );
        }
      }
      //}
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
      isExpenseAdd = false;
      update();
    }
  }

  /*-----------------------------------------------------------*/
  /*                  get vendor Expense data                  */
  /*-----------------------------------------------------------*/

  int limit = 15; // page size
  int page = 1; // starting page
  bool isLoadingMore = false;
  bool hasExpenseMoreData = true;

  Future<void> getVendorExpenseData(
    CategoriesDataModel categoryData, {
    bool loadMore = false,
    isGetData = false,
  }) async {
    if (isGetData) {
      isLoadVendorExpenseData = true;
      vendorExpenseData.clear();

      update();
    }

    if (loadMore) {
      if (isLoadingMore || !hasExpenseMoreData) return;
      isLoadingMore = true;
      page++;
    } else {
      page = 1;
      vendorExpenseData.clear();
      hasExpenseMoreData = true;
    }

    try {
      final response = await ApiRequest().getRequest(
        "${AppUrl.getAddUpdateAndDeleteVendorEndPoint}?categoryId=${categoryData.id}&page=$page&limit=$limit",
        isAuthenticated: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> categoryList =
            response.data["data"]["vendors"] ?? [];

        final List<VendorExpensesModel> newExpense = categoryList
            .map((e) => VendorExpensesModel.fromJson(e))
            .toList();

        if (loadMore) {
          vendorExpenseData.addAll(newExpense);
        } else {
          vendorExpenseData = newExpense;
        }

        hasExpenseMoreData = newExpense.length == limit;
      } else {
        hasExpenseMoreData = false;
      }
    } catch (error) {
      hasExpenseMoreData = false;
    } finally {
      isLoadingMore = false;
      isLoadVendorExpenseData = false;
      update();
    }
  }

  /*-----------------------------------------------------------*/
  /*                         delete vendor data                 */
  /*-----------------------------------------------------------*/
  Future<void> deleteVendor(
    BuildContext context,
    CategoriesDataModel categoryData,
    VendorExpensesModel vendorData,
  ) async {
    try {
      isVendorDelete = true;
      update();
      final response = await ApiRequest().deleteRequest(
        "${AppUrl.getAddUpdateAndDeleteVendorEndPoint}${vendorData.id}",

        isAuthenticated: true,
      );
      if (response.statusCode == 200) {
        FlushMessages.commonToast(
          AppLocalizations.of(context)!.deleteVendorSuccess,
          backGroundColor: Appcolors.primaryColor,
        );
        Navigator.pop(context);
        await getVendorExpenseData(isGetData: true, categoryData);
        final VendorController controller = Get.isRegistered<VendorController>()
            ? Get.find<VendorController>()
            : Get.put(VendorController());
        controller.getCategoryData();
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
      isVendorDelete = false;
      update();
    }
  }

  /*-----------------------------------------------------------*/
  /*                  update vendor expense data               */
  /*-----------------------------------------------------------*/
  Future<void> updateVendorExpense(
    BuildContext context,
    CategoriesDataModel cateGoryData,
    VendorExpensesModel vendorData,
  ) async {
    try {
      // if (vendorInstallments.isEmpty) {
      //   FlushMessages.commonToast(
      //     "Please add at least one installment",
      //     backGroundColor: Appcolors.darkGreyColor,
      //   );
      //   return;
      // }

      // if (selectedDocuments.isEmpty) {
      //   FlushMessages.commonToast(
      //     "Please add at least one document",
      //     backGroundColor: Appcolors.darkGreyColor,
      //   );
      //   return;
      // }

      isVendorUpdate = true;
      update();

      if (selectedDocuments.isEmpty) {
        final Map<String, dynamic> queryParams = {
          "categoryId": cateGoryData.id,
          "name": venuNameController.text.trim(),
          "totalBudget": totalBudGetController.text.trim(),
          "paymentType": "installments",
          "installments": vendorInstallments,
          "contactName": contactNameController.text.trim(),
          "contactNumber": contactNumberController.text.trim(),
          "note": noteController.text.trim(),
          "documents": [],
        };

        final response = await ApiRequest().putRequest(
          data: queryParams,
          "${AppUrl.getAddUpdateAndDeleteVendorEndPoint}${vendorData.id}",
          isAuthenticated: true,
        );

        if (response.statusCode == 200) {
          FlushMessages.commonToast(
            AppLocalizations.of(context)!.updateVendorSuccess,
            backGroundColor: Appcolors.primaryColor,
          );
          await getVendorExpenseData(isGetData: true, cateGoryData);
          Navigator.pop(context);
          final VendorController controller =
              Get.isRegistered<VendorController>()
              ? Get.find<VendorController>()
              : Get.put(VendorController());
          controller.getCategoryData();
        } else {
          FlushMessages.commonToast(
            "${response.data['message']}",
            backGroundColor: Appcolors.darkGreyColor,
          );
        }
      } else {
        // ------------------------
        // Separate local and network documents
        // ------------------------
        final localDocs = selectedDocuments
            .where((e) => !e["url"].toString().startsWith("/uploads"))
            .toList();

        List<Map<String, dynamic>> updatedDocuments = [];

        // If local docs exist, upload them first
        if (localDocs.isNotEmpty) {
          final fileList = localDocs.map((e) => File(e["url"])).toList();

          final imageResponse = await ApiRequest()
              .mediaListmulticastPostRequest(
                AppUrl.addMultipleMediaEndPoint,
                isAuthenticated: true,
                mediaFiles: fileList,
              );

          if (imageResponse.statusCode == 201) {
            final uploadedFiles = imageResponse.data["data"]["media"];

            // Add uploaded network files to the final list
            for (var file in uploadedFiles) {
              updatedDocuments.add({
                "name": file["filename"],
                "url": file["url"],
                "size": file["size"],
              });
            }

            // Remove local files from selectedDocuments
            selectedDocuments.removeWhere(
              (e) => !e["url"].toString().startsWith("/uploads"),
            );

            // Add remaining network files to final list
            selectedDocuments.addAll(updatedDocuments);
          } else {
            FlushMessages.commonToast(
              "${imageResponse.data['message']}",
              backGroundColor: Appcolors.darkGreyColor,
            );
            return;
          }
        }

        // ------------------------
        // Send vendor expense data
        // ------------------------
        final Map<String, dynamic> queryParams = {
          "categoryId": cateGoryData.id,
          "name": venuNameController.text.trim(),
          "totalBudget": totalBudGetController.text.trim(),
          "paymentType": "installments",
          "installments": vendorInstallments,
          "contactName": contactNameController.text.trim(),
          "contactNumber": contactNumberController.text.trim(),
          "note": noteController.text.trim(),
          "documents": selectedDocuments,
        };

        final response = await ApiRequest().putRequest(
          data: queryParams,
          "${AppUrl.getAddUpdateAndDeleteVendorEndPoint}${vendorData.id}",
          isAuthenticated: true,
        );

        if (response.statusCode == 200) {
          FlushMessages.commonToast(
            AppLocalizations.of(context)!.updateVendorSuccess,
            backGroundColor: Appcolors.primaryColor,
          );
          await getVendorExpenseData(isGetData: true, cateGoryData);
          Navigator.pop(context);
          final VendorController controller =
              Get.isRegistered<VendorController>()
              ? Get.find<VendorController>()
              : Get.put(VendorController());
          controller.getCategoryData();
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
      isVendorUpdate = false;
      update();
    }
  }
}

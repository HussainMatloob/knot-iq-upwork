import 'dart:io' show Platform, File;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knot_iq/data/response_results.dart';
import 'package:knot_iq/data/server_exceptions.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/models/category_data_model.dart';
import 'package:knot_iq/services/apis_request.dart';
import 'package:knot_iq/utils/app_url.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/flush_message.dart';
import 'package:knot_iq/utils/image_picker_helper.dart';

class VendorController extends GetxController {
  TextEditingController categoryController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  File? iconImage;
  bool isCategoryUpdatae = false;
  bool isCategoryAdd = false;
  bool loadCategoryData = false;
  String? netWorkImaage;
  List<CategoriesDataModel> cateGoryData = [];
  String hex = '';
  bool isCategoryDelete = false;
  Color selectedColor = Colors.blue; // default color
  double hue = 0.0; // hue slider (0–360)

  // Update color from ColorPicker
  void updateColor(Color color) {
    selectedColor = color;

    final hsv = HSVColor.fromColor(color);
    hue = hsv.hue;
    hex =
        "#${selectedColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}";

    update(); // refresh UI
  }

  // HEX value for saving to server
  //  get hex =>
  //       "#${selectedColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}";

  void clearData() {
    hex =
        "#${selectedColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}";
    categoryController.clear();
    supplierController.clear();
    iconImage = null;
    update();
  }

  Color hexToColor(String hex) {
    try {
      hex = hex.trim();

      if (!hex.startsWith("#")) {
        hex = "#$hex";
      }

      // Convert #RRGGBB → 0xFFRRGGBB
      return Color(int.parse(hex.replaceFirst("#", "0xFF")));
    } catch (e) {
      return Colors.grey; // fallback
    }
  }

  void initForUpdate(
    String title,
    String supplierName,
    String image,
    String color,
  ) {
    iconImage = null;
    categoryController.text = title;
    supplierController.text = supplierName;
    selectedColor = hexToColor(color);
    hex = color;
    netWorkImaage = image;
    update();
  }

  /*--------------------------------------------------------------*/
  /*                  select or capture id card image             */
  /*--------------------------------------------------------------*/
  void picOrCaptureImage(bool isGalary, BuildContext context) async {
    iconImage = await ImagePickerHelper.selectOrCaptureImage(isGalary);
    Navigator.pop(context);
    update();
  }

  /*--------------------------------------------------------------*/
  /*                        check and validations                 */
  /*--------------------------------------------------------------*/

  String? taskTitleValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.categoryTitleValidate;
    }
    return null;
  }

  String? supplierNameValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.supplierValidate;
    }
    return null;
  }

  /*-----------------------------------------------------------*/
  /*                        add  category data                 */
  /*-----------------------------------------------------------*/
  Future<void> addCategory(BuildContext context) async {
    try {
      if (iconImage == null) {
        FlushMessages.commonToast(
          AppLocalizations.of(context)!.iconValidate,
          backGroundColor: Appcolors.darkGreyColor,
        );
      } else {
        isCategoryAdd = true;
        update();

        final imageResponse = await ApiRequest().multicastPostRequest(
          AppUrl.addMediaEndPoint,
          image: iconImage,
          isAuthenticated: true,
        );
        if (imageResponse.statusCode == 201) {
          final image = imageResponse.data["data"]["media"]["url"];
          final Map<String, dynamic> queryParams = {
            "name": categoryController.text,
            "icon": image,
            "color": hex,
            "supplierName": supplierController.text,
          };
          final response = await ApiRequest().postRequest(
            queryParameters: queryParams,
            AppUrl.addUpdateAndDeleteCategoryEndPoint,
            isAuthenticated: true,
          );
          if (response.statusCode == 201) {
            FlushMessages.commonToast(
              AppLocalizations.of(context)!.categoryAddSuccess,
              backGroundColor: Appcolors.primaryColor,
            );
            await getCategoryData();
            Navigator.pop(context);
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
      isCategoryAdd = false;
      update();
    }
  }

  /*-----------------------------------------------------------*/
  /*                      get category data                    */
  /*-----------------------------------------------------------*/

  Future<void> getCategoryData() async {
    try {
      loadCategoryData = true;
      update();
      final response = await ApiRequest().getRequest(
        AppUrl.getCategoriesEndPoint,
        isAuthenticated: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> categoryList =
            response.data["data"]?["categories"] ?? [];

        cateGoryData = categoryList
            .map((e) => CategoriesDataModel.fromJson(e))
            .toList();
      }
    } catch (error) {
      ResponseResult.failure(UnknownException());
    } finally {
      loadCategoryData = false;
      update();
    }
  }

  /*-----------------------------------------------------------*/
  /*                     update category data                  */
  /*-----------------------------------------------------------*/
  Future<void> updateCategory(BuildContext context, String id) async {
    try {
      if (iconImage != null) {
        isCategoryUpdatae = true;
        update();
        final imageResponse = await ApiRequest().multicastPostRequest(
          AppUrl.addMediaEndPoint,
          image: iconImage,
          isAuthenticated: true,
        );
        if (imageResponse.statusCode == 201) {
          final image = imageResponse.data["data"]["media"]["url"];
          final Map<String, dynamic> queryParams = {
            "name": categoryController.text,
            "icon": image,
            "color": hex,
            "supplierName": supplierController.text,
          };
          final response = await ApiRequest().putRequest(
            data: queryParams,
            "${AppUrl.addUpdateAndDeleteCategoryEndPoint}$id",

            isAuthenticated: true,
          );
          if (response.statusCode == 200) {
            FlushMessages.commonToast(
              AppLocalizations.of(context)!.categoryUpdateSuccess,
              backGroundColor: Appcolors.primaryColor,
            );
            Navigator.pop(context);
            await getCategoryData();
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
      } else {
        isCategoryUpdatae = true;
        update();
        final Map<String, dynamic> queryParams = {
          "name": categoryController.text,
          "icon": netWorkImaage,
          "color": hex,
          "supplierName": supplierController.text,
        };
        final response = await ApiRequest().putRequest(
          data: queryParams,
          "${AppUrl.addUpdateAndDeleteCategoryEndPoint}$id",
          isAuthenticated: true,
        );
        if (response.statusCode == 200) {
          FlushMessages.commonToast(
            AppLocalizations.of(context)!.categoryUpdateSuccess,
            backGroundColor: Appcolors.primaryColor,
          );
          Navigator.pop(context);
          await getCategoryData();
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
      isCategoryUpdatae = false;
      update();
    }
  }

  /*-----------------------------------------------------------*/
  /*                      delete category data                 */
  /*-----------------------------------------------------------*/
  Future<void> deleteCategory(BuildContext context, String id) async {
    try {
      isCategoryDelete = true;
      update();
      final response = await ApiRequest().deleteRequest(
        "${AppUrl.addUpdateAndDeleteCategoryEndPoint}$id",

        isAuthenticated: true,
      );
      if (response.statusCode == 200) {
        FlushMessages.commonToast(
          AppLocalizations.of(context)!.categoryDeleteSuccess,
          backGroundColor: Appcolors.primaryColor,
        );
        Navigator.pop(context);
        await getCategoryData();
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
      isCategoryDelete = false;
      update();
    }
  }
}

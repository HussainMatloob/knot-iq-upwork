import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knot_iq/data/response_results.dart';
import 'package:knot_iq/data/server_exceptions.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/models/guests_data_model.dart';
import 'package:knot_iq/services/apis_request.dart';
import 'package:knot_iq/utils/app_url.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/flush_message.dart';

class GuestsController extends GetxController {
  int limit = 15; // page size
  int page = 1; // starting page
  bool isLoadingMore = false;
  bool hasGuestsMoreData = true;

  int totalGuests = 0;
  int pendingGuests = 0;
  int attentingGuests = 0;

  bool isTyping = false;
  Timer? _debounce;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController searchGuestsController = TextEditingController();
  List<GuestsDataModel> guestsData = [];
  String rsvpStatus = "pending";
  bool isRsvp = false;
  int lessAndAddOnceValue = 1;
  bool isGuestAdd = false;
  bool isGuestLoading = false;
  bool isGuestUpdate = false;
  bool isGuestDelete = false;

  void clearRecords() {
    firstNameController.clear();
    lastNameController.clear();
    noteController.clear();
    emailController.clear();
    lessAndAddOnceValue = 1;
    isRsvp = false;
    update();
  }

  void forUpdateRecord(GuestsDataModel data) {
    firstNameController.text = data.firstName ?? "";
    lastNameController.text = data.lastName ?? "";
    noteController.text = data.note ?? "";
    if (data.rsvpStatus == "pending") {
      isRsvp = false;
    } else {
      isRsvp = true;
    }
    emailController.text = data.email ?? "";
    rsvpStatus = data.rsvpStatus ?? "";
    lessAndAddOnceValue = data.plusOnes ?? 1;
    update();
  }

  /*------------------------------------------------------------*/
  /*                          search guest                      */
  /*------------------------------------------------------------*/
  Future<void> onSearchChangedDebounced(
    String query, {
    bool loadMore = false,
  }) async {
    // Cancel previous timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start a new timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      onSearchChanged(query); // call your actual search function
    });
  }

  Future<void> onSearchChanged(String query, {bool loadMore = false}) async {
    try {
      // If user is typing something
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      if (searchGuestsController.text.trim().isNotEmpty) {
        isTyping = true;

        if (loadMore) {
          if (isLoadingMore || !hasGuestsMoreData) return;
          isLoadingMore = true;
          page++;
        } else {
          page = 1;
          guestsData.clear(); // Clear list before new search
          hasGuestsMoreData = true;
        }

        final response = await ApiRequest().getRequest(
          "${AppUrl.getGuestEndPoint}?search=$query&page=$page&limit=$limit",
          isAuthenticated: true,
        );

        if (response.statusCode == 200) {
          final List<dynamic> guestList =
              response.data["data"]?["guests"] ?? [];

          final List<GuestsDataModel> newGuests = guestList
              .map((e) => GuestsDataModel.fromJson(e))
              .toList();

          if (loadMore) {
            guestsData.addAll(newGuests);
          } else {
            guestsData = newGuests;
          }

          hasGuestsMoreData = newGuests.length == limit;
        }
      } else {
        // Search cleared
        isTyping = false;
        page = 1;
        guestsData.clear();
        await getGuestsData(isGetData: true);
      }
    } catch (error) {
      hasGuestsMoreData = false;
    } finally {
      isLoadingMore = false;
      isGuestLoading = false;
      update();
    }
  }

  /*------------------------------------------------------------*/
  /*                          set RSVP Status                   */
  /*------------------------------------------------------------*/
  void setRsvpMode(bool isRsvpValue) {
    if (isRsvpValue) {
      isRsvp = isRsvpValue;
      rsvpStatus = "pending";
      update();
    } else {
      isRsvp = isRsvpValue;
      rsvpStatus = "pending";
      update();
    }
  }

  /*------------------------------------------------------------*/
  /*                          set plus once                      */
  /*------------------------------------------------------------*/
  void lessOnce() {
    if (lessAndAddOnceValue > 1) {
      lessAndAddOnceValue -= 1;
      update();
    }
  }

  void addOnce() {
    lessAndAddOnceValue += 1;
    update();
  }
  /*--------------------------------------------------------------*/
  /*                        check and validations                 */
  /*--------------------------------------------------------------*/

  String? firstNameValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.firstNameValidate;
    }
    return null;
  }

  String? lastNameValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.lastNameValidate;
    }
    return null;
  }

  String? noteValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.noteValidate;
    }
    return null;
  }

  String? emailIdValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.emailValidate;
    }
    bool emailReg = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(value);
    if (emailReg == false) {
      return AppLocalizations.of(context)!.validEmailValidate;
    }
    return null;
  }

  /*------------------------------------------------------*/
  /*                        get guest data                */
  /*------------------------------------------------------*/

  Future<void> getGuestsData({bool loadMore = false, isGetData = false}) async {
    searchGuestsController.clear();
    if (isGetData) {
      getGuestsStatistics();
      isGuestLoading = true;
      update();
    }

    if (loadMore) {
      if (isLoadingMore || !hasGuestsMoreData) return;
      isLoadingMore = true;
      page++;
    } else {
      page = 1;
      guestsData.clear();
      hasGuestsMoreData = true;
    }

    try {
      final response = await ApiRequest().getRequest(
        "${AppUrl.getGuestEndPoint}?page=$page&limit=$limit",
        isAuthenticated: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> guestList = response.data["data"]?["guests"] ?? [];

        final List<GuestsDataModel> newGuests = guestList
            .map((e) => GuestsDataModel.fromJson(e))
            .toList();

        if (loadMore) {
          guestsData.addAll(newGuests);
        } else {
          guestsData = newGuests;
        }

        hasGuestsMoreData = newGuests.length == limit;
      } else {
        hasGuestsMoreData = false;
      }
    } catch (error) {
      hasGuestsMoreData = false;
    } finally {
      isLoadingMore = false;
      isGuestLoading = false;
      update();
    }
  }

  /*------------------------------------------------------*/
  /*                    get guests staticstics            */
  /*------------------------------------------------------*/

  Future<void> getGuestsStatistics() async {
    try {
      final response = await ApiRequest().getRequest(
        AppUrl.getGuestStatEndPoint,
        isAuthenticated: true,
      );
      if (response.statusCode == 200) {
        totalGuests = response.data['data']["stats"]["total"];
        attentingGuests = response.data['data']["stats"]["attending"];
        pendingGuests = response.data['data']["stats"]["pending"];
        update();
      }
    } catch (error) {
      ResponseResult.failure(UnknownException());
    }
  }

  /*-----------------------------------------------------------*/
  /*                        add guest data                     */
  /*-----------------------------------------------------------*/
  Future<void> addGuest(BuildContext context) async {
    try {
      isGuestAdd = true;
      update();
      final Map<String, dynamic> queryParams = {
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "note": noteController.text,
        "plusOnes": lessAndAddOnceValue,
        "rsvpStatus": rsvpStatus,
        "email": emailController.text,
      };
      final response = await ApiRequest().postRequest(
        queryParameters: queryParams,
        AppUrl.addGuestEndPoint,
        isAuthenticated: true,
      );
      if (response.statusCode == 201) {
        FlushMessages.commonToast(
          AppLocalizations.of(context)!.guestAddSuccess,
          backGroundColor: Appcolors.primaryColor,
        );
        Navigator.pop(context);
        await getGuestsData(isGetData: true);
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
      isGuestAdd = false;
      update();
    }
  }

  /*-----------------------------------------------------------*/
  /*                        update guest data                  */
  /*-----------------------------------------------------------*/
  Future<void> updateGuest(
    BuildContext context,
    GuestsDataModel guestData,
  ) async {
    try {
      isGuestUpdate = true;
      update();
      final Map<String, dynamic> queryParams = {
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "note": noteController.text,
        "plusOnes": lessAndAddOnceValue,
        "rsvpStatus": rsvpStatus,
        "email": emailController.text,
      };
      String id = guestData.id ?? "";
      final response = await ApiRequest().putRequest(
        data: queryParams,
        "${AppUrl.updateAndDeleteGuestEndPoint}$id",

        isAuthenticated: true,
      );
      if (response.statusCode == 200) {
        FlushMessages.commonToast(
          AppLocalizations.of(context)!.guestUpdateSuccess,
          backGroundColor: Appcolors.primaryColor,
        );
        Navigator.pop(context);
        await getGuestsData(isGetData: true);
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
      isGuestUpdate = false;
      update();
    }
  }

  /*-----------------------------------------------------------*/
  /*                         delete guest data                 */
  /*-----------------------------------------------------------*/
  Future<void> deleteGuest(
    BuildContext context,
    GuestsDataModel guestData,
  ) async {
    try {
      isGuestDelete = true;
      update();
      String id = guestData.id ?? "";
      final response = await ApiRequest().deleteRequest(
        "${AppUrl.updateAndDeleteGuestEndPoint}$id",

        isAuthenticated: true,
      );
      if (response.statusCode == 200) {
        FlushMessages.commonToast(
          AppLocalizations.of(context)!.guestDeleteSuccess,
          backGroundColor: Appcolors.primaryColor,
        );
        Navigator.pop(context);
        await getGuestsData(isGetData: true);
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
      isGuestDelete = false;
      update();
    }
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:knot_iq/controllers/notifications_controller.dart';
import 'package:knot_iq/data/response_results.dart';
import 'package:knot_iq/data/server_exceptions.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/models/dashboard_data_model.dart';
import 'package:knot_iq/models/notifications_data_model.dart';
import 'package:knot_iq/models/user_data_model.dart';
import 'package:knot_iq/presentation/expense_screen/expense_screen.dart';
import 'package:knot_iq/presentation/home_screen/home_screen.dart';
import 'package:knot_iq/presentation/tasks_screen/task_screen.dart';
import 'package:knot_iq/presentation/vendors_screen/vendors_screen.dart';
import 'package:knot_iq/services/apis_request.dart';
import 'package:knot_iq/services/awesome_notification_service.dart';
import 'package:knot_iq/utils/app_url.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/date_helper.dart';
import 'package:knot_iq/utils/flush_message.dart';
import 'package:knot_iq/utils/image_picker_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  UserDataModel? userData;
  DashboardDataModel? dashboardData;
  bool isUpdateLoading = false;
  File? profileImage;
  bool isGetProfileLoading = false;

  List<NotificationDataModel> upcomingRemindersList = [];
  List<String> languages = [
    "English",
    "French",
    "Arabic",
    "Spanish",
    "Italian",
  ];

  Map<String, dynamic>? notificationsSettingsData;

  bool pushNotifications = false;
  bool taskReminder = false;
  bool paymentAlerts = false;
  bool isLoadReminders = false;
  String selectedLanguage = "English";

  int currentIndex = 0;

  void changeTab(int index) {
    currentIndex = index;
    update();
  }

  int selectedLanguageIndex = 0;

  List<Widget> get bottomBarItemContent {
    return [HomeScreen(), VendorsScreen(), ExpenseScreen(), TaskScreen()];
  }

  /*--------------------------------------------------------------*/
  /*                  select or capture id card image             */
  /*--------------------------------------------------------------*/
  void picOrCaptureImage(bool isGalary, BuildContext context) async {
    profileImage = await ImagePickerHelper.selectOrCaptureImage(isGalary);
    update();
  }

  /*-----------------------------------------------------------*/
  /*           calling localization for change language        */
  /*-----------------------------------------------------------*/

  @override
  void onInit() {
    super.onInit();
    setinitialLocaleValue();
  }

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void selectLanguage(String language, int index) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    selectedLanguageIndex = index;
    // Locale locale
    if (language == "English") {
      selectedLanguage = language;
      sp.setString("localeLanguage", "en");
      _locale = Locale(sp.getString("localeLanguage") ?? "en");
    }
    if (language == "French") {
      selectedLanguage = language;
      sp.setString("localeLanguage", "fr");
      _locale = Locale(sp.getString("localeLanguage") ?? "fr");
    }
    if (language == "Arabic") {
      selectedLanguage = language;
      sp.setString("localeLanguage", "ar");
      _locale = Locale(sp.getString("localeLanguage") ?? "ar");
    }
    if (language == "Spanish") {
      selectedLanguage = language;
      sp.setString("localeLanguage", "es");
      _locale = Locale(sp.getString("localeLanguage") ?? "es");
    }

    if (language == "Italian") {
      selectedLanguage = language;
      sp.setString("localeLanguage", "it");
      _locale = Locale(sp.getString("localeLanguage") ?? "it");
    }
    Get.updateLocale(_locale);
    update();
  }

  void setinitialLocaleValue() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    final initialValue = sp.getString("localeLanguage") ?? "en";

    if (initialValue == "en") {
      selectedLanguage = "English";
      _locale = Locale(initialValue);
    }
    if (initialValue == "fr") {
      selectedLanguage = "French";
      _locale = Locale(initialValue);
    }
    if (initialValue == "ar") {
      selectedLanguage = "Arabic";
      _locale = Locale(initialValue);
    }

    if (initialValue == "es") {
      selectedLanguage = "Spanish";
      _locale = Locale(initialValue);
    }

    if (initialValue == "it") {
      selectedLanguage = "Italian";
      _locale = Locale(initialValue);
    }
    for (int i = 0; i < languages.length; i++) {
      if (selectedLanguage == languages[i]) {
        selectedLanguageIndex = i;
      }
    }
    Get.updateLocale(_locale);
    update();
  }

  /*-----------------------------------------------------------*/
  /*                     check and validations                 */
  /*-----------------------------------------------------------*/
  String? firstNameValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.nameValidate;
    }
    return null;
  }

  String? weddingDateValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.wedDateValidate;
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

  /*---------------------------------------------------------------*/
  /*                            date selector                      */
  /*---------------------------------------------------------------*/
  DateTime selectedDate = DateTime.now();
  Future<void> selectDate(
    BuildContext context,
    TextEditingController dateController,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      // Use the date property to keep only the date part without the time component
      selectedDate = DateTime(picked.year, picked.month, picked.day);
      // Format the date using DateFormat
      dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      update();
    }
  }

  /*-----------------------------------------------------------*/
  /*                    run initial functions                  */
  /*-----------------------------------------------------------*/
  void runInitialFunctions(BuildContext context) async {
    final NotificationsController controller =
        Get.isRegistered<NotificationsController>()
        ? Get.find<NotificationsController>()
        : Get.put(NotificationsController());

    controller.getUnReadNotificationsCount();

    getYourData(context);
    getDashboardData();
    getNotificationsSettingsData();
    getUpcomingReminders();
  }

  /*-----------------------------------------------------------*/
  /*                     notification tasks                    */
  /*-----------------------------------------------------------*/
  void enablePushNotification(bool value) {
    pushNotifications = value;
    update();
    updateNotificationsSettingsData();
  }

  void enableTaskReminder(bool value) {
    taskReminder = value;
    update();
    updateNotificationsSettingsData();
  }

  void enablePaymentAlerts(bool value) {
    paymentAlerts = value;
    update();
    updateNotificationsSettingsData();
  }

  /*-----------------------------------------------------------*/
  /*                       get your data                       */
  /*-----------------------------------------------------------*/
  Future<void> getYourData(
    BuildContext context, {
    bool isLoading = false,
  }) async {
    try {
      if (isLoading) {
        isGetProfileLoading = true;
      }
      update();
      final response = await ApiRequest().getRequest(
        AppUrl.getYourDataApiEndPoint,
        isAuthenticated: true,
      );

      if (response.statusCode == 200) {
        userData = UserDataModel.fromJson(response.data["data"]["user"]);
        nameController.text = userData?.name ?? "";
        emailController.text = userData?.email ?? "";

        dateController.text = DateHelper.formatDashDate(userData!.weddingDate!);

        update();
      }
    } on AppException catch (error) {
      userData = null;
      ResponseResult.failure(error);
      update();
    } catch (error) {
      userData = null;
      ResponseResult.failure(UnknownException());
      update();
    } finally {
      isGetProfileLoading = false;
      update();
    }
  }

  /*-----------------------------------------------------------*/
  /*                   get  dashboard data                     */
  /*-----------------------------------------------------------*/
  Future<void> getDashboardData() async {
    try {
      final response = await ApiRequest().getRequest(
        AppUrl.getdashboardDataPoint,
        isAuthenticated: true,
      );

      if (response.statusCode == 200) {
        dashboardData = DashboardDataModel.fromJson(response.data["data"]);
        update();
      }
    } on AppException catch (error) {
      ResponseResult.failure(error);
      update();
    } catch (error) {
      ResponseResult.failure(UnknownException());
      update();
    }
  }

  /*-----------------------------------------------------------*/
  /*               get notification settings data              */
  /*-----------------------------------------------------------*/
  Future<void> getNotificationsSettingsData() async {
    try {
      final response = await ApiRequest().getRequest(
        AppUrl.getNotificationsSettingData,
        isAuthenticated: true,
      );

      if (response.statusCode == 200) {
        notificationsSettingsData = response.data["data"]["settings"];

        pushNotifications = notificationsSettingsData!['pushNotifications'];
        taskReminder = notificationsSettingsData!['taskReminder'];
        paymentAlerts = notificationsSettingsData!['paymentAlerts'];
        update();
      }
    } on AppException catch (error) {
      ResponseResult.failure(error);
      update();
    } catch (error) {
      ResponseResult.failure(UnknownException());
      update();
    }
  }

  /*-----------------------------------------------------------*/
  /*               update notification settings data           */
  /*-----------------------------------------------------------*/
  Future<void> updateNotificationsSettingsData() async {
    try {
      final Map<String, dynamic> data = {
        "pushNotifications": pushNotifications,
        "taskReminder": taskReminder,
        "paymentAlerts": paymentAlerts,
      };
      final response = await ApiRequest().putRequest(
        data: data,
        AppUrl.getNotificationsSettingData,
        isAuthenticated: true,
      );

      if (response.statusCode == 200) {
        final isNotification =
            response.data["data"]["settings"]['pushNotifications'];
        if (isNotification == true) {
          AwesomeNotificationService.subscribeToTopic("wedPlane360");
        } else {
          AwesomeNotificationService.unsubscribeFromTopic("wedPlane360");
        }
      }
    } on AppException catch (error) {
      ResponseResult.failure(error);
      update();
    } catch (error) {
      ResponseResult.failure(UnknownException());
      update();
    }
  }

  /*-----------------------------------------------------------*/
  /*                    get upcoming reminders                 */
  /*-----------------------------------------------------------*/
  Future<void> getUpcomingReminders() async {
    try {
      isLoadReminders = true;
      update();
      final response = await ApiRequest().getRequest(
        "${AppUrl.getUpcomingRemindersApiEndpoint}?limit=20",
        isAuthenticated: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> remindersList = response.data["data"]["reminders"];
        upcomingRemindersList = remindersList
            .map((e) => NotificationDataModel.fromJson(e))
            .toList();

        update();
      }
    } on AppException catch (error) {
      ResponseResult.failure(error);

      update();
    } catch (error) {
      ResponseResult.failure(UnknownException());
      update();
    } finally {
      isLoadReminders = false;
      update();
    }
  }

  /*-----------------------------------------------------------*/
  /*                update  as read notification               */
  /*-----------------------------------------------------------*/
  Future<void> updateReadNotification(
    NotificationDataModel notificationData,
  ) async {
    try {
      String id = notificationData.id ?? "";
      final response = await ApiRequest().putRequest(
        "${AppUrl.readAsnotificationApiendpoint}$id/read",

        isAuthenticated: true,
      );
      if (response.statusCode == 200) {
        // FlushMessages.commonToast(
        //   "Notification mark as read",
        //   backGroundColor: Appcolors.primaryColor,
        // );
        getUpcomingReminders();
        getDashboardData();
      }
    } on AppException catch (error) {
      ResponseResult.failure(error);
    } catch (error) {
      ResponseResult.failure(UnknownException());
    }
  }

  /*-----------------------------------------------------------*/
  /*                     update user profile                   */
  /*-----------------------------------------------------------*/
  Future<void> updateUserProfile(BuildContext context) async {
    try {
      if (profileImage != null) {
        isUpdateLoading = true;
        update();
        final imageResponse = await ApiRequest().multicastPostRequest(
          AppUrl.addMediaEndPoint,
          image: profileImage,
          isAuthenticated: true,
        );
        if (imageResponse.statusCode == 201) {
          final image = imageResponse.data["data"]["media"]["url"];

          final Map<String, dynamic> data = {
            "name": nameController.text,
            "weddingDate": dateController.text,
            "profileImage": image,
          };

          final response = await ApiRequest().putRequest(
            AppUrl.updateYourProfile,
            data: data,
            isAuthenticated: true,
          );
          if (response.statusCode == 200) {
            FlushMessages.commonToast(
              AppLocalizations.of(context)!.profileUpdateSuccess,
              backGroundColor: Appcolors.primaryColor,
            );
            getYourData(context, isLoading: false);
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
      } else {
        isUpdateLoading = true;
        update();

        final Map<String, dynamic> data = {
          "name": nameController.text,
          "weddingDate": dateController.text,
          "profileImage": userData?.profileImage,
        };

        final response = await ApiRequest().putRequest(
          AppUrl.updateYourProfile,
          data: data,
          isAuthenticated: true,
        );
        if (response.statusCode == 200) {
          FlushMessages.commonToast(
            AppLocalizations.of(context)!.profileUpdateSuccess,
            backGroundColor: Appcolors.primaryColor,
          );
          getYourData(context, isLoading: false);
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
      isUpdateLoading = false;
      update();
    }
  }
}

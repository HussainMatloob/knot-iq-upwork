import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knot_iq/data/response_results.dart';
import 'package:knot_iq/data/server_exceptions.dart';
import 'package:knot_iq/models/notifications_data_model.dart';
import 'package:knot_iq/services/apis_request.dart';
import 'package:knot_iq/services/awesome_notification_service.dart';
import 'package:knot_iq/utils/app_url.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/flush_message.dart';

class NotificationsController extends GetxController
    with WidgetsBindingObserver {
  int notificationCounts = 0;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  /*-----------------------------------------------------------*/
  /*      when app background to forground then make listen    */
  /*-----------------------------------------------------------*/
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      getUnReadNotificationsCount();
    }
  }

  void requestIOSPermissions() async {
    if (Platform.isIOS) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        if (kDebugMode) {
          print("User granted permission for notifications on iOS");
        }
      } else {
        if (kDebugMode) {
          print(
            "User declined or has not granted permission for notifications on iOS",
          );
        }
      }
    }
  }

  //  For ios forground notification
  Future foregroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /*-----------------------------------------------------------*/
  /*    when click on notification then move specific screen   */
  /*-----------------------------------------------------------*/
  //Trigrer notification automatically When app in background or terminated
  Future<void> setupInteractionMessage(BuildContext context) async {
    //When app is Terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }
    // When app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'msg') {
      // Get.to(() => NotificationScreen());
      //when click on notification then Move to app specific screen
      //util.bottomNavIndex(1);
    }
  }

  /*-----------------------------------------------------------*/
  /*            function for forground notifications           */
  /*-----------------------------------------------------------*/
  showForegroundNotification() {
    FirebaseMessaging.onMessage.listen((message) {
      final int notificationId = DateTime.now().millisecondsSinceEpoch
          .remainder(100000);
      if (kDebugMode) {
        print(message.notification?.title.toString());
        print(message.notification?.body.toString());
        print(message.data.toString());
        print(message.data['type'].toString());
        print(message.data['id'].toString());
      }

      AwesomeNotificationService().showNotification(
        id: notificationId,
        title: message.notification?.title.toString() ?? "",
        body: message.notification?.body.toString() ?? "",
        payload: "some_data",
      );
      if (message.notification?.title != null) {
        Future.delayed(const Duration(seconds: 3), () async {
          getUnReadNotificationsCount();
        });
      }
    });
  }

  getAccessToken() async {
    final serviceAccountJson = await FirebaseMessaging.instance.getToken();
    print(".......fcm token.......");
    print(serviceAccountJson);
  }

  List<NotificationDataModel> notificationsData = [];
  String selectedFilter = "All";
  bool loadNotifications = false;

  void setFilter(String filter) async {
    selectedFilter = filter;
    AwesomeNotifications().cancelAll();
    // updateNotificationCount();
    update();
  }

  /*-----------------------------------------------------------*/
  /*                get UnRead notification count              */
  /*-----------------------------------------------------------*/
  Future<void> getUnReadNotificationsCount() async {
    try {
      final response = await ApiRequest().getRequest(
        "${AppUrl.getNotificationsApiEndpoint}?isRead=false&page=1&limit=2000",
        isAuthenticated: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> unReadNotificationsList =
            response.data["data"]?["reminders"] ?? [];
        notificationCounts = unReadNotificationsList.length;
        update();
      }
    } catch (error) {}
  }

  int limit = 30; // page size
  int page = 1; // starting page
  bool isLoadingMore = false;
  bool hasExpenseMoreData = true;

  /*-----------------------------------------------------------*/
  /*                     get notification data                 */
  /*-----------------------------------------------------------*/
  Future<void> getNotificationsData({
    bool loadMore = false,
    isGetData = false,
  }) async {
    if (isGetData) {
      loadNotifications = true;
      notificationsData.clear();
      update();
    }

    if (loadMore) {
      if (isLoadingMore || !hasExpenseMoreData) return;
      isLoadingMore = true;
      page++;
    } else {
      page = 1;
      notificationsData.clear();
      hasExpenseMoreData = true;
    }
    try {
      final response = await ApiRequest().getRequest(
        selectedFilter == "All"
            ? "${AppUrl.getNotificationsApiEndpoint}?page=$page&limit=$limit"
            : selectedFilter == "Read"
            ? "${AppUrl.getNotificationsApiEndpoint}?isRead=true&page=$page&limit=$limit"
            : "${AppUrl.getNotificationsApiEndpoint}?isRead=false&page=$page&limit=$limit",
        isAuthenticated: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> notificationList =
            response.data["data"]?["reminders"] ?? [];

        final List<NotificationDataModel> newNotifications = notificationList
            .map((e) => NotificationDataModel.fromJson(e))
            .toList();

        if (loadMore) {
          notificationsData.addAll(newNotifications);
        } else {
          notificationsData = newNotifications;
        }

        hasExpenseMoreData = newNotifications.length == limit;
      } else {
        hasExpenseMoreData = false;
      }
    } catch (error) {
      hasExpenseMoreData = false;
    } finally {
      isLoadingMore = false;
      loadNotifications = false;
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
        FlushMessages.commonToast(
          "Notification marked as read",
          backGroundColor: Appcolors.primaryColor,
        );
        getNotificationsData();
        getUnReadNotificationsCount();
      }
    } on AppException catch (error) {
      ResponseResult.failure(error);
    } catch (error) {
      ResponseResult.failure(UnknownException());
    }
  }
}

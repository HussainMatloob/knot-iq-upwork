import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knot_iq/data/response_results.dart';
import 'package:knot_iq/data/server_exceptions.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/models/guests_data_model.dart';
import 'package:knot_iq/models/tasks_data_model.dart';
import 'package:knot_iq/services/apis_request.dart';
import 'package:knot_iq/utils/app_url.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/flush_message.dart';

class TaskController extends GetxController {
  bool isGuestLoading = false;
  bool isTaskDelete = false;
  int limit = 15; // page size
  int page = 1; // starting page
  bool isLoadingMore = false;
  bool hastasksMoreData = true;
  bool isTaskLoading = false;
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();
  TextEditingController searchGuestsController = TextEditingController();
  String? selectedStartDateTime;
  String? selectedEndDateTime;
  bool isEnablecompleted = false;
  bool isEnableRemindMe = false;
  bool isEditing = false;
  int selectedTab = 0;
  List<String> assignedTasksIdsList = [];
  final tabs = ["All", "Pending", "Completed"];
  bool isTaskAdd = false;
  List<TasksDataModel> tasksData = [];
  Timer? _debounce;
  List<GuestsDataModel> guestsData = [];

  bool hasGuestsMoreData = true;

  List<Map<String, String>> selectedGuests = [];

  void clearFields({isAddTask = false}) {
    if (isAddTask) {
      searchGuestsController.clear();
    } else {
      taskTitleController.clear();
      taskDescriptionController.clear();
      selectedStartDateTime = null;
      selectedEndDateTime = null;
      isEnablecompleted = false;
      isEnableRemindMe = false;
      selectedGuests.clear();
    }
    update();
  }

  void updateFieldds(TasksDataModel taskData) {
    taskTitleController.text = taskData.title ?? "";
    taskDescriptionController.text = taskData.description ?? '';

    selectedStartDateTime = taskData.startDate;

    selectedEndDateTime = taskData.endDate;

    isEnablecompleted = taskData.isCompleted;
    isEnableRemindMe = taskData.remindMe;
    // assignedTaskList = taskData.assignees;
    update();
  }

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

  void selectTap(int value) {
    selectedTab = value;
    getTasksData(isGetData: true);
    update();
  }

  void makeEditAble(value, {TasksDataModel? data, List<Assignee>? assignData}) {
    if (value) {
      selectedGuests.clear();
      for (int i = 0; i < assignData!.length; i++) {
        String name = "${assignData[i].firstName} ${assignData[i].lastName}";
        inviteGuestForTask(assignData[i].id!, name);
      }
      isEditing = value;
      updateFieldds(data!);
    } else {
      isEditing = value;
      clearFields();
    }

    update();
  }

  /*--------------------------------------------------------------*/
  /*                     select guests for task                   */
  /*--------------------------------------------------------------*/
  void inviteGuestForTask(String id, String name) {
    // Check if this guest already exists in list
    final exists = selectedGuests.any((g) => g['id'] == id);

    if (exists) {
      // Remove using id match
      selectedGuests.removeWhere((g) => g['id'] == id);
    } else {
      // Add user as a map
      selectedGuests.add({'id': id, 'name': name});
    }
    update();
    update(["assign_task"]);
  }

  /*--------------------------------------------------------------*/
  /*                 remove selected guest for task               */
  /*--------------------------------------------------------------*/
  void removeTask(String id) {
    final exists = selectedGuests.any((g) => g['id'] == id);

    if (exists) {
      // Remove using id match
      selectedGuests.removeWhere((g) => g['id'] == id);
    }
    update(["assign_task"]);
  }

  /*--------------------------------------------------------------*/
  /*                     add person for task                      */
  /*--------------------------------------------------------------*/
  void assignTask(BuildContext context) {
    Navigator.pop(context);
  }

  /*--------------------------------------------------------------*/
  /*                         swiths logic                         */
  /*--------------------------------------------------------------*/
  void enableCompleted(bool value) {
    isEnablecompleted = value;
    isEnableRemindMe = false;
    update();
  }

  void enableRemindMe(bool value) {
    isEnableRemindMe = value;
    isEnablecompleted = false;
    update();
  }
  /*--------------------------------------------------------------*/
  /*                        check and validations                 */
  /*--------------------------------------------------------------*/

  String? taskTitleValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.taskTitleValidate;
    }
    return null;
  }

  String? taskDiscriptionValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.taskDescriptionValidate;
    }
    return null;
  }

  String? nameValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter name";
    }
    return null;
  }

  /*--------------------------------------------------------------*/
  /*                            add task.                         */
  /*--------------------------------------------------------------*/
  Future<void> addTask(BuildContext context) async {
    try {
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
      } else if (selectedGuests.isEmpty) {
        FlushMessages.commonToast(
          AppLocalizations.of(context)!.guestValidate,
          backGroundColor: Appcolors.darkGreyColor,
        );
      } else {
        final start = DateTime.parse(selectedStartDateTime!).toLocal();
        final end = DateTime.parse(selectedEndDateTime!).toLocal();

        if (start.isAfter(end)) {
          FlushMessages.commonToast(
            AppLocalizations.of(context)!.startEndDateValidate,
            backGroundColor: Appcolors.darkGreyColor,
          );
        } else {
          assignedTasksIdsList = selectedGuests.map((g) => g['id']!).toList();
          final startUtc = DateTime.parse(selectedStartDateTime!).toUtc();
          final endUtc = DateTime.parse(selectedEndDateTime!).toUtc();

          isTaskAdd = true;
          update();
          final Map<String, dynamic> queryParams = {
            "title": taskTitleController.text,
            "description": taskDescriptionController.text,
            "startDate": startUtc.toIso8601String(),
            "endDate": endUtc.toIso8601String(),
            "isCompleted": isEnablecompleted,
            "remindMe": isEnableRemindMe,
            "assignees": assignedTasksIdsList,
          };
          final response = await ApiRequest().postRequest(
            queryParameters: queryParams,
            AppUrl.addUpdateDeleteAndGetTaskEndPoint,
            isAuthenticated: true,
          );
          if (response.statusCode == 201) {
            FlushMessages.commonToast(
              AppLocalizations.of(context)!.taskAddSuccess,
              backGroundColor: Appcolors.primaryColor,
            );
            getTasksData(isGetData: true);
            Navigator.pop(context);
          } else {
            FlushMessages.commonToast(
              "${response.data['message']}",
              backGroundColor: Appcolors.darkGreyColor,
            );
          }
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
      isTaskAdd = false;
      update();
    }
  }

  /*--------------------------------------------------------------*/
  /*                          update task.                        */
  /*--------------------------------------------------------------*/
  Future<void> updateTask(BuildContext context, TasksDataModel taskData) async {
    try {
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
      } else if (selectedGuests.isEmpty) {
        FlushMessages.commonToast(
          AppLocalizations.of(context)!.guestValidate,

          backGroundColor: Appcolors.darkGreyColor,
        );
      } else {
        assignedTasksIdsList = selectedGuests.map((g) => g['id']!).toList();

        final start = DateTime.parse(selectedStartDateTime!).toLocal();
        final end = DateTime.parse(selectedEndDateTime!).toLocal();

        if (start.isAfter(end)) {
          FlushMessages.commonToast(
            AppLocalizations.of(context)!.startEndDateValidate,
            backGroundColor: Appcolors.darkGreyColor,
          );
        } else {
          final startUtc = DateTime.parse(selectedStartDateTime!).toUtc();
          final endUtc = DateTime.parse(selectedEndDateTime!).toUtc();

          isTaskAdd = true;
          update();
          final Map<String, dynamic> queryParams = {
            "title": taskTitleController.text,
            "description": taskDescriptionController.text,
            "startDate": startUtc.toIso8601String(), //  UTC
            "endDate": endUtc.toIso8601String(), //  UTC
            "isCompleted": isEnablecompleted,
            "remindMe": isEnableRemindMe,
            "assignees": assignedTasksIdsList,
          };
          String id = taskData.id ?? "";
          final response = await ApiRequest().putRequest(
            data: queryParams,
            "${AppUrl.addUpdateDeleteAndGetTaskEndPoint}$id",
            isAuthenticated: true,
          );
          if (response.statusCode == 200) {
            FlushMessages.commonToast(
              AppLocalizations.of(context)!.taskUpdateSuccess,
              backGroundColor: Appcolors.primaryColor,
            );
            getTasksData(isGetData: true);
            Navigator.pop(context);
          } else {
            FlushMessages.commonToast(
              "${response.data['message']}",
              backGroundColor: Appcolors.darkGreyColor,
            );
          }
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
      isTaskAdd = false;
      update();
    }
  }

  /*------------------------------------------------------*/
  /*                      get tasks data                  */
  /*------------------------------------------------------*/

  Future<void> getTasksData({bool loadMore = false, isGetData = false}) async {
    if (isGetData) {
      isTaskLoading = true;
      update();
    }

    if (loadMore) {
      if (isLoadingMore || !hastasksMoreData) return;
      isLoadingMore = true;
      page++;
    } else {
      page = 1;
      tasksData.clear();
      hastasksMoreData = true;
    }

    try {
      final response = await ApiRequest().getRequest(
        tabs[selectedTab] == "All"
            ? "${AppUrl.addUpdateDeleteAndGetTaskEndPoint}?page=$page&limit=$limit"
            : "${AppUrl.addUpdateDeleteAndGetTaskEndPoint}?status=${tabs[selectedTab].toLowerCase()}&page=$page&limit=$limit",
        isAuthenticated: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> guestList = response.data["data"]?["tasks"] ?? [];

        final List<TasksDataModel> newGuests = guestList
            .map((e) => TasksDataModel.fromJson(e))
            .toList();

        if (loadMore) {
          tasksData.addAll(newGuests);
        } else {
          tasksData = newGuests;
        }

        hastasksMoreData = newGuests.length == limit;
      } else {
        hastasksMoreData = false;
      }
    } catch (error) {
      hastasksMoreData = false;
    } finally {
      isLoadingMore = false;
      isTaskLoading = false;
      update();
    }
  }

  /*-----------------------------------------------------------*/
  /*                         delete task data                 */
  /*-----------------------------------------------------------*/
  Future<void> deleteTask(BuildContext context, TasksDataModel taskData) async {
    try {
      isTaskDelete = true;
      update();
      String id = taskData.id ?? "";
      final response = await ApiRequest().deleteRequest(
        "${AppUrl.addUpdateDeleteAndGetTaskEndPoint}$id",

        isAuthenticated: true,
      );
      if (response.statusCode == 200) {
        FlushMessages.commonToast(
          AppLocalizations.of(context)!.taskDeleteSuccess,
          backGroundColor: Appcolors.primaryColor,
        );
        Navigator.pop(context);
        await getTasksData(isGetData: true);
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
      isTaskDelete = false;
      update();
    }
  }

  /*------------------------------------------------------*/
  /*                        get guest data                */
  /*------------------------------------------------------*/

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

  Future<void> getGuestsData({
    bool loadMore = false,
    isGetData = false,
    String? query,
  }) async {
    searchGuestsController.clear();
    if (isGetData) {
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
}

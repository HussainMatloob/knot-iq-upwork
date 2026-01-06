import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:get/get.dart';
import 'package:knot_iq/controllers/task_controller.dart';
import 'package:knot_iq/core/common_widgets/bottom_sheet.dart';
import 'package:knot_iq/core/common_widgets/custom_delete_dialog.dart';
import 'package:knot_iq/core/common_widgets/custom_text_form_field.dart';
import 'package:knot_iq/core/common_widgets/switch_button.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/models/tasks_data_model.dart';
import 'package:knot_iq/presentation/tasks_screen/widgets/assign_task_bottom_sheet.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

import '../../../utils/date_helper.dart' show DateHelper;

class AddTaskBottomSheet extends StatefulWidget {
  bool isEditing;
  TasksDataModel? taskData;
  AddTaskBottomSheet({super.key, this.isEditing = false, this.taskData});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  TaskController taskController = Get.put(TaskController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetBuilder<TaskController>(
                builder: (taskController) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// CENTER - TITLE (Flexible + Ellipsis)
                          Text(
                            widget.isEditing
                                ? AppLocalizations.of(context)!.updateTask
                                : AppLocalizations.of(context)!.addTask,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Appcolors.blackColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

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
                        ],
                      ),

                      SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.taskTitle,
                        style: TextStyle(
                          color: Appcolors.darkGreyColor,
                          fontSize: bodyfontSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 6),
                      CustomTextFormField(
                        validateFunction: (value) =>
                            taskController.taskTitleValidate(value, context),
                        hint: AppLocalizations.of(context)!.hintTextTitle,
                        controller: taskController.taskTitleController,
                      ),

                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.taskDescription,
                        style: TextStyle(
                          color: Appcolors.darkGreyColor,
                          fontSize: bodyfontSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 6),
                      CustomTextFormField(
                        multiLine: 4,
                        validateFunction: (value) => taskController
                            .taskDiscriptionValidate(value, context),
                        hint: AppLocalizations.of(context)!.hintTextDescription,
                        controller: taskController.taskDescriptionController,
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            flex: 50,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.startDate,
                                  style: TextStyle(
                                    color: Appcolors.darkGreyColor,
                                    fontSize: bodyfontSize,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                InkWell(
                                  onTap: () async {
                                    taskController.pickDateTime(
                                      context,
                                      isStart: true,
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 12,
                                    ),
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Appcolors.whiteColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            taskController
                                                        .selectedStartDateTime ==
                                                    null
                                                ? DateHelper.formatStringToDisplay(
                                                    DateTime.now()
                                                        .toUtc()
                                                        .toIso8601String(),
                                                  )
                                                : DateHelper.formatStringToDisplay(
                                                    taskController
                                                        .selectedStartDateTime!,
                                                  ),

                                            style: TextStyle(
                                              color:
                                                  taskController
                                                          .selectedStartDateTime ==
                                                      null
                                                  ? Appcolors.darkGreyColor
                                                  : Appcolors.blackColor,
                                              fontSize: bodyfontSize,
                                              fontWeight: FontWeight.w400,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SvgPicture.asset(
                                            AssetPath.calendarIcon,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 50,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.endDate,
                                  style: TextStyle(
                                    color: Appcolors.darkGreyColor,
                                    fontSize: bodyfontSize,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                InkWell(
                                  onTap: () async {
                                    taskController.pickDateTime(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 12,
                                    ),
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Appcolors.whiteColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            taskController
                                                        .selectedEndDateTime ==
                                                    null
                                                ? DateHelper.formatStringToDisplay(
                                                    DateTime.now()
                                                        .toUtc()
                                                        .toIso8601String(),
                                                  )
                                                : DateHelper.formatStringToDisplay(
                                                    taskController
                                                        .selectedEndDateTime!,
                                                  ),

                                            style: TextStyle(
                                              color:
                                                  taskController
                                                          .selectedEndDateTime ==
                                                      null
                                                  ? Appcolors.darkGreyColor
                                                  : Appcolors.blackColor,
                                              fontSize: bodyfontSize,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SvgPicture.asset(
                                            AssetPath.calendarIcon,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Container(
                        height: 50,
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Appcolors.whiteColor,
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AssetPath.tickCircleIcon,
                              colorFilter: const ColorFilter.mode(
                                Appcolors.darkGreyColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.completedText,
                              style: TextStyle(
                                color: Appcolors.darkGreyColor,
                                fontSize: headdingfontSize,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                            CustomSwitch(
                              value: taskController.isEnablecompleted,
                              onChanged: (value) {
                                taskController.enableCompleted(value);
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        height: 50,
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Appcolors.whiteColor,
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AssetPath.flagIcon,
                              colorFilter: const ColorFilter.mode(
                                Appcolors.redColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.taskRemindMe,
                              style: TextStyle(
                                color: Appcolors.darkGreyColor,
                                fontSize: headdingfontSize,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                            CustomSwitch(
                              value: taskController.isEnableRemindMe,
                              onChanged: (value) {
                                taskController.enableRemindMe(value);
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
              Text(
                AppLocalizations.of(context)!.assignTask,
                style: TextStyle(
                  color: Appcolors.darkGreyColor,
                  fontSize: bodyfontSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 6),
              GetBuilder<TaskController>(
                id: ("assign_task"),
                builder: (taskController) {
                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Appcolors.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              itemCount: taskController.selectedGuests.length,
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    margin: EdgeInsets.only(left: 6, right: 2),
                                    decoration: BoxDecoration(
                                      color: Appcolors.grey3Color,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Appcolors.randomColors[Random()
                                                    .nextInt(4)],
                                          ),
                                          child: Text(
                                            taskController
                                                    .selectedGuests[index]
                                                    .isNotEmpty
                                                ? taskController
                                                      .selectedGuests[index]["name"]![0]
                                                : "",
                                            style: TextStyle(
                                              color: Appcolors.whiteColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          taskController
                                                  .selectedGuests[index]["name"] ??
                                              '',
                                          style: TextStyle(
                                            color: Appcolors.darkGreyColor,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            taskController.removeTask(
                                              taskController
                                                  .selectedGuests[index]["id"]!,
                                            );
                                          },
                                          child: Icon(
                                            Icons.cancel,
                                            size: 15,
                                            color: Appcolors.darkGreyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          taskController.clearFields(isAddTask: true);
                          showCustomBottomSheet(
                            minChildSize: 0.65,
                            context: context,
                            initialChildSize: 0.65,
                            maxChildSize: 0.7,
                            child: AssignTaskBootomSheet(),
                            isFixed: true,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 9,
                          ),
                          height: 50,
                          decoration: BoxDecoration(
                            color: Appcolors.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 26,
                              color: Appcolors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              GetBuilder<TaskController>(
                builder: (taskcontroller) {
                  return taskController.isTaskAdd || taskController.isTaskDelete
                      ? Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: taskController.isTaskDelete
                                  ? Appcolors.redColor
                                  : Appcolors.primary2Color,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.isEditing
                                ? Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        customDeleteDialog(
                                          context,
                                          onTap: () {
                                            Navigator.pop(context);
                                            taskController.deleteTask(
                                              context,
                                              widget.taskData!,
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        height: 40,
                                        padding: EdgeInsets.all(8),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color: Appcolors.redColor.withAlpha(
                                            20,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.deleteText,
                                            style: TextStyle(
                                              color: Appcolors.redColor,
                                              fontSize: headdingfontSize,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            Visibility(
                              visible: widget.isEditing,
                              child: SizedBox(width: 30),
                            ),

                            /// RIGHT - Save / Update / Loader
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    if (taskController.isEditing) {
                                      taskController.updateTask(
                                        context,
                                        widget.taskData!,
                                      );
                                    } else {
                                      taskController.addTask(context);
                                    }
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  padding: EdgeInsets.all(8),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Appcolors.primary2Color,
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.isEditing
                                          ? AppLocalizations.of(
                                              context,
                                            )!.updateText
                                          : AppLocalizations.of(
                                              context,
                                            )!.saveText,
                                      style: const TextStyle(
                                        color: Appcolors.whiteColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

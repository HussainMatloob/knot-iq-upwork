import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/task_controller.dart';
import 'package:knot_iq/core/common_widgets/bottom_sheet.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/presentation/tasks_screen/widgets/add_task_bottom_sheet.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';
import 'package:knot_iq/utils/data_constant.dart';
import 'package:knot_iq/utils/date_helper.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TaskController taskController = Get.put(TaskController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskController.getTasksData(isGetData: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == 0)
        return; // prevent trigger when not scrollable

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        taskController.getTasksData(loadMore: true);
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
    return GetBuilder<TaskController>(
      builder: (taskController) {
        return Stack(
          children: [
            // Main content
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: const BoxDecoration(
                  color: Appcolors.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    // Tabs
                    SizedBox(
                      height: 40, // fixed height for touch detection
                      child: Row(
                        children: List.generate(taskController.tabs.length, (
                          index,
                        ) {
                          // final isSelected = value == index;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                taskController.selectTap(index);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: taskController.selectedTab == index
                                      ? Appcolors.primaryColor
                                      : Appcolors.grey2Color,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  DataConstant.taskTabs(context)[index],
                                  style: TextStyle(
                                    color: taskController.selectedTab == index
                                        ? Appcolors.whiteColor
                                        : Appcolors.darkGreyColor,
                                    fontSize: bodyfontSize,
                                    fontWeight:
                                        taskController.selectedTab == index
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 20),
                    taskController.isTaskLoading
                        ? Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Appcolors.primaryColor,
                              ),
                            ),
                          )
                        : taskController.tasksData.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 80),
                              SvgPicture.asset(AssetPath.notFoundIcon),
                              SizedBox(height: 24),
                              Text(
                                taskController.tabs[taskController
                                            .selectedTab] ==
                                        "All"
                                    ? AppLocalizations.of(context)!.noAddedTask
                                    : taskController.tabs[taskController
                                              .selectedTab] ==
                                          "Pending"
                                    ? AppLocalizations.of(
                                        context,
                                      )!.noPendingTaskYet
                                    : AppLocalizations.of(
                                        context,
                                      )!.noCompletedTaskYet,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Appcolors.blackColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                taskController.tabs[taskController
                                            .selectedTab] ==
                                        "All"
                                    ? AppLocalizations.of(
                                        context,
                                      )!.taskEmptySreenMessage
                                    : taskController.tabs[taskController
                                              .selectedTab] ==
                                          "Pending"
                                    ? AppLocalizations.of(
                                        context,
                                      )!.taskPendingEmptySreenMessage
                                    : AppLocalizations.of(
                                        context,
                                      )!.taskCompletedEmptySreenMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Appcolors.darkGreyColor,
                                  fontSize: headdingfontSize,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          )
                        : Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: BouncingScrollPhysics(),

                              controller: _scrollController,
                              itemCount:
                                  taskController.tasksData.length +
                                  (taskController.hastasksMoreData ? 1 : 0),

                              itemBuilder: (context, index) {
                                if (index < taskController.tasksData.length) {
                                  final task = taskController.tasksData[index];
                                  return InkWell(
                                    onTap: () {
                                      taskController.makeEditAble(
                                        true,
                                        data: task,
                                        assignData: taskController
                                            .tasksData[index]
                                            .assignees,
                                      );
                                      showCustomBottomSheet(
                                        minChildSize: 0.2,
                                        context: context,
                                        initialChildSize: 0.9,
                                        maxChildSize: 0.9,
                                        child: AddTaskBottomSheet(
                                          isEditing: true,
                                          taskData: task,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      margin: EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                        color: Appcolors.whiteColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            task.title ?? "",
                                            style: TextStyle(
                                              color: Appcolors.blackColor,
                                              fontSize: headdingfontSize,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "${AppLocalizations.of(context)!.dueDate}: ${DateHelper.formatStringToDisplay(task.endDate)}",
                                                  style: TextStyle(
                                                    color: Appcolors.blackColor,
                                                    fontSize: bodySmallfontSize,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 18),
                                              Container(
                                                height: 5,
                                                width: 5,
                                                decoration: BoxDecoration(
                                                  color:
                                                      Appcolors.darkGreyColor,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 18),
                                              Text(
                                                task.isCompleted
                                                    ? AppLocalizations.of(
                                                        context,
                                                      )!.completedText
                                                    : AppLocalizations.of(
                                                        context,
                                                      )!.pending,
                                                style: TextStyle(
                                                  color:
                                                      Appcolors.primary2Color,
                                                  fontSize: bodyfontSize,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 14),
                                          SizedBox(
                                            height: 30,
                                            width: double.infinity,
                                            child: Center(
                                              child: ListView.builder(
                                                padding: EdgeInsets.zero,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    task.assignees.length,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 7,
                                                          vertical: 5,
                                                        ),
                                                    margin: EdgeInsets.only(
                                                      right: 8,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Appcolors.grey3Color,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color:
                                                                Appcolors
                                                                    .randomColors[Random()
                                                                    .nextInt(
                                                                      4,
                                                                    )],
                                                          ),
                                                          child: Text(
                                                            task
                                                                    .assignees
                                                                    .isNotEmpty
                                                                ? task
                                                                      .assignees[index]
                                                                      .firstName![0]
                                                                : "",
                                                            style: TextStyle(
                                                              color: Appcolors
                                                                  .whiteColor,
                                                              fontSize: 7,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          "${task.assignees[index].firstName} ${task.assignees[index].lastName}",

                                                          style: TextStyle(
                                                            color: Appcolors
                                                                .darkGreyColor,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        SizedBox(),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
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
                    taskController.makeEditAble(false);
                    showCustomBottomSheet(
                      minChildSize: 0.2,
                      context: context,
                      initialChildSize: 0.9,
                      maxChildSize: 0.9,
                      child: AddTaskBottomSheet(),
                    );
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

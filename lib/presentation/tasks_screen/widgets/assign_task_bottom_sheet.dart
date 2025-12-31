import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:get/get.dart';
import 'package:knot_iq/controllers/task_controller.dart';
import 'package:knot_iq/core/common_widgets/text_field.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class AssignTaskBootomSheet extends StatefulWidget {
  const AssignTaskBootomSheet({super.key});

  @override
  State<AssignTaskBootomSheet> createState() => _AssignTaskBootomSheetState();
}

class _AssignTaskBootomSheetState extends State<AssignTaskBootomSheet> {
  TaskController taskController = Get.put(TaskController());
  final ScrollController _scrollController = ScrollController();
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskController.getGuestsData(isGetData: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == 0)
        return; // prevent trigger when not scrollable

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        taskController.getGuestsData(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      builder: (taskController) {
        return Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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

                    /// CENTER - TITLE (Flexible + Ellipsis)
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.assignTask,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Appcolors.blackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    /// RIGHT - Save / Update / Loader
                    InkWell(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          taskController.assignTask(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!.saveText,
                          style: const TextStyle(
                            color: Appcolors.primaryColor,
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
                  AppLocalizations.of(context)!.assignText,
                  style: TextStyle(
                    color: Appcolors.darkGreyColor,
                    fontSize: bodyfontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 6),
                CustomSearchField(
                  styleFontSize: 12,
                  controller: taskController.searchGuestsController,
                  hintText: AppLocalizations.of(context)!.searchText,
                  prefix: Container(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      AssetPath.searchIcon,
                      colorFilter: const ColorFilter.mode(
                        Appcolors.darkGreyColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    taskController.onSearchChangedDebounced(value);
                  },
                ),
                SizedBox(height: 20),
                Flexible(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    controller: _scrollController,
                    itemCount:
                        taskController.guestsData.length +
                        (taskController.hasGuestsMoreData ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < taskController.guestsData.length) {
                        final guest = taskController.guestsData[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${guest.firstName} ${guest.lastName}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            CheckboxTheme(
                              data: CheckboxThemeData(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    4,
                                  ), // Optional, to make the border rounded
                                  side: BorderSide(
                                    color: Appcolors
                                        .darkGreyColor, // #1B0D38 with 15% opacity
                                    width: 1.5, // Border width
                                  ),
                                ),
                                fillColor: MaterialStateProperty.resolveWith((
                                  states,
                                ) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Appcolors
                                        .primaryColor; // Tick color when selected
                                  }
                                  return Colors
                                      .transparent; // Background color when unchecked
                                }),
                                checkColor: MaterialStateProperty.all(
                                  Appcolors.whiteColor,
                                ), // Tick color
                              ),
                              child: Checkbox(
                                value: taskController.selectedGuests.any(
                                  (g) => g['id'] == guest.id,
                                ),
                                onChanged: (value) {
                                  taskController.inviteGuestForTask(
                                    guest.id!,
                                    "${guest.firstName} ${guest.lastName}",
                                  );
                                },
                              ),
                            ),
                          ],
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

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

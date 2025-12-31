import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/home_controller.dart';
import 'package:knot_iq/l10n/app_localizations.dart';

import 'package:knot_iq/presentation/home_screen/widgets/reminder_tile_widget.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';
import 'package:knot_iq/utils/date_helper.dart';

class UpcommingReminderScreen extends StatefulWidget {
  const UpcommingReminderScreen({super.key});

  @override
  State<UpcommingReminderScreen> createState() =>
      _UpcommingReminderScreenState();
}

class _UpcommingReminderScreenState extends State<UpcommingReminderScreen> {
  HomeController homeController = Get.put(HomeController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.getUpcomingReminders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (homeController) {
        return Scaffold(
          backgroundColor: Appcolors.backgroundColor,
          appBar: AppBar(
            backgroundColor: Appcolors.backgroundColor,
            title: Text(
              AppLocalizations.of(context)!.upComingReminder,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: Container(
                child: homeController.isLoadReminders
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Appcolors.primary2Color,
                            ),
                          ),
                        ),
                      )
                    : homeController.upcomingRemindersList.isEmpty
                    ? Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.noUpcommingReminders,

                                style: TextStyle(
                                  color: Appcolors.blackColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.upcomingReminderEmptyScreenText,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Appcolors.darkGreyColor,
                                  fontSize: headdingfontSize,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: homeController.upcomingRemindersList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // homeController.updateReadNotification(
                              //   homeController.upcomingRemindersList[index],
                              // );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              child: ReminderTileWidget(
                                title:
                                    "${homeController.upcomingRemindersList[index].title}",
                                subtitle:
                                    "${homeController.upcomingRemindersList[index].message} — ${DateHelper.formatStringToDisplay(homeController.upcomingRemindersList[index].dueDate)}",
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

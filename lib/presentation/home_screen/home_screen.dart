import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/home_controller.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/presentation/home_screen/upcomming_reminder_screen.dart';
import 'package:knot_iq/presentation/home_screen/widgets/overview_card_widget.dart';
import 'package:knot_iq/presentation/home_screen/widgets/reminder_tile_widget.dart';
import 'package:knot_iq/profile_screen.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';
import 'package:knot_iq/utils/date_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.runInitialFunctions(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.blackColor,
      body: GetBuilder<HomeController>(
        builder: (homeController) {
          return Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    color: Appcolors.backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: RefreshIndicator(
                    color: Appcolors.primary2Color, //  spinner color
                    backgroundColor: Appcolors.whiteColor, // optional
                    onRefresh: () async {
                      await homeController.getDashboardData(); // API call
                      homeController.getNotificationsSettingsData();
                    },
                    child: SingleChildScrollView(
                      physics:
                          const AlwaysScrollableScrollPhysics(), //  REQUIRED
                      child: Column(
                        children: [
                          SizedBox(height: 12),
                          Stack(
                            children: [
                              // ClipRRect(
                              //   borderRadius: BorderRadius.circular(10),
                              //   child: FadeInImage(
                              //     height: 137,
                              //     width: double.infinity,
                              //     fit: BoxFit.cover,

                              //     placeholder: const AssetImage(
                              //       AssetPath.weddingImage,
                              //     ),

                              //     image: NetworkImage(
                              //       (homeController.userData?.profileImage !=
                              //                   null &&
                              //               homeController
                              //                   .userData!
                              //                   .profileImage!
                              //                   .trim()
                              //                   .isNotEmpty)
                              //           ? "http://51.20.212.163:8906${homeController.userData!.profileImage}"
                              //           : "invalid_url",
                              //     ),

                              //     imageErrorBuilder:
                              //         (context, error, stackTrace) {
                              //           return Image.asset(
                              //             AssetPath.weddingImage,
                              //             fit: BoxFit.cover,
                              //             height: 137,
                              //             width: double.infinity,
                              //           );
                              //         },
                              //   ),
                              // ),
                              Container(
                                height: 137,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(AssetPath.weddingImage),
                                  ),
                                ),
                              ),

                              Positioned(
                                bottom: 10,
                                right: 20,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ProfileScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 28,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(AssetPath.editIcon),
                                        SizedBox(width: 2),
                                        Center(
                                          child: Text(
                                            AppLocalizations.of(context)!.edit,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // ================= Quick Overview =================
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.quickOverview,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Appcolors.blackColor,
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)!.reports,
                                style: TextStyle(
                                  fontSize: bodyfontSize,
                                  color: Color(0xFF2CB9B0),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                flex: 45,
                                child: OverviewCardWidget(
                                  icon: AssetPath.vendorIcon,
                                  title: AppLocalizations.of(context)!.vendors,
                                  currentValue:
                                      (homeController
                                                  .dashboardData
                                                  ?.vendors
                                                  .current ??
                                              0)
                                          .round()
                                          .toString(),
                                  totalValue:
                                      (homeController
                                                  .dashboardData
                                                  ?.vendors
                                                  .target ??
                                              0)
                                          .round()
                                          .toString(),
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                flex: 55,
                                child: OverviewCardWidget(
                                  icon: AssetPath.walletIcon,
                                  title: AppLocalizations.of(
                                    context,
                                  )!.budgetUsed,
                                  currentValue:
                                      (homeController
                                                  .dashboardData
                                                  ?.budget
                                                  .spent ??
                                              0)
                                          .round()
                                          .toString(),
                                  totalValue:
                                      (homeController
                                                  .dashboardData
                                                  ?.budget
                                                  .planned ??
                                              0)
                                          .round()
                                          .toString(),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                flex: 55,
                                child: OverviewCardWidget(
                                  icon: AssetPath.taskDoneIcon,
                                  title: AppLocalizations.of(
                                    context,
                                  )!.tasksDone,
                                  currentValue:
                                      "${(homeController.dashboardData?.tasks.completed ?? 0).round()}",
                                  totalValue:
                                      "${(homeController.dashboardData?.tasks.total ?? 0).round()}",
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                flex: 45,
                                child: OverviewCardWidget(
                                  icon: AssetPath.familyIcon,
                                  title: AppLocalizations.of(context)!.guests,
                                  currentValue:
                                      (homeController
                                                  .dashboardData
                                                  ?.guests
                                                  .attending ??
                                              0)
                                          .round()
                                          .toString(),
                                  totalValue:
                                      (homeController
                                                  .dashboardData
                                                  ?.guests
                                                  .total ??
                                              0)
                                          .round()
                                          .toString(),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // ================= Upcoming Reminders =================
                          homeController.upcomingRemindersList.isEmpty
                              ? SizedBox()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Upcoming Reminders',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Appcolors.blackColor,
                                      ),
                                    ),

                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpcommingReminderScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'View all',
                                        style: TextStyle(
                                          fontSize: bodyfontSize,
                                          color: Color(0xFF2CB9B0),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                          const SizedBox(height: 5),
                          homeController.upcomingRemindersList.isEmpty
                              ? SizedBox()
                              : ListView.separated(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 3,
                                  ),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 1,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    return ReminderTileWidget(
                                      title:
                                          "${homeController.upcomingRemindersList[0].title}",
                                      subtitle:
                                          "${homeController.upcomingRemindersList[0].message} — ${DateHelper.formatStringToDisplay(homeController.upcomingRemindersList[0].dueDate)}",
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

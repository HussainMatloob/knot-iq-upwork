import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/home_controller.dart';
import 'package:knot_iq/controllers/notifications_controller.dart';
import 'package:knot_iq/core/common_widgets/bottom_nav_bar.dart';
import 'package:knot_iq/core/common_widgets/custom_drawer_widget.dart';
import 'package:knot_iq/presentation/main_menu_screen.dart/widgets/floating_action_button.dart';
import 'package:knot_iq/presentation/notification_screen/notification_screen.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (homeController) {
        return WillPopScope(
          onWillPop: () async {
            if (homeController.currentIndex == 0) {
              return true;
            } else {
              homeController.changeTab(0);
              return false;
            }
          },
          child: Scaffold(
            backgroundColor: Appcolors.blackColor,
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  CustomDrawerWidget.openCustomDrawer(context);
                                },
                                icon: Icon(
                                  Icons.menu_rounded,
                                  color: Appcolors.whiteColor,
                                  size: 24,
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                width: 130,
                                child: Image.asset(AssetPath.logoIcon),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationScreen(),
                                    ),
                                  );
                                },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    // Notification Icon
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Appcolors.darkGreyColor,
                                      ),
                                      child: SvgPicture.asset(
                                        AssetPath.notificationActiveIcon,
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),

                                    GetBuilder<NotificationsController>(
                                      builder: (notificationsController) {
                                        return Visibility(
                                          visible:
                                              notificationsController
                                                  .notificationCounts !=
                                              0,
                                          child: Positioned(
                                            top: -4,
                                            right: 6,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Appcolors.redColor,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Appcolors.redColor
                                                        .withOpacity(0.6),
                                                    blurRadius: 6,
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: Center(
                                                  child: Text(
                                                    "${notificationsController.notificationCounts}",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),

                                                // Text(
                                                //   NotificationService.getNotificationsCount()
                                                //       .toString(), //  notification count
                                                //   style: TextStyle(
                                                //     color: Colors.white,
                                                //     fontSize: 11,
                                                //     fontWeight: FontWeight.bold,
                                                //   ),
                                                // ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              // GestureDetector(
                              //   onTap: () {
                              //     Navigator.of(context).push(
                              //       MaterialPageRoute(
                              //         builder: (context) =>
                              //             NotificationScreen(),
                              //       ),
                              //     );
                              //   },

                              //   child: Container(
                              //     padding: EdgeInsets.all(6),
                              //     margin: EdgeInsets.only(right: 12),
                              //     decoration: BoxDecoration(
                              //       shape: BoxShape.circle,
                              //       color: Appcolors.darkGreyColor,
                              //     ),
                              //     child: SvgPicture.asset(
                              //       AssetPath.notificationActiveIcon,
                              //       height: 20,
                              //       width: 20,
                              //     ),
                              //   ),
                              // ),
                              SizedBox(
                                width: Get.locale?.languageCode == 'ar'
                                    ? 10
                                    : 0,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: homeController
                            .bottomBarItemContent[homeController.currentIndex],
                      ),
                      BottomNavBar(),
                    ],
                  ),
                  homeController.currentIndex == 0
                      ? const ExpandableFab()
                      : const SizedBox.shrink(), // now safe, Stack provides unbounded space
                ],
              ),
            ),
            // floatingActionButton: null, we moved FAB into Stack
          ),
        );
      },
    );
  }
}

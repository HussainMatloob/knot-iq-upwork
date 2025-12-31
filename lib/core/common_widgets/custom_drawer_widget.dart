import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/home_controller.dart';
import 'package:knot_iq/languages_screen.dart';

import 'package:knot_iq/presentation/guests_screen/guests_screen.dart';
import 'package:knot_iq/presentation/main_menu_screen.dart/widgets/custom_drawer.dart';

class CustomDrawerWidget {
  static void openCustomDrawer(BuildContext context) {
    double dragStartX = 0.0;
    final bool isArabic = Get.locale?.languageCode == 'ar';

    showGeneralDialog(
      context: context,
      barrierLabel: "Drawer",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
          child: GestureDetector(
            onHorizontalDragStart: (details) {
              dragStartX = details.globalPosition.dx;
            },
            onHorizontalDragUpdate: (details) {
              // Close logic depends on direction
              if (isArabic) {
                if (details.globalPosition.dx > dragStartX + 40) {
                  Navigator.of(context).pop();
                }
              } else {
                if (details.globalPosition.dx < dragStartX - 40) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: GetBuilder<HomeController>(
              init: HomeController(),
              builder: (homeController) {
                return Material(
                  color: Colors.transparent,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        // topLeft: isArabic ? const Radius.circular(16) : Radius.zero,
                        // bottomLeft: isArabic
                        //     ? const Radius.circular(16)
                        //     : Radius.zero,
                        // topRight: !isArabic
                        //     ? const Radius.circular(16)
                        //     : Radius.zero,
                        // bottomRight: !isArabic
                        //     ? const Radius.circular(16)
                        //     : Radius.zero,
                      ),
                    ),
                    child: CustomDrawer(
                      onEditProfile: () => debugPrint("Edit Profile tapped"),
                      onWeddingDateTap: () => debugPrint("Wedding Date tapped"),
                      onGuestsTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => GuestsScreen(),
                          ),
                        );
                      },
                      onLanguageTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => LanguagesScreen(),
                          ),
                        );
                      },
                      onPushNotificationsChanged: (value) {
                        homeController.enablePushNotification(value);
                      },
                      onTaskReminderChanged: (value) {
                        homeController.enableTaskReminder(value);
                      },
                      onPaymentAlertsChanged: (value) {
                        homeController.enablePaymentAlerts(value);
                      },
                      onTermsTap: () => debugPrint("Terms tapped"),
                      onPrivacyTap: () => debugPrint("Privacy tapped"),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        final beginOffset = isArabic ? const Offset(1, 0) : const Offset(-1, 0);

        final offsetAnimation = Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}

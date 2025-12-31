import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:knot_iq/controllers/home_controller.dart';
import 'package:knot_iq/core/common_widgets/custom_logout_dialog.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/presentation/home_screen/widgets/shimmer_widget.dart';
import 'package:knot_iq/presentation/main_menu_screen.dart/widgets/custom_switch_tile.dart';
import 'package:knot_iq/presentation/main_menu_screen.dart/widgets/custom_tile_widget.dart';
import 'package:knot_iq/presentation/main_menu_screen.dart/widgets/tile_headers.dart';
import 'package:knot_iq/profile_screen.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';
import 'package:knot_iq/utils/data_constant.dart';
import 'package:knot_iq/utils/date_helper.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onWeddingDateTap;
  final VoidCallback onGuestsTap;
  final VoidCallback onLanguageTap;
  final ValueChanged<bool> onPushNotificationsChanged;
  final ValueChanged<bool> onTaskReminderChanged;
  final ValueChanged<bool> onPaymentAlertsChanged;
  final VoidCallback onTermsTap;
  final VoidCallback onPrivacyTap;

  const CustomDrawer({
    super.key,
    required this.onEditProfile,
    required this.onWeddingDateTap,
    required this.onGuestsTap,
    required this.onLanguageTap,
    required this.onPushNotificationsChanged,
    required this.onTaskReminderChanged,
    required this.onPaymentAlertsChanged,
    required this.onTermsTap,
    required this.onPrivacyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: Appcolors.backgroundColor,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            // ==== Header ====
            GetBuilder<HomeController>(
              init: HomeController(),
              builder: (homeController) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Appcolors.primaryColor.withAlpha(70),
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: homeController.userData == null
                      ? ShimmerWidget()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                homeController.userData?.profileImage != null &&
                                        homeController
                                            .userData!
                                            .profileImage!
                                            .isNotEmpty
                                    ? CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey.shade200,
                                        child: ClipOval(
                                          child: Image.network(
                                            "http://51.20.212.163:8906${homeController.userData!.profileImage}",
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Icon(
                                                    Icons.person,
                                                    size: 30,
                                                    color: Colors.grey,
                                                  );
                                                },
                                            loadingBuilder:
                                                (
                                                  context,
                                                  child,
                                                  loadingProgress,
                                                ) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return const Center(
                                                    child: SizedBox(
                                                      width: 16,
                                                      height: 16,
                                                      child: SizedBox(),
                                                    ),
                                                  );
                                                },
                                          ),
                                        ),
                                      )
                                    : Icon(
                                        Icons.person,
                                        color: Appcolors.lavenderGray,
                                        size: 30,
                                      ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              homeController.userData?.name ??
                                                  "",
                                              style: TextStyle(
                                                fontSize: headdingfontSize,
                                                fontWeight: FontWeight.w600,
                                                color: Appcolors.blackColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              homeController.userData?.email ??
                                                  "",
                                              style: TextStyle(
                                                color: Appcolors.blackColor,
                                                fontSize: bodyfontSize,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ProfileScreen(),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 13),
                                    child: SvgPicture.asset(
                                      AssetPath.editIcon,
                                      color: Appcolors.blackColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Divider(
                              height: 26,
                              thickness: 1,
                              color: Color(0xFFB3BBC2),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AssetPath.calendarIcon,
                                  color: Appcolors.darkGreyColor,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.wedDate,
                                      style: TextStyle(
                                        fontSize: headdingfontSize,
                                        fontWeight: FontWeight.w600,
                                        color: Appcolors.blackColor,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      DateHelper.formatDate(
                                        homeController.userData?.weddingDate,
                                      ),
                                      style: TextStyle(
                                        color: Appcolors.blackColor,
                                        fontSize: bodyfontSize,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 20,
                                  color: Appcolors.darkGreyColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                );
              },
            ),

            const SizedBox(height: 20),
            TileHeaders(title: AppLocalizations.of(context)!.guestList),
            const SizedBox(height: 6),
            GetBuilder<HomeController>(
              builder: (homeController) {
                return CustomTileWidget(
                  iconPath: AssetPath.familyIcon,
                  title: AppLocalizations.of(context)!.guests,
                  trailingText:
                      '${(homeController.dashboardData?.guests.attending ?? 0).toStringAsFixed(1)}/${(homeController.dashboardData?.guests.total ?? 0).toStringAsFixed(1)}',
                  onTap: onGuestsTap,
                );
              },
            ),

            const SizedBox(height: 16),
            TileHeaders(
              title: AppLocalizations.of(context)!.languagesAndRegion,
            ),
            const SizedBox(height: 6),
            GetBuilder<HomeController>(
              init: HomeController(),
              builder: (homeController) {
                return CustomTileWidget(
                  iconPath: AssetPath.languageIcon,
                  title: AppLocalizations.of(context)!.language,
                  trailingText: DataConstant.languagesList(
                    context,
                  )[homeController.selectedLanguageIndex], //'English',
                  onTap: onLanguageTap,
                );
              },
            ),

            const SizedBox(height: 16),
            TileHeaders(title: AppLocalizations.of(context)!.notifications),
            const SizedBox(height: 6),
            GetBuilder<HomeController>(
              init: HomeController(),
              builder: (homeController) {
                return Column(
                  children: [
                    CustomSwitchTile(
                      iconPath: AssetPath.notificationIcon,
                      title: AppLocalizations.of(context)!.pushNotification,
                      value: homeController.pushNotifications,
                      onChanged: onPushNotificationsChanged,
                    ),
                    const SizedBox(height: 16),
                    CustomSwitchTile(
                      iconPath: AssetPath.taskDoneIcon,
                      title: AppLocalizations.of(context)!.taskReminder,
                      value: homeController.taskReminder,
                      onChanged: onTaskReminderChanged,
                    ),
                    const SizedBox(height: 16),
                    CustomSwitchTile(
                      iconPath: AssetPath.walletIcon,
                      title: AppLocalizations.of(context)!.paymentAlerts,
                      value: homeController.paymentAlerts,
                      onChanged: onPaymentAlertsChanged,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            TileHeaders(title: AppLocalizations.of(context)!.supportAndLegal),
            CustomTileWidget(
              iconPath: AssetPath.termConditionIcon,
              title: AppLocalizations.of(context)!.termAndcondition,
              onTap: onTermsTap,
            ),
            const SizedBox(height: 16),
            CustomTileWidget(
              iconPath: AssetPath.privacyPolicyIcon,
              title: AppLocalizations.of(context)!.privacyPolicy,
              onTap: onPrivacyTap,
            ),
            const SizedBox(height: 16),
            CustomTileWidget(
              iconPath: AssetPath.privacyPolicyIcon,
              title: AppLocalizations.of(context)!.logout,
              onTap: () {
                showLogoutDialog(context);
              },
              isIcon: false,
            ),
          ],
        ),
      ),
    );
  }
}

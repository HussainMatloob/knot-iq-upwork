import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/home_controller.dart';
import 'package:knot_iq/core/common_widgets/custom_bottom_bar_items.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (homeController) {
        return Container(
          // height: 85,
          decoration: BoxDecoration(
            color: Appcolors.whiteColor,
            boxShadow: [
              BoxShadow(
                color: Appcolors.blackColor.withAlpha(10),
                offset: const Offset(
                  0,
                  -2,
                ), // move shadow slightly upward (negative Y)
                blurRadius: 6, // how soft the shadow looks
              ),
            ],
          ),
          child: Row(
            children: [
              CustomBottomBarItems(
                itemKey: 0,
                iconPath: AssetPath.homeIcon,
                activeIconPath: AssetPath.homeActiveIcon,
                label: AppLocalizations.of(context)!.home,
                currentIndex: homeController.currentIndex,
                onTap: homeController.changeTab,
              ),
              CustomBottomBarItems(
                itemKey: 1,
                iconPath: AssetPath.vendorIcon,
                activeIconPath: AssetPath.vendorActiveIcon,
                label: AppLocalizations.of(context)!.vendors,
                currentIndex: homeController.currentIndex,
                onTap: homeController.changeTab,
              ),
              CustomBottomBarItems(
                itemKey: 2,
                iconPath: AssetPath.walletIcon,
                activeIconPath: AssetPath.walletActiveIcon,
                label: AppLocalizations.of(context)!.budget,
                currentIndex: homeController.currentIndex,
                onTap: homeController.changeTab,
              ),
              CustomBottomBarItems(
                itemKey: 3,
                iconPath: AssetPath.taskDoneIcon,
                activeIconPath: AssetPath.taskDoneActiveIcon,
                label: AppLocalizations.of(context)!.tasks,
                currentIndex: homeController.currentIndex,
                onTap: homeController.changeTab,
              ),
            ],
          ),
        );
      },
    );
  }
}

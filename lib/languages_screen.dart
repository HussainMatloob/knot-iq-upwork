import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/home_controller.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/data_constant.dart';

class LanguagesScreen extends StatelessWidget {
  LanguagesScreen({super.key});
  HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    List<String> flages = ["🇬🇧", "🇫🇷", "🇸🇦", "🇪🇸", "🇮🇹"];

    return Scaffold(
      backgroundColor: Appcolors.whiteColor,
      appBar: AppBar(
        backgroundColor: Appcolors.whiteColor,
        title: Text(
          AppLocalizations.of(context)!.selectLanguageText,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: GetBuilder<HomeController>(
        builder: (homeScreen) {
          return Container(
            padding: EdgeInsets.all(16),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: homeController.languages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    homeScreen.selectLanguage(
                      homeController.languages[index],
                      index,
                    );
                  },
                  leading: Text(
                    "${flages[index]} ${DataConstant.languagesList(context)[index]}",
                    style: TextStyle(
                      fontSize: homeController.selectedLanguageIndex == index
                          ? 16
                          : 14,
                      fontWeight: FontWeight.w700,
                      color: homeController.selectedLanguageIndex == index
                          ? Appcolors.primaryColor
                          : Appcolors.blackColor,
                    ),
                  ),
                  trailing: CheckboxTheme(
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
                      fillColor: MaterialStateProperty.resolveWith((states) {
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
                      value:
                          homeController.languages[index] ==
                          homeController.selectedLanguage,
                      onChanged: (value) {
                        homeScreen.selectLanguage(
                          homeController.languages[index],
                          index,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

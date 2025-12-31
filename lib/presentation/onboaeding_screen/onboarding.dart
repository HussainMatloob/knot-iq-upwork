import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/auth_controller.dart';
import 'package:knot_iq/core/common_widgets/action_button.dart';
import 'package:knot_iq/core/configurations.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/data_constant.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        return Scaffold(
          backgroundColor: Appcolors.naviBlue,
          body: SafeArea(
            child: Padding(
              padding: appPadding,
              child: Column(
                children: [
                  SizedBox(height: 10),

                  /// Page Indicator
                  ValueListenableBuilder<int>(
                    valueListenable: authController.currentPage,
                    builder: (context, value, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          DataConstant.onboardingPages(context).length,
                          (index) {
                            final isActive =
                                index <=
                                value; // <= makes previous pages active too
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 8,
                              width: 98,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? const Color(0xFFD4B26A)
                                    : Color(0xFF12253C),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  // ValueListenableBuilder<int>(
                  //   valueListenable: _currentPage,
                  //   builder: (context, value, _) {
                  //     return Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: List.generate(pages.length, (index) {
                  //         final isActive = index == value;
                  //         return AnimatedContainer(
                  //           duration: const Duration(milliseconds: 250),
                  //           margin: const EdgeInsets.symmetric(horizontal: 4),
                  //           height: 8,
                  //           width: 98,
                  //           decoration: BoxDecoration(
                  //             color: isActive
                  //                 ? const Color(0xFFD4B26A)
                  //                 : Color(0xFF12253C),
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //         );
                  //       }),
                  //     );
                  //   },
                  // ),
                  SizedBox(height: 16),

                  /// PageView
                  Expanded(
                    child: PageView.builder(
                      controller: authController.pageController,
                      itemCount: DataConstant.onboardingPages(context).length,
                      onPageChanged: (index) =>
                          authController.currentPage.value = index,
                      itemBuilder: (context, index) {
                        final page = DataConstant.onboardingPages(
                          context,
                        )[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 40,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 220,
                                height: 220,
                                child: SvgPicture.asset(
                                  DataConstant.onboardingPages(
                                    context,
                                  )[index].image,
                                  fit: BoxFit.contain, // keeps aspect ratio
                                  semanticsLabel: 'Onboarding image',
                                ),
                              ),

                              const SizedBox(height: 110),

                              Text(
                                page.title,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width >= 400
                                      ? 22
                                      : 17,
                                  fontWeight: FontWeight.w700,
                                  color: Appcolors.whiteColor,
                                ),
                              ),

                              const SizedBox(height: 10),

                              // Replace subtitle Text widget with this:
                              OnboardingPageData.buildBoldSubtitle(
                                page.subtitle,
                                context,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 5),

                  ValueListenableBuilder<int>(
                    valueListenable: authController.currentPage,
                    builder: (context, value, _) {
                      final isLast =
                          value ==
                          DataConstant.onboardingPages(context).length - 1;
                      return Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                        child: ActionButton(
                          buttonText: isLast
                              ? AppLocalizations.of(context)!.getStarted
                              : AppLocalizations.of(context)!.next,
                          onPressed: () => authController.nextPage(context),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class OnboardingPageData {
  final String image;
  final String title;
  final String subtitle;
  OnboardingPageData({
    required this.image,
    required this.title,
    required this.subtitle,
  });
  static RichText buildBoldSubtitle(String text, BuildContext context) {
    final boldWords = [
      AppLocalizations.of(context)!.onBoardingSplitFirst,
      AppLocalizations.of(context)!.onBoardingSplitSecond,
      AppLocalizations.of(context)!.onBoardingSplitThird,
    ];

    List<TextSpan> spans = [];
    String temp = text;

    for (String word in boldWords) {
      if (temp.contains(word)) {
        final parts = temp.split(word);

        spans.add(TextSpan(text: parts[0])); // normal text
        spans.add(
          TextSpan(
            text: word,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Appcolors.whiteColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        );

        temp = parts.length > 1 ? parts[1] : "";
      }
    }

    if (temp.isNotEmpty) {
      spans.add(TextSpan(text: temp));
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: 14,
          color: Appcolors.whiteColor,
          height: 1.4,
          fontWeight: FontWeight.w300,
        ),
        children: spans,
      ),
    );
  }
}

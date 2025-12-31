import 'package:flutter/material.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/presentation/onboaeding_screen/onboarding.dart';

class DataConstant {
  static List<OnboardingPageData> onboardingPages(BuildContext context) {
    return [
      OnboardingPageData(
        image: 'assets/images/onboarding1.svg',
        title: AppLocalizations.of(context)!.onboardingFirstTitle,
        subtitle: AppLocalizations.of(context)!.onboardingFirstSubtitle,
      ),
      OnboardingPageData(
        image: 'assets/images/onboarding2.svg',
        title: AppLocalizations.of(context)!.onboardingSecondTitle,
        subtitle: AppLocalizations.of(context)!.onboardingSecondSubtitle,
      ),
      OnboardingPageData(
        image: 'assets/images/onboarding3.svg',
        title: AppLocalizations.of(context)!.onboardingThirdTitle,
        subtitle: AppLocalizations.of(context)!.onboardingThirdSubtitle,
      ),
    ];
  }

  static List<String> taskTabs(BuildContext context) {
    return [
      AppLocalizations.of(context)!.allText,
      AppLocalizations.of(context)!.pending,
      AppLocalizations.of(context)!.completedText,
    ];
  }

  static List<String> languagesList(BuildContext context) {
    return [
      AppLocalizations.of(context)!.englishLanguage,
      AppLocalizations.of(context)!.frenchLanguage,
      AppLocalizations.of(context)!.arabicLanguage,
      AppLocalizations.of(context)!.spanishLanguage,
      AppLocalizations.of(context)!.italianLanguage,
    ];
  }
}

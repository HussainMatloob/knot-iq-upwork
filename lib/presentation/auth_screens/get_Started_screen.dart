import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/auth_controller.dart';
import 'package:knot_iq/core/common_widgets/action_button.dart';
import 'package:knot_iq/core/common_widgets/custom_text_form_field.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  AuthController authController = Get.put(AuthController());
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Appcolors.blackColor, // Dark top area
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: GetBuilder<AuthController>(
            builder: (authController) {
              return Form(
                key: formkey,
                child: Column(
                  children: [
                    /// Top dark section (fixed height)
                    //Container(height: 90, color: Appcolors.blackColor),

                    /// Expandable white section
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: IntrinsicHeight(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 24,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Appcolors.naviBlue,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(28),
                                      topRight: Radius.circular(28),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        // height: 320,
                                        child: SvgPicture.asset(
                                          'assets/images/letsStart.svg',

                                          semanticsLabel: 'Red dash paths',
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.getLetsStartText,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          color: Appcolors.whiteColor,
                                        ),
                                      ),

                                      const SizedBox(height: 36),

                                      /// Email Field
                                      CustomTextFormField(
                                        iconColor: Color(0xFF9D99A7),
                                        hintTextColor: Color(0xFF9D99A7),
                                        fillColor: Color(0xFF12253C),
                                        editTextColor: Appcolors.whiteColor,
                                        validateFunction: (value) =>
                                            authController.firstNameValidate(
                                              value,
                                              context,
                                            ),
                                        iconPath: AssetPath.person1Icon,
                                        hint: AppLocalizations.of(
                                          context,
                                        )!.fullNameHintText,
                                        controller: authController.yourName,
                                      ),

                                      const SizedBox(height: 20),
                                      CustomTextFormField(
                                        iconColor: Color(0xFF9D99A7),
                                        hintTextColor: Color(0xFF9D99A7),
                                        fillColor: Color(0xFF12253C),
                                        editTextColor: Appcolors.whiteColor,
                                        validateFunction: (value) =>
                                            authController.partnerNameValidate(
                                              value,
                                              context,
                                            ),
                                        iconPath: AssetPath.familyIcon,
                                        hint: AppLocalizations.of(
                                          context,
                                        )!.partnerNameHintText,
                                        controller: authController.partnerName,
                                      ),

                                      const SizedBox(height: 20),
                                      CustomTextFormField(
                                        iconColor: Color(0xFF9D99A7),
                                        hintTextColor: Color(0xFF9D99A7),
                                        fillColor: Color(0xFF12253C),
                                        editTextColor: Appcolors.whiteColor,
                                        validateFunction: (value) =>
                                            authController.weddingDateValidate(
                                              value,
                                              context,
                                            ),
                                        iconPath: AssetPath.calendarIcon,
                                        hint: AppLocalizations.of(
                                          context,
                                        )!.wedDateHintText,
                                        controller: authController.weddingDate,
                                        onTap: () {
                                          authController.selectDate(
                                            context,
                                            authController.weddingDate,
                                          );
                                        },
                                      ),

                                      const SizedBox(height: 20),
                                      CustomTextFormField(
                                        iconColor: Color(0xFF9D99A7),
                                        hintTextColor: Color(0xFF9D99A7),
                                        fillColor: Color(0xFF12253C),
                                        editTextColor: Appcolors.whiteColor,
                                        validateFunction: (value) =>
                                            authController.locationValidate(
                                              value,
                                              context,
                                            ),
                                        iconPath: AssetPath.locationIcon,
                                        hint: AppLocalizations.of(
                                          context,
                                        )!.locationHintext,
                                        controller: authController.locationCity,
                                      ),

                                      const SizedBox(height: 20),

                                      const SizedBox(height: 24),

                                      authController.letsContinue
                                          ? Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Appcolors
                                                          .primary2Color,
                                                    ),
                                              ),
                                            )
                                          : ActionButton(
                                              buttonText: AppLocalizations.of(
                                                context,
                                              )!.continueText,
                                              onPressed: () {
                                                if (formkey.currentState!
                                                    .validate()) {
                                                  authController
                                                      .letsSignUpComplete(
                                                        context,
                                                      );
                                                }
                                              },
                                            ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

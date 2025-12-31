import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/auth_controller.dart';
import 'package:knot_iq/core/common_widgets/action_button.dart';
import 'package:knot_iq/core/common_widgets/custom_text_form_field.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class GetOtpScreen extends StatelessWidget {
  GetOtpScreen({super.key});

  AuthController authController = Get.put(AuthController());
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Appcolors.blackColor,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Form(
                key: formkey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Appcolors.naviBlue,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28),
                          ),
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.titleApp,
                                style: TextStyle(
                                  fontFamily:
                                      'PlayfairDisplay', // Matches the family name in pubspec.yaml
                                  fontSize: 24,
                                  fontWeight: FontWeight
                                      .w600, // Works if the TTF supports semi-bold
                                  color: Appcolors.primary2Color,
                                ),
                              ),

                              const SizedBox(height: 20),

                              /// Welcome Text
                              Text(
                                AppLocalizations.of(context)!.forgotHedText,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Appcolors.whiteColor,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.resetInstructionDetail,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: headdingfontSize,
                                  color: Appcolors.whiteColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 36),

                              /// Email Field
                              CustomTextFormField(
                                iconColor: Color(0xFF9D99A7),
                                hintTextColor: Color(0xFF9D99A7),
                                fillColor: Color(0xFF12253C),
                                editTextColor: Appcolors.whiteColor,
                                controller:
                                    authController.forgotEmailController,
                                validateFunction: (value) => authController
                                    .emailIdValidate(value, context),
                                iconPath: AssetPath.emailIcon,
                                hint: AppLocalizations.of(
                                  context,
                                )!.emailHintText,
                              ),
                              const SizedBox(height: 20),

                              /// Login Button
                              authController.isGetOtp
                                  ? Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Appcolors.primary2Color,
                                        ),
                                      ),
                                    )
                                  : ActionButton(
                                      buttonText: AppLocalizations.of(
                                        context,
                                      )!.sendOtptext,
                                      onPressed: () {
                                        if (formkey.currentState!.validate()) {
                                          authController.getOtp(
                                            context,
                                            isResend: false,
                                          );
                                        }
                                      },
                                    ),

                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.backLoginText,
                                  style: TextStyle(
                                    color: Appcolors.lavenderGray,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

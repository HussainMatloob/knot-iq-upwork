import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/auth_controller.dart';
import 'package:knot_iq/core/common_widgets/action_button.dart';
import 'package:knot_iq/core/common_widgets/custom_text_form_field.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class ResetPasswordScreen extends StatelessWidget {
  String resetToken;
  String email;
  ResetPasswordScreen({
    super.key,
    required this.resetToken,
    required this.email,
  });

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
                                AppLocalizations.of(context)!.resetPasswordText,
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
                                )!.createPasswordText,

                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: headdingfontSize,
                                  color: Appcolors.whiteColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 36),

                              /// Password Field
                              CustomTextFormField(
                                iconColor: Color(0xFF9D99A7),
                                hintTextColor: Color(0xFF9D99A7),
                                fillColor: Color(0xFF12253C),
                                editTextColor: Appcolors.whiteColor,
                                iconPath: AssetPath.passwordIcon,
                                hint: AppLocalizations.of(
                                  context,
                                )!.fullNameHintText,

                                validateFunction: (value) => authController
                                    .passwordValidate(value, context),
                                controller:
                                    authController.newPasswordController,

                                isObSecure: authController.isPasswordObsecure,
                                obSecureTap: () {
                                  authController.setPasswordObSecure();
                                },
                              ),
                              const SizedBox(height: 20),

                              /// Confirm Password Field
                              CustomTextFormField(
                                iconColor: Color(0xFF9D99A7),
                                hintTextColor: Color(0xFF9D99A7),
                                fillColor: Color(0xFF12253C),
                                editTextColor: Appcolors.whiteColor,
                                iconPath: AssetPath.passwordIcon,
                                controller:
                                    authController.newConfirmPasswordController,
                                hint: AppLocalizations.of(
                                  context,
                                )!.confirmPasswordHintText,

                                isObSecure:
                                    authController.isConfirmPasswordObsecure,
                                obSecureTap: () {
                                  authController.setConfirmPasswordObSecure();
                                },
                              ),
                              const SizedBox(height: 20),

                              /// Login Button
                              authController.isReset
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
                                      )!.resetPasswordText,
                                      onPressed: () {
                                        if (formkey.currentState!.validate()) {
                                          authController.resetYourPassword(
                                            context,
                                            resetToken,
                                            email,
                                          );
                                        }
                                      },
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

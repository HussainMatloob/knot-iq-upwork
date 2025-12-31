import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/auth_controller.dart';
import 'package:knot_iq/core/common_widgets/action_button.dart';
import 'package:knot_iq/core/common_widgets/custom_text_form_field.dart';
import 'package:knot_iq/features/auth/view/login/login_screen.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
                child: Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
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
                            child: IntrinsicHeight(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /// Accent Circle
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFD4B26A),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  /// Header Texts
                                  Text(
                                    AppLocalizations.of(context)!.titleApp,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Appcolors.whiteColor,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    AppLocalizations.of(context)!.letsStartText,
                                    style: TextStyle(
                                      fontSize: headdingfontSize,
                                      color: Appcolors.whiteColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 36),

                                  /// Name Field
                                  CustomTextFormField(
                                    iconColor: Color(0xFF9D99A7),
                                    hintTextColor: Color(0xFF9D99A7),
                                    fillColor: Color(0xFF12253C),
                                    editTextColor: Appcolors.whiteColor,
                                    validateFunction: (value) => authController
                                        .firstNameValidate(value, context),
                                    iconPath: AssetPath.personIcon,
                                    hint: AppLocalizations.of(
                                      context,
                                    )!.fullNameHintText,
                                    controller:
                                        authController.fullNameController,
                                  ),
                                  const SizedBox(height: 20),

                                  /// Email Field
                                  CustomTextFormField(
                                    iconColor: Color(0xFF9D99A7),
                                    hintTextColor: Color(0xFF9D99A7),
                                    fillColor: Color(0xFF12253C),
                                    editTextColor: Appcolors.whiteColor,
                                    validateFunction: (value) => authController
                                        .emailIdValidate(value, context),
                                    iconPath: AssetPath.emailIcon,
                                    hint: AppLocalizations.of(
                                      context,
                                    )!.emailHintText,
                                    controller: authController.emailController,
                                  ),
                                  const SizedBox(height: 20),

                                  /// Password Field
                                  CustomTextFormField(
                                    iconColor: Color(0xFF9D99A7),
                                    hintTextColor: Color(0xFF9D99A7),
                                    fillColor: Color(0xFF12253C),
                                    editTextColor: Appcolors.whiteColor,
                                    iconPath: AssetPath.passwordIcon,
                                    hint: AppLocalizations.of(
                                      context,
                                    )!.passwordHintText,

                                    validateFunction: (value) => authController
                                        .passwordValidate(value, context),
                                    controller:
                                        authController.passwordController,

                                    isObSecure:
                                        authController.isPasswordObsecure,
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
                                    controller: authController
                                        .confirmPasswordController,
                                    hint: AppLocalizations.of(
                                      context,
                                    )!.confirmPasswordHintText,

                                    isObSecure: authController
                                        .isConfirmPasswordObsecure,
                                    obSecureTap: () {
                                      authController
                                          .setConfirmPasswordObSecure();
                                    },
                                  ),

                                  const SizedBox(height: 24),

                                  /// Signup Button
                                  authController.isSignupLoading
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
                                          )!.signUp,
                                          onPressed: () {
                                            if (formkey.currentState!
                                                .validate()) {
                                              authController.signUpUser(
                                                context,
                                              );
                                            }
                                          },
                                        ),
                                  const SizedBox(height: 16),

                                  /// Divider with OR
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Appcolors.greyColor,
                                          thickness: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!.orText,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Appcolors.whiteColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Appcolors.greyColor,
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// Apple Sign-in
                                  // const SizedBox(height: 20),
                                  // SocialButtonWidget(
                                  //   icon: Icons.apple,
                                  //   text: "Sign in with Apple",
                                  //   background: Colors.black,
                                  //   textColor: Colors.white,
                                  //   onTap: () {},
                                  // ),

                                  // const SizedBox(height: 12),

                                  // /// Google Sign-in
                                  // SocialButtonWidget(
                                  //   iconAsset: AssetPath.googleIcon,
                                  //   text: "Sign in with Google",
                                  //   background: Colors.white,
                                  //   textColor: Colors.black87,
                                  //   borderColor: Colors.grey.shade300,
                                  //   onTap: () {},
                                  // ),
                                  const SizedBox(height: 20),

                                  /// Already have an account
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.alreadyAccount,
                                        style: TextStyle(
                                          color: Appcolors.whiteColor,
                                          fontSize: bodyfontSize,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen(),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 2.0,
                                            vertical: 12,
                                          ),
                                          child: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.loginText,
                                            style: TextStyle(
                                              color: Appcolors.primaryColor,
                                              fontSize: bodyfontSize,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

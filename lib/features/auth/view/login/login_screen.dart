import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/auth_controller.dart';
import 'package:knot_iq/core/common_widgets/action_button.dart';
import 'package:knot_iq/core/common_widgets/custom_text_form_field.dart';
import 'package:knot_iq/features/auth/forgot/get_otp_screen.dart';
import 'package:knot_iq/features/auth/view/signup/signup_screen.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                                  AppLocalizations.of(context)!.welcomeText,
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

                                /// Email Field
                                CustomTextFormField(
                                  iconColor: Color(0xFF9D99A7),
                                  hintTextColor: Color(0xFF9D99A7),
                                  fillColor: Color(0xFF12253C),
                                  editTextColor: Appcolors.whiteColor,
                                  controller:
                                      authController.loginEmailController,
                                  validateFunction: (value) => authController
                                      .emailIdValidate(value, context),
                                  iconPath: AssetPath.emailIcon,
                                  hint: AppLocalizations.of(
                                    context,
                                  )!.emailHintText,
                                ),
                                const SizedBox(height: 20),

                                /// Password Field
                                CustomTextFormField(
                                  iconColor: Color(0xFF9D99A7),
                                  hintTextColor: Color(0xFF9D99A7),
                                  fillColor: Color(0xFF12253C),
                                  editTextColor: Appcolors.whiteColor,
                                  controller:
                                      authController.loginPasswordController,
                                  validateFunction: (value) => authController
                                      .loginpPasswordValidate(value, context),
                                  iconPath: AssetPath.passwordIcon,
                                  hint: AppLocalizations.of(
                                    context,
                                  )!.passwordHintText,
                                  isObSecure:
                                      authController.isloginPasswordObsecure,
                                  obSecureTap: () {
                                    authController.setLoginPasswordObSecure();
                                  },
                                ),

                                const SizedBox(height: 20),

                                /// Login Button
                                authController.isLogin
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
                                        )!.login,
                                        onPressed: () {
                                          if (formkey.currentState!
                                              .validate()) {
                                            authController.loginUser(context);
                                          }
                                        },
                                      ),

                                const SizedBox(height: 12),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => GetOtpScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.forgot,
                                    style: TextStyle(
                                      color: Appcolors.whiteColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

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

                                // const SizedBox(height: 20),

                                // /// Apple Sign-in
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
                                const SizedBox(height: 24),

                                /// Signup Text
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.hereText,
                                      style: TextStyle(
                                        color: Appcolors.whiteColor,
                                        fontSize: bodyfontSize,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SignupScreen(),
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
                                          )!.createAccount,
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
                                const SizedBox(height: 20),
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
          ),
        );
      },
    );
  }
}

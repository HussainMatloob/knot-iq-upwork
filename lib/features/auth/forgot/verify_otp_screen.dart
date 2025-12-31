import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/auth_controller.dart';
import 'package:knot_iq/core/common_widgets/action_button.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  AuthController authController = Get.put(AuthController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.startResendTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.blackColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: Appcolors.naviBlue,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text(
                  AppLocalizations.of(context)!.titleApp,
                  style: TextStyle(
                    fontFamily:
                        'PlayfairDisplay', // Matches the family name in pubspec.yaml
                    fontSize: 24,
                    fontWeight:
                        FontWeight.w600, // Works if the TTF supports semi-bold
                    color: Appcolors.primary2Color,
                  ),
                ),

                const SizedBox(height: 20),

                /// Welcome Text
                Text(
                  AppLocalizations.of(context)!.verifyEmailText,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Appcolors.whiteColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.enterCodeText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: headdingfontSize,
                    color: Appcolors.whiteColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.email,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: headdingfontSize,
                    color: Appcolors.primary2Color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 30),

                // Email Field
                PinCodeTextField(
                  controller: authController.pinController,

                  appContext: context,
                  length: 6,
                  cursorColor: Appcolors.whiteColor,
                  keyboardType: TextInputType.number,
                  //obscureText: true,
                  //obscuringCharacter: '*',
                  enabled: true,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 45,
                    fieldWidth: 45,
                    // Hide border by setting its color to transparent
                    activeColor: Colors.transparent,
                    inactiveColor: Colors.transparent,
                    selectedColor: Colors.transparent,

                    // Ensure background is gray for all states
                    activeFillColor: Color(
                      0xFF12253C,
                    ), // Background when active
                    inactiveFillColor: Color(
                      0xFF12253C,
                    ), // Background when inactive
                    selectedFillColor: Color(
                      0xFF12253C,
                    ), // Background when selected
                  ),
                  // Set text color to white
                  textStyle: TextStyle(
                    color: Colors.white, // White text color
                    fontSize: 20, // You can adjust the font size as needed
                  ),

                  enableActiveFill: true,
                ),

                const SizedBox(height: 20),

                /// Login Button
                GetBuilder<AuthController>(
                  id: 'verify_btn',
                  builder: (authController) {
                    return authController.isVerifyOtp
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
                            )!.verifyText,
                            onPressed: () {
                              authController.verifyOtp(context, widget.email);
                            },
                          );
                  },
                ),

                const SizedBox(height: 20),
                GetBuilder<AuthController>(
                  id: 'timer',
                  builder: (authController) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: authController.secondsLeft == 00,
                          child: TextButton(
                            onPressed: () {
                              authController.startResendTimer();
                              authController.getOtp(context, isResend: true);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.resendText,
                              style: TextStyle(
                                color: Appcolors.lavenderGray,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: authController.secondsLeft != 00,
                          child: Text(
                            "(00:${authController.secondsLeft.toString().padLeft(2, '0')})",
                            style: TextStyle(
                              color: Appcolors.whiteColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

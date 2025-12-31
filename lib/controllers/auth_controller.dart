import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:knot_iq/controllers/notifications_controller.dart';
import 'package:knot_iq/data/base_apis.dart';
import 'package:knot_iq/data/server_exceptions.dart';
import 'package:knot_iq/features/auth/forgot/reset_password_screen.dart';
import 'package:knot_iq/features/auth/forgot/verify_otp_screen.dart';
import 'package:knot_iq/features/auth/view/login/login_screen.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/presentation/auth_screens/get_Started_screen.dart';
import 'package:knot_iq/presentation/main_menu_screen.dart/main_menu_screen.dart';
import 'package:knot_iq/presentation/onboaeding_screen/onboarding.dart';
import 'package:knot_iq/services/apis_request.dart';
import 'package:knot_iq/utils/app_url.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/data_constant.dart';
import 'package:knot_iq/utils/flush_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class AuthController extends GetxController {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController forgotEmailController = TextEditingController();
  TextEditingController resetEmailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newConfirmPasswordController = TextEditingController();

  TextEditingController yourName = TextEditingController();
  TextEditingController partnerName = TextEditingController();
  TextEditingController weddingDate = TextEditingController();
  TextEditingController locationCity = TextEditingController();

  TextEditingController pinController = TextEditingController();
  FocusNode pinFocusNode = FocusNode();

  bool isPasswordObsecure = true;
  bool isConfirmPasswordObsecure = true;
  bool isloginPasswordObsecure = true;
  bool isLoginLoading = false;
  bool isSignupLoading = false;
  bool letsContinue = false;
  bool isLogin = false;
  bool isGetOtp = false;
  bool isVerifyOtp = false;
  bool isReset = false;

  late VideoPlayerController videoController;
  bool isInitialized = false;
  //String pinCode = '';

  void initVideo(BuildContext context) async {
    final NotificationsController controller =
        Get.isRegistered<NotificationsController>()
        ? Get.find<NotificationsController>()
        : Get.put(NotificationsController());

    controller.setupInteractionMessage(context);

    videoController = VideoPlayerController.asset(
      "assets/videos/WedPlanSplash.mp4",
    );

    await videoController.initialize();
    videoController.setLooping(false);
    videoController.play();

    isInitialized = true;
    update(); // rebuild UI

    // Navigate AFTER video finishes (8 seconds)
    videoController.addListener(() {
      if (!videoController.value.isPlaying &&
          videoController.value.position >= videoController.value.duration) {
        navigateNext();
      }
    });
  }

  final PageController pageController = PageController();
  final ValueNotifier<int> currentPage = ValueNotifier(0);

  void nextPage(BuildContext context) async {
    if (currentPage.value < DataConstant.onboardingPages(context).length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setBool("isOnbording", true);
      // Handle "Get Started" or navigation
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(const SnackBar(content: Text('Onboarding completed!')));
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  int secondsLeft = 30;
  Timer? timer;
  bool canResend = true;
  void startResendTimer() {
    if (!canResend) return;

    secondsLeft = 30;
    canResend = false;
    update(['timer']);

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft == 0) {
        timer.cancel();

        canResend = true;
        update(['timer']);
      } else {
        secondsLeft--;
        update(['timer']);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // void savePinValue(String value) {
  //   pinCode = value;
  //   update();
  // }

  void navigateNext() async {
    // Check if already navigated
    if (!Get.isRegistered<AuthController>()) return;

    SharedPreferences sp = await SharedPreferences.getInstance();
    bool isLogin = sp.getBool("isLogin") ?? false;

    String? token = sp.getString("token");
    bool isOnBording = sp.getBool("isOnbording") ?? false;
    bool isLetsSignup = sp.getBool("isLetsSignup") ?? false;
    BaseApi.setAuthToken(token);

    if (Get.context == null) return; // safety check

    if (isLetsSignup) {
      Navigator.of(Get.context!).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => GetStartedScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      if (isOnBording) {
        if (token != null && isLogin) {
          Navigator.of(Get.context!).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MainMenuScreen()),
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.of(Get.context!).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        Navigator.of(Get.context!).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  void onClose() {
    videoController.dispose();
    super.onClose();
  }

  /*---------------------------------------------------------------*/
  /*                            date selector                      */
  /*---------------------------------------------------------------*/
  DateTime selectedDate = DateTime.now();
  Future<void> selectDate(
    BuildContext context,
    TextEditingController dateController,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      // Use the date property to keep only the date part without the time component
      selectedDate = DateTime(picked.year, picked.month, picked.day);
      // Format the date using DateFormat
      dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      update();
    }
  }

  /*------------------------------------------------------------*/
  /*                        set obsecure value                  */
  /*------------------------------------------------------------*/
  void setPasswordObSecure() {
    isPasswordObsecure = !isPasswordObsecure;
    update();
  }

  void setConfirmPasswordObSecure() {
    isConfirmPasswordObsecure = !isConfirmPasswordObsecure;
    update();
  }

  void setLoginPasswordObSecure() {
    isloginPasswordObsecure = !isloginPasswordObsecure;
    update();
  }

  /*----------------------------------------------------------------------*/
  /*                         check and validations                        */
  /*----------------------------------------------------------------------*/

  String? firstNameValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.nameValidate;
    }
    return null;
  }

  String? partnerNameValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.partnerValidate;
    }
    return null;
  }

  String? weddingDateValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.wedDateValidate;
    }
    return null;
  }

  String? locationValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.locationValidate;
    }
    return null;
  }

  String? emailIdValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.emailValidate;
    }
    bool emailReg = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(value);
    if (emailReg == false) {
      return AppLocalizations.of(context)!.validEmailValidate;
    }
    return null;
  }

  String? passwordValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.newPasswordValidate;
    }

    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[#$@!%*?&])[A-Za-z\d#$@!%*?&]{8,}$',
    );
    bool password = passwordRegex.hasMatch(value);
    if (password == false) {
      return AppLocalizations.of(context)!.strongPasswordValidate;
    }
    return null;
  }

  String? loginpPasswordValidate(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.passwordValidate;
    }
    return null;
  }
  /*-----------------------------------------------------------*/
  /*                          signup  user                     */
  /*-----------------------------------------------------------*/

  Future<void> signUpUser(BuildContext context) async {
    try {
      final serviceAccountJson = await FirebaseMessaging.instance.getToken();
      if (passwordController.text == confirmPasswordController.text) {
        isSignupLoading = true;
        update();
        final Map<String, dynamic> queryParams = {
          "email": emailController.text,
          "password": confirmPasswordController.text,
          "name": fullNameController.text,
          "fcmToken": serviceAccountJson,
        };

        final response = await ApiRequest().postRequest(
          AppUrl.registerApiEndPoint,
          queryParameters: queryParams,
        );

        if (response.statusCode == 201) {
          FlushMessages.commonToast(
            AppLocalizations.of(context)!.signUpSuccess,

            backGroundColor: Appcolors.primaryColor,
          );
          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.setString("token", "${response.data['data']['token']}");
          sp.setBool("isLetsSignup", true);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => GetStartedScreen()),
            (Route<dynamic> route) => false, // removes all previous routes
          );
          emailController.clear();
          confirmPasswordController.clear();
          fullNameController.clear();
        } else {
          FlushMessages.commonToast(
            "${response.data['message']}",
            backGroundColor: Appcolors.darkGreyColor,
          );
        }
      } else {
        FlushMessages.commonToast(
          AppLocalizations.of(context)!.passwordMatchValidate,
          backGroundColor: Appcolors.darkGreyColor,
        );
      }
      // ResponseResult.success(data.map((e) => ContestItem.fromJson(e)).toList());
    } on AppException catch (error) {
      // debugPrint(
      //   "${error.runtimeType} =========___--------------occurred: ${error.message}",
      // );
      FlushMessages.commonToast(
        error.message,
        backGroundColor: Appcolors.darkGreyColor,
      );
      //  ResponseResult.failure(error);
    } catch (error) {
      // debugPrint("================Unknown error occurred: $error");
      FlushMessages.commonToast(
        "$error",
        backGroundColor: Appcolors.darkGreyColor,
      );
      // ResponseResult.failure(UnknownException());
    } finally {
      isSignupLoading = false;
      update();
    }
  }

  /*-----------------------------------------------------------*/
  /*                  lets complete Signup                     */
  /*-----------------------------------------------------------*/
  Future<void> letsSignUpComplete(BuildContext context) async {
    try {
      letsContinue = true;
      SharedPreferences sp = await SharedPreferences.getInstance();
      String? token = sp.getString("token");
      BaseApi.setAuthToken(token);
      update();
      final Map<String, dynamic> queryData = {
        "name": yourName.text,
        "partnerName": partnerName.text,
        "weddingDate": weddingDate.text,
        "weddingLocation": locationCity.text,
      };

      final response = await ApiRequest().postRequest(
        AppUrl.onBoardingApiEndPoint,
        queryParameters: queryData,
        isAuthenticated: true,
      );

      if (response.statusCode == 200) {
        FlushMessages.commonToast(
          AppLocalizations.of(context)!.authSuccess,
          backGroundColor: Appcolors.primaryColor,
        );
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setBool("isLetsSignup", false);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false, // removes all previous routes
        );
        yourName.clear();
        partnerName.clear();
        weddingDate.clear();
        locationCity.clear();
      } else {
        FlushMessages.commonToast(
          "${response.data['message']}",
          backGroundColor: Appcolors.darkGreyColor,
        );
      }
    } on AppException catch (error) {
      FlushMessages.commonToast(
        error.message,
        backGroundColor: Appcolors.darkGreyColor,
      );
    } catch (error) {
      FlushMessages.commonToast(
        "$error",
        backGroundColor: Appcolors.darkGreyColor,
      );
    } finally {
      letsContinue = false;
      update();
    }
  }

  /*-----------------------------------------------------------*/
  /*                       user login                          */
  /*-----------------------------------------------------------*/

  Future<void> loginUser(BuildContext context) async {
    try {
      isLogin = true;
      update();
      final Map<String, dynamic> queryData = {
        "email": loginEmailController.text,
        "password": loginPasswordController.text,
      };

      final response = await ApiRequest().postRequest(
        AppUrl.loginApiEndPoint,
        queryParameters: queryData,
        isAuthenticated: true,
      );

      if (response.statusCode == 200) {
        FlushMessages.commonToast(
          AppLocalizations.of(context)!.loginSuccess,
          backGroundColor: Appcolors.primaryColor,
        );
        SharedPreferences sp = await SharedPreferences.getInstance();
        final data = response.data;
        final token = data['data']['token'];
        sp.setBool("isLogin", true);
        sp.setString("token", token);
        BaseApi.setAuthToken(token);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainMenuScreen()),
          (Route<dynamic> route) => false, // removes all previous routes
        );
        loginEmailController.clear();
        loginPasswordController.clear();
      } else {
        FlushMessages.commonToast(
          "${response.data['message']}",
          backGroundColor: Appcolors.darkGreyColor,
        );
      }
    } on AppException catch (error) {
      FlushMessages.commonToast(
        error.message,
        backGroundColor: Appcolors.darkGreyColor,
      );
    } catch (error) {
      FlushMessages.commonToast(
        "$error",
        backGroundColor: Appcolors.darkGreyColor,
      );
    } finally {
      isLogin = false;
      update();
    }
  }

  /*-----------------------------------------------------------*/
  /*                          get otp                          */
  /*-----------------------------------------------------------*/

  Future<void> getOtp(BuildContext context, {required isResend}) async {
    try {
      if (!isResend) {
        isGetOtp = true;
        update();
      }

      final Map<String, dynamic> queryData = {
        "email": forgotEmailController.text,
      };

      final response = await ApiRequest().postRequest(
        AppUrl.getOtpApiEndPoint,
        queryParameters: queryData,
        isAuthenticated: true,
      );

      if (response.statusCode == 200) {
        FlushMessages.commonToast(
          isResend
              ? AppLocalizations.of(context)!.otpResentSuccess
              : AppLocalizations.of(context)!.otpSentSuccess,
          backGroundColor: Appcolors.primaryColor,
        );
        if (!isResend) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  VerifyOtpScreen(email: forgotEmailController.text),
            ),
            (Route<dynamic> route) => false, // removes all previous routes
          );
        }
      } else {
        FlushMessages.commonToast(
          "${response.data['message']}",
          backGroundColor: Appcolors.darkGreyColor,
        );
      }
    } on AppException catch (error) {
      FlushMessages.commonToast(
        error.message,
        backGroundColor: Appcolors.darkGreyColor,
      );
    } catch (error) {
      FlushMessages.commonToast(
        "$error",
        backGroundColor: Appcolors.darkGreyColor,
      );
    } finally {
      isGetOtp = false;
      update();
    }
  }

  /*-----------------------------------------------------------*/
  /*                       verify otp                          */
  /*-----------------------------------------------------------*/

  Future<void> verifyOtp(BuildContext context, String email) async {
    try {
      if (pinController.text.isEmpty) {
        FlushMessages.commonToast(
          AppLocalizations.of(context)!.validatePinCode,
          backGroundColor: Appcolors.darkGreyColor,
        );
      } else {
        isVerifyOtp = true;
        update(['verify_btn']);
        final Map<String, dynamic> queryData = {
          "email": forgotEmailController.text,
          "otp": pinController.text,
        };

        final response = await ApiRequest().postRequest(
          AppUrl.verifyOtpApiEndPoint,
          queryParameters: queryData,
          isAuthenticated: true,
        );

        if (response.statusCode == 200) {
          var resetToken = response.data["data"]["resetToken"];
          FlushMessages.commonToast(
            AppLocalizations.of(context)!.otpverifiedSuccess,
            backGroundColor: Appcolors.primaryColor,
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  ResetPasswordScreen(resetToken: resetToken, email: email),
            ),
            (Route<dynamic> route) => false, // removes all previous routes
          );
        } else {
          FlushMessages.commonToast(
            "${response.data['message']}",
            backGroundColor: Appcolors.darkGreyColor,
          );
        }
      }
    } on AppException catch (error) {
      FlushMessages.commonToast(
        error.message,
        backGroundColor: Appcolors.darkGreyColor,
      );
    } catch (error) {
      FlushMessages.commonToast(
        "$error",
        backGroundColor: Appcolors.darkGreyColor,
      );
    } finally {
      isVerifyOtp = false;
      update(['verify_btn']);
    }
  }

  /*-----------------------------------------------------------*/
  /*                  reset your password                      */
  /*-----------------------------------------------------------*/

  Future<void> resetYourPassword(
    BuildContext context,
    String resetToken,
    String email,
  ) async {
    if (newPasswordController.text != newConfirmPasswordController.text) {
      FlushMessages.commonToast(
        AppLocalizations.of(context)!.passwordMatchValidate,
        backGroundColor: Appcolors.darkGreyColor,
      );
      return;
    }

    try {
      isReset = true;
      update();
      final Map<String, dynamic> queryData = {
        "email": email,
        "resetToken": resetToken,
        "newPassword": newConfirmPasswordController.text,
      };

      final response = await ApiRequest().postRequest(
        AppUrl.resetPasswordApiEndpoint,
        queryParameters: queryData,
        isAuthenticated: true,
      );

      if (response.statusCode == 200) {
        FlushMessages.commonToast(
          AppLocalizations.of(context)!.passwordUpdateSuccess,
          backGroundColor: Appcolors.primaryColor,
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false, // removes all previous routes
        );
      } else {
        FlushMessages.commonToast(
          "${response.data['message']}",
          backGroundColor: Appcolors.darkGreyColor,
        );
      }
    } on AppException catch (error) {
      FlushMessages.commonToast(
        error.message,
        backGroundColor: Appcolors.darkGreyColor,
      );
    } catch (error) {
      FlushMessages.commonToast(
        "$error",
        backGroundColor: Appcolors.darkGreyColor,
      );
    } finally {
      isReset = false;
      update();
    }
  }
}

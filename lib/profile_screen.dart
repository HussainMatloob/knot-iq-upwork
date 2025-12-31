import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/home_controller.dart';
import 'package:knot_iq/core/common_widgets/custom_text_form_field.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  HomeController homeController = Get.put(HomeController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.getYourData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Appcolors.backgroundColor,
        title: Text(
          AppLocalizations.of(context)!.profileTitle,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: GetBuilder<HomeController>(
        builder: (homeController) {
          return homeController.isGetProfileLoading
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Appcolors.primary2Color,
                      ),
                    ),
                  ),
                )
              : homeController.userData == null
              ? Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.noProfileDataText,

                          style: TextStyle(
                            color: Appcolors.blackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          AppLocalizations.of(context)!.emptyProfileScreenText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Appcolors.darkGreyColor,
                            fontSize: headdingfontSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 5),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            AppLocalizations.of(context)!.refreshText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Appcolors.primaryColor,
                              fontSize: headdingfontSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Form(
                  key: formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: Appcolors.backgroundColor),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Profile Image
                                  Container(
                                    width: 86, // image size + border
                                    height: 86,
                                    // border thickness
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Appcolors.primary2Color,
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: SizedBox(
                                        width: 80,
                                        height: 80,
                                        child:
                                            homeController.profileImage == null
                                            //  NETWORK IMAGE
                                            ? Image.network(
                                                "http://51.20.212.163:8906${homeController.userData!.profileImage}",
                                                fit: BoxFit.cover,
                                                loadingBuilder:
                                                    (
                                                      context,
                                                      child,
                                                      loadingProgress,
                                                    ) {
                                                      if (loadingProgress ==
                                                          null)
                                                        return child;
                                                      return Center(
                                                        child: SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child: SizedBox(),
                                                        ),
                                                      );
                                                    },
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Icon(
                                                        Icons.person,
                                                        size: 40,
                                                        color: Appcolors
                                                            .lavenderGray,
                                                      );
                                                    },
                                              )
                                            : Image.file(
                                                homeController.profileImage!,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  ),

                                  // Edit Button
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        homeController.picOrCaptureImage(
                                          true,
                                          context,
                                        );
                                      },
                                      child: Container(
                                        height: 26,
                                        width: 26,
                                        decoration: BoxDecoration(
                                          color: Appcolors.primaryColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.edit,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Text(
                            AppLocalizations.of(context)!.capitalNameText,
                            style: TextStyle(
                              color: Appcolors.darkGreyColor,
                              fontSize: headdingfontSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 6),
                          CustomTextFormField(
                            validateFunction: (value) => homeController
                                .firstNameValidate(value, context),
                            iconPath: AssetPath.personIcon,
                            hint: AppLocalizations.of(context)!.fullNameText,
                            controller: homeController.nameController,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            AppLocalizations.of(context)!.dateText,
                            style: TextStyle(
                              color: Appcolors.darkGreyColor,
                              fontSize: headdingfontSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 6),
                          CustomTextFormField(
                            validateFunction: (value) => homeController
                                .weddingDateValidate(value, context),
                            iconPath: AssetPath.calendarIcon,
                            hint: AppLocalizations.of(context)!.wedDateHintText,
                            controller: homeController.dateController,
                            onTap: () {
                              homeController.selectDate(
                                context,
                                homeController.dateController,
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                          Text(
                            AppLocalizations.of(context)!.emailText,
                            style: TextStyle(
                              color: Appcolors.darkGreyColor,
                              fontSize: headdingfontSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 6),
                          CustomTextFormField(
                            isReedOnly: true,
                            validateFunction: (value) =>
                                homeController.emailIdValidate(value, context),
                            iconPath: AssetPath.emailIcon,
                            hint: AppLocalizations.of(context)!.emailHintText,
                            controller: homeController.emailController,
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    homeController.updateUserProfile(context);
                                  }
                                },
                                child: homeController.isUpdateLoading
                                    ? Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Appcolors.primaryColor,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 45,
                                        padding: EdgeInsets.all(10),
                                        width: 160,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color: Appcolors.primaryColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.updateText,
                                            style: TextStyle(
                                              color: Appcolors.whiteColor,
                                              fontSize: headdingfontSize,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/vendor_controller.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class ChooseImageSourceBottomSheet extends StatefulWidget {
  const ChooseImageSourceBottomSheet({super.key});

  @override
  State<ChooseImageSourceBottomSheet> createState() =>
      _ChooseImageSourceBottomSheetState();
}

class _ChooseImageSourceBottomSheetState
    extends State<ChooseImageSourceBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorController>(
      init: VendorController(),
      builder: (vendorController) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                          color: Appcolors.blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.chooseText,
                    style: TextStyle(
                      color: Appcolors.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.saveText,
                      style: TextStyle(
                        color: Appcolors.transparentColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  vendorController.picOrCaptureImage(true, context);
                },
                child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Appcolors.whiteColor,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Appcolors.purpleColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AssetPath.galleryIcon,
                            colorFilter: const ColorFilter.mode(
                              Appcolors.darkGreyColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        AppLocalizations.of(context)!.gallerytext,
                        style: TextStyle(
                          color: Appcolors.darkGreyColor,
                          fontSize: headdingfontSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  vendorController.picOrCaptureImage(false, context);
                },
                child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Appcolors.whiteColor,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Appcolors.purpleColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AssetPath.galleryIcon,
                            colorFilter: const ColorFilter.mode(
                              Appcolors.darkGreyColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        AppLocalizations.of(context)!.cameratext,
                        style: TextStyle(
                          color: Appcolors.darkGreyColor,
                          fontSize: headdingfontSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

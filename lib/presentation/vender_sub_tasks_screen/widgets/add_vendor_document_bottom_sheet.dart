import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' show GetBuilder;
import 'package:knot_iq/controllers/vendor_sub_task_controller.dart';
import 'package:knot_iq/utils/asset_path.dart' show AssetPath;
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class AddVendorDocumentBottomSheet extends StatefulWidget {
  const AddVendorDocumentBottomSheet({super.key});

  @override
  State<AddVendorDocumentBottomSheet> createState() =>
      _AddVendorDocumentBottomSheetState();
}

class _AddVendorDocumentBottomSheetState
    extends State<AddVendorDocumentBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorSubTaskController>(
      builder: (vendorSubTaskController) {
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
                      // vendorSubTaskController.clearDocumentsSelection();
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Appcolors.blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Appcolors.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Text(
                "Choose document",
                style: TextStyle(
                  color: Appcolors.darkGreyColor,
                  fontSize: bodyfontSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 6),

              GestureDetector(
                onTap: () {
                  vendorSubTaskController.pickDocument();
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
                        "Document",
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
              SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }
}

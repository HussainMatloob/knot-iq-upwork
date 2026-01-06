import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/vendor_controller.dart';
import 'package:knot_iq/core/common_widgets/bottom_sheet.dart';
import 'package:knot_iq/presentation/vendors_screen/widgets/add_vendor_category_bottom_sheet.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/color_helper.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class VendorTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final String total;
  final String color;
  final String id;
  const VendorTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.total,
    required this.color,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: ColorHelper.hexToColor(color),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.network(
                    "http://51.20.212.163:8906$iconPath",
                    fit: BoxFit
                        .cover, // <-- FIX: force same size, crop extra area
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: SizedBox(
                            width: 15, // smaller width
                            height: 15, // smaller height
                            child: CircularProgressIndicator(
                              strokeWidth: 2, // thin line
                              color: Appcolors.whiteColor, // your color
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image,
                        size: 20,
                        color: Appcolors.darkGreyColor,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: headdingfontSize,
                          fontWeight: FontWeight.w700,
                          color: Appcolors.blackColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 150,
                      child: Text(
                        "$subtitle: ${double.tryParse(total)?.round() ?? 0}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Appcolors.darkGreyColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                GetBuilder<VendorController>(
                  init: VendorController(),
                  builder: (vendorController) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                          onPressed: () {
                            vendorController.initForUpdate(
                              title,
                              subtitle,
                              iconPath,
                              color,
                            );
                            showCustomBottomSheet(
                              minChildSize: 0.45,
                              context: context,
                              initialChildSize: 0.45,
                              maxChildSize: 0.6,
                              child: AddVendorCategoryBottomSheet(
                                isUpdate: true,
                                id: id,
                              ),
                            );
                          },
                          icon: SvgPicture.asset(
                            AssetPath.editIcon,
                            color: Appcolors.darkGreyColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

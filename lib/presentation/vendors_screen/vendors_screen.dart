import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/vendor_controller.dart';
import 'package:knot_iq/core/common_widgets/bottom_sheet.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/presentation/vender_sub_tasks_screen/vender_sub_task_screen.dart';
import 'package:knot_iq/presentation/vendors_screen/widgets/add_vendor_category_bottom_sheet.dart';
import 'package:knot_iq/presentation/vendors_screen/widgets/vendor_tile.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class VendorsScreen extends StatefulWidget {
  const VendorsScreen({super.key});

  @override
  State<VendorsScreen> createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  VendorController vendorController = Get.put(VendorController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vendorController.getCategoryData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorController>(
      builder: (vendorController) {
        return Scaffold(
          backgroundColor: Appcolors.blackColor,
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: const BoxDecoration(
                        color: Appcolors.backgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: vendorController.loadCategoryData
                          ? Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Appcolors.primaryColor,
                                ),
                              ),
                            )
                          : vendorController.cateGoryData.isEmpty
                          ? SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 80),
                                  SvgPicture.asset(AssetPath.notFoundIcon),
                                  SizedBox(height: 24),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.noAddedCategory,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Appcolors.blackColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.categoryEmptyScreen,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Appcolors.darkGreyColor,
                                      fontSize: headdingfontSize,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: vendorController.cateGoryData.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsetsGeometry.only(bottom: 10),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VenderSubTaskScreen(
                                                categoryData: vendorController
                                                    .cateGoryData[index],
                                              ),
                                        ),
                                      );
                                    },
                                    child: VendorTile(
                                      iconPath:
                                          vendorController
                                              .cateGoryData[index]
                                              .icon ??
                                          "",
                                      title:
                                          vendorController
                                              .cateGoryData[index]
                                              .name ??
                                          "",
                                      subtitle:
                                          vendorController
                                              .cateGoryData[index]
                                              .supplierName ??
                                          "",
                                      total:
                                          "${(vendorController.cateGoryData[index].stats!.totalBudget).round() ?? 0}",
                                      color:
                                          vendorController
                                              .cateGoryData[index]
                                              .color ??
                                          "",
                                      id:
                                          vendorController
                                              .cateGoryData[index]
                                              .id ??
                                          "",
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),

              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Appcolors.primaryColor, width: 2),
                  ),
                  child: FloatingActionButton(
                    elevation: 0,
                    backgroundColor: Appcolors.primary2Color,
                    shape: const CircleBorder(),
                    onPressed: () {
                      vendorController.clearData();
                      showCustomBottomSheet(
                        minChildSize: 0.45,
                        context: context,
                        initialChildSize: 0.45,
                        maxChildSize: 0.6,
                        child: AddVendorCategoryBottomSheet(),
                      );
                    },
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

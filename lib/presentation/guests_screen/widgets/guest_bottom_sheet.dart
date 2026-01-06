import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/guests_controller.dart';
import 'package:knot_iq/core/common_widgets/action_button.dart';
import 'package:knot_iq/core/common_widgets/custom_delete_dialog.dart';
import 'package:knot_iq/core/common_widgets/custom_text_form_field.dart';
import 'package:knot_iq/core/common_widgets/switch_button.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/models/guests_data_model.dart';

import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class GuestBottomSheet extends StatefulWidget {
  bool isEditing;
  GuestsDataModel? guestData;
  GuestBottomSheet({super.key, this.isEditing = false, this.guestData});

  @override
  State<GuestBottomSheet> createState() => _GuestBottomSheetState();
}

class _GuestBottomSheetState extends State<GuestBottomSheet> {
  GuestsController guestsController = Get.put(GuestsController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GuestsController>(
      builder: (guestsController) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// CENTER - TITLE (Flexible + Ellipsis)
                      Text(
                        widget.isEditing
                            ? AppLocalizations.of(context)!.updateGuest
                            : AppLocalizations.of(context)!.addGuest,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Appcolors.blackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      /// LEFT - Cancel
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)!.cancelText,
                            style: const TextStyle(
                              color: Appcolors.blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.firstName,
                    style: TextStyle(
                      color: Appcolors.darkGreyColor,
                      fontSize: bodyfontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 6),
                  CustomTextFormField(
                    validateFunction: (value) =>
                        guestsController.firstNameValidate(value, context),
                    hint: AppLocalizations.of(context)!.firstnameHint,
                    controller: guestsController.firstNameController,
                  ),

                  const SizedBox(height: 18),
                  Text(
                    AppLocalizations.of(context)!.lastName,
                    style: TextStyle(
                      color: Appcolors.darkGreyColor,
                      fontSize: bodyfontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 6),
                  CustomTextFormField(
                    validateFunction: (value) =>
                        guestsController.lastNameValidate(value, context),
                    hint: AppLocalizations.of(context)!.lastnameHint,
                    controller: guestsController.lastNameController,
                  ),

                  const SizedBox(height: 18),
                  Text(
                    AppLocalizations.of(context)!.emailText,
                    style: TextStyle(
                      color: Appcolors.darkGreyColor,
                      fontSize: bodyfontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 6),
                  CustomTextFormField(
                    validateFunction: (value) =>
                        guestsController.emailIdValidate(value, context),
                    hint: AppLocalizations.of(context)!.emailHint,
                    controller: guestsController.emailController,
                  ),

                  const SizedBox(height: 18),
                  Text(
                    AppLocalizations.of(context)!.note,
                    style: TextStyle(
                      color: Appcolors.darkGreyColor,
                      fontSize: bodyfontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 6),
                  CustomTextFormField(
                    validateFunction: (value) =>
                        guestsController.noteValidate(value, context),
                    hint: AppLocalizations.of(context)!.noteHint,
                    controller: guestsController.noteController,
                  ),

                  const SizedBox(height: 18),

                  Container(
                    height: 50,
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Appcolors.whiteColor,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AssetPath.addUserIcon,
                          colorFilter: const ColorFilter.mode(
                            Appcolors.primary2Color,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.plusOnes,
                          style: TextStyle(
                            color: Appcolors.darkGreyColor,
                            fontSize: headdingfontSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            guestsController.lessOnce();
                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            // padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Appcolors.primaryColor,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.remove,
                                color: Appcolors.primaryColor,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          guestsController.lessAndAddOnceValue.toString(),
                          style: TextStyle(
                            color: Appcolors.darkGreyColor,
                            fontSize: headdingfontSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            guestsController.addOnce();
                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            // padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Appcolors.primaryColor,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: Appcolors.primaryColor,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    height: 50,
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Appcolors.whiteColor,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AssetPath.tickCircleIcon,
                          colorFilter: const ColorFilter.mode(
                            Appcolors.primary2Color,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.rsvpStatus,
                          style: TextStyle(
                            color: Appcolors.darkGreyColor,
                            fontSize: headdingfontSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        CustomSwitch(
                          value: guestsController.isRsvp,
                          onChanged: (value) {
                            guestsController.setRsvpMode(value);
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  guestsController.isGuestAdd ||
                          guestsController.isGuestUpdate ||
                          guestsController.isGuestDelete
                      ? Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: guestsController.isGuestDelete
                                  ? Appcolors.redColor
                                  : Appcolors.primary2Color,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.isEditing
                                ? Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        customDeleteDialog(
                                          context,
                                          onTap: () {
                                            Navigator.pop(context);
                                            guestsController.deleteGuest(
                                              context,
                                              widget.guestData!,
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        height: 40,
                                        padding: EdgeInsets.all(8),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color: Appcolors.redColor.withAlpha(
                                            20,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.deleteText,
                                            style: TextStyle(
                                              color: Appcolors.redColor,
                                              fontSize: headdingfontSize,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            Visibility(
                              visible: widget.isEditing,
                              child: SizedBox(width: 30),
                            ),

                            /// RIGHT - Save / Update / Loader
                            Expanded(
                              child: InkWell(
                                onTap:
                                    guestsController.isGuestAdd ||
                                        guestsController.isGuestUpdate
                                    ? null
                                    : () {
                                        if (formKey.currentState!.validate()) {
                                          widget.isEditing
                                              ? guestsController.updateGuest(
                                                  context,
                                                  widget.guestData!,
                                                )
                                              : guestsController.addGuest(
                                                  context,
                                                );
                                        }
                                      },
                                child: Container(
                                  height: 40,
                                  padding: EdgeInsets.all(8),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Appcolors.primary2Color,
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.isEditing
                                          ? AppLocalizations.of(
                                              context,
                                            )!.updateText
                                          : AppLocalizations.of(
                                              context,
                                            )!.saveText,
                                      style: const TextStyle(
                                        color: Appcolors.whiteColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

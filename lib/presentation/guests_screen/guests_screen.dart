import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/guests_controller.dart';
import 'package:knot_iq/controllers/notifications_controller.dart';
import 'package:knot_iq/core/common_widgets/bottom_sheet.dart';
import 'package:knot_iq/core/common_widgets/text_field.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/presentation/guests_screen/widgets/guest_bottom_sheet.dart';
import 'package:knot_iq/presentation/guests_screen/widgets/guest_details_box.dart';
import 'package:knot_iq/presentation/guests_screen/widgets/guest_tile_widget.dart';
import 'package:knot_iq/presentation/notification_screen/notification_screen.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class GuestsScreen extends StatefulWidget {
  const GuestsScreen({super.key});

  @override
  State<GuestsScreen> createState() => _GuestsScreenState();
}

class _GuestsScreenState extends State<GuestsScreen> {
  GuestsController guestsController = Get.put(GuestsController());

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      guestsController.getGuestsData(isGetData: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == 0)
        return; // prevent trigger when not scrollable

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        guestsController.getGuestsData(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GuestsController>(
      builder: (guestsController) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Appcolors.blackColor,
            body: Column(
              children: [
                SizedBox(height: 56),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Platform.isAndroid
                            ? Icons.arrow_back
                            : Icons.arrow_back_ios_new_rounded,
                        color: Appcolors.whiteColor,
                        size: 24,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.guests,
                      style: TextStyle(
                        color: Appcolors.whiteColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NotificationScreen(),
                          ),
                        );
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Notification Icon
                          Container(
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Appcolors.darkGreyColor,
                            ),
                            child: SvgPicture.asset(
                              AssetPath.notificationActiveIcon,
                              height: 20,
                              width: 20,
                            ),
                          ),

                          GetBuilder<NotificationsController>(
                            builder: (notificationsController) {
                              return Visibility(
                                visible:
                                    notificationsController
                                        .notificationCounts !=
                                    0,
                                child: Positioned(
                                  top: -4,
                                  right: 6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Appcolors.redColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Appcolors.redColor.withOpacity(
                                            0.6,
                                          ),
                                          blurRadius: 6,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Center(
                                        child: Text(
                                          "${notificationsController.notificationCounts}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Appcolors.backgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GuestDetailsBox(
                              title: AppLocalizations.of(context)!.total,
                              value: (guestsController.totalGuests)
                                  .round()
                                  .toString(),
                            ),
                            SizedBox(width: 16),
                            GuestDetailsBox(
                              title: AppLocalizations.of(context)!.attending,
                              value: (guestsController.attentingGuests)
                                  .round()
                                  .toString(),
                            ),
                            SizedBox(width: 16),
                            GuestDetailsBox(
                              title: AppLocalizations.of(context)!.pending,
                              value: (guestsController.pendingGuests)
                                  .round()
                                  .toString(),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        CustomSearchField(
                          controller: guestsController.searchGuestsController,
                          hintText: AppLocalizations.of(context)!.searchText,
                          prefix: Container(
                            padding: const EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              AssetPath.searchIcon,
                              colorFilter: const ColorFilter.mode(
                                Appcolors.darkGreyColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            guestsController.onSearchChangedDebounced(value);
                          },
                        ),

                        const SizedBox(height: 20),
                        Expanded(
                          child:
                              guestsController.guestsData.isEmpty &&
                                  guestsController.isTyping &&
                                  guestsController.searchGuestsController.text
                                      .trim()
                                      .isNotEmpty
                              ? Center(
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.noMatchingGuest,
                                    style: TextStyle(
                                      color: Appcolors.blackColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )
                              : guestsController.guestsData.isEmpty
                              ? guestsController.isGuestLoading
                                    ? Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Appcolors.primaryColor,
                                          ),
                                        ),
                                      )
                                    : SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 80),
                                            SvgPicture.asset(
                                              AssetPath.notFoundIcon,
                                            ),
                                            SizedBox(height: 24),
                                            Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.noAddedGuest,
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
                                              )!.guestEmptySreenMessage,
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
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  controller: _scrollController,
                                  itemCount:
                                      guestsController.guestsData.length +
                                      (guestsController.hasGuestsMoreData
                                          ? 1
                                          : 0),
                                  itemBuilder: (context, index) {
                                    if (index <
                                        guestsController.guestsData.length) {
                                      final guest =
                                          guestsController.guestsData[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 14,
                                        ),
                                        child: GuestTileWidget(
                                          onTap: () {
                                            guestsController.forUpdateRecord(
                                              guest,
                                            );
                                            showCustomBottomSheet(
                                              minChildSize: 0.8,
                                              context: context,
                                              initialChildSize:
                                                  0.8, // 30% of screen height
                                              maxChildSize:
                                                  0.8, // 80% of screen height
                                              child: GuestBottomSheet(
                                                guestData: guest,
                                                isEditing: true,
                                              ),
                                            );
                                          },
                                          name:
                                              "${guest.firstName ?? ""} ${guest.lastName ?? ""}",

                                          status: guest.rsvpStatus ?? "",
                                          guestCount: guest.plusOnes.toString(),
                                        ),
                                      );
                                    } else {
                                      // Loader at the end
                                      return Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Appcolors.primaryColor,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Appcolors.primaryColor, width: 2),
              ),
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: Appcolors.primary2Color,
                shape: const CircleBorder(),
                onPressed: () {
                  guestsController.clearRecords();
                  showCustomBottomSheet(
                    minChildSize: 0.8,
                    context: context,
                    initialChildSize: 0.8, // 30% of screen height
                    maxChildSize: 0.8, // 80% of screen height
                    child: GuestBottomSheet(),
                  );
                },
                child: const Icon(Icons.add, color: Appcolors.whiteColor),
              ),
            ),
          ),
        );
      },
    );
  }
}

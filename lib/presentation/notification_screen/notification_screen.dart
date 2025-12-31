import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/notifications_controller.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';
import 'package:knot_iq/utils/date_helper.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationsController notificationsController = Get.put(
    NotificationsController(),
  );

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationsController.setFilter("All");
      notificationsController.getNotificationsData(isGetData: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == 0)
        return; // prevent trigger when not scrollable

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        notificationsController.getNotificationsData(loadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsController>(
      builder: (notificationsController) {
        return Scaffold(
          backgroundColor: Appcolors.backgroundColor,
          appBar: AppBar(
            backgroundColor: Appcolors.backgroundColor,
            // elevation: 0.5,
            leading: IconButton(
              icon: Icon(
                Platform.isAndroid
                    ? Icons.arrow_back
                    : Icons.arrow_back_ios_new_rounded,
                color: Colors.black87,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              AppLocalizations.of(context)!.notificationText,
              style: TextStyle(
                color: Appcolors.blackColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              Builder(
                builder: (buttonContext) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      splashColor: Colors.black.withAlpha(40),
                      onTap: () async {
                        final RenderBox button =
                            buttonContext.findRenderObject() as RenderBox;
                        final RenderBox overlay =
                            Overlay.of(buttonContext).context.findRenderObject()
                                as RenderBox;

                        final result = await showMenu<String>(
                          context: buttonContext,
                          color: Colors.white,
                          position: RelativeRect.fromRect(
                            Rect.fromPoints(
                              button.localToGlobal(
                                Offset.zero,
                                ancestor: overlay,
                              ),
                              button.localToGlobal(
                                button.size.bottomRight(Offset.zero),
                                ancestor: overlay,
                              ),
                            ),
                            Offset.zero & overlay.size,
                          ),
                          items: [
                            PopupMenuItem(
                              value: 'all',
                              child: Text(
                                AppLocalizations.of(context)!.allText,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      notificationsController.selectedFilter ==
                                          "All"
                                      ? Appcolors.primary2Color
                                      : Appcolors.blackColor,
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'read',
                              child: Text(
                                AppLocalizations.of(context)!.readText,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      notificationsController.selectedFilter ==
                                          "Read"
                                      ? Appcolors.primary2Color
                                      : Appcolors.blackColor,
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'unread',
                              child: Text(
                                AppLocalizations.of(context)!.unReadText,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      notificationsController.selectedFilter ==
                                          "Unread"
                                      ? Appcolors.primary2Color
                                      : Appcolors.blackColor,
                                ),
                              ),
                            ),
                          ],
                        );

                        if (result == null) return;

                        switch (result) {
                          case 'all':
                            {
                              notificationsController.setFilter("All");
                              notificationsController.getNotificationsData(
                                isGetData: true,
                              );
                            }

                            break;
                          case 'read':
                            {
                              {
                                notificationsController.setFilter("Read");
                                notificationsController.getNotificationsData(
                                  isGetData: true,
                                );
                              }
                            }
                            break;
                          case 'unread':
                            {
                              {
                                notificationsController.setFilter("Unread");
                                notificationsController.getNotificationsData(
                                  isGetData: true,
                                );
                              }
                            }
                            break;
                        }
                      },
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Appcolors.whiteColor,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.more_horiz,
                            color: Colors.black54,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 20),
            ],

            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: Appcolors.greyColor, height: 1.5),
            ),
          ),
          body: notificationsController.loadNotifications
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
              : notificationsController.notificationsData.isEmpty
              ? Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.noNotification,
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
                          )!.notificationEmptyScreenText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Appcolors.darkGreyColor,
                            fontSize: headdingfontSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      notificationsController.notificationsData.length +
                      (notificationsController.hasExpenseMoreData ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index <
                        notificationsController.notificationsData.length) {
                      return Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            if (notificationsController
                                    .notificationsData[index]
                                    .isRead ==
                                false) {
                              notificationsController.updateReadNotification(
                                notificationsController
                                    .notificationsData[index],
                              );
                            }
                          },
                          child: NotificationTile(
                            title:
                                notificationsController
                                    .notificationsData[index]
                                    .title ??
                                "",
                            subtitle:
                                notificationsController
                                    .notificationsData[index]
                                    .message ??
                                "",
                            isUnread: notificationsController
                                .notificationsData[index]
                                .isRead,
                            date: DateHelper.formatStringToDisplay(
                              notificationsController
                                  .notificationsData[index]
                                  .createdAt,
                            ),
                          ),
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
        );
      },
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isUnread;
  final String date;

  const NotificationTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isUnread,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: !isUnread ? const Color(0xFFDDF2F2) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 0), // IMPORTANT → shadow on all sides
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ==== Icon with unread dot ====
            if (!isUnread)
              Container(
                height: 8,
                width: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF2CB9B0),
                  shape: BoxShape.circle,
                ),
              ),
            SizedBox(width: 8),
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: !isUnread ? Colors.white : const Color(0xFFF2F3F4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AssetPath.walletIcon,
                  height: 20,
                  width: 20,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // ==== Title + Subtitle ====
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Appcolors.blackColor,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${subtitle} - ${date}",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Appcolors.blackColor,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

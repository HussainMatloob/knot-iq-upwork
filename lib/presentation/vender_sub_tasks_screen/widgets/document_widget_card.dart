import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:knot_iq/controllers/vendor_sub_task_controller.dart';
import 'package:knot_iq/presentation/vender_sub_tasks_screen/document_view_screen.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/file_extension_helper.dart';
import 'package:knot_iq/utils/thum_nail_helper.dart';

class DocumentWidgetCard extends StatelessWidget {
  final Map<String, dynamic> documents;
  final bool isSingle;
  final int index;
  const DocumentWidgetCard({
    super.key,
    required this.documents,
    this.isSingle = false,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorSubTaskController>(
      builder: (vendorSubTaskController) {
        return GestureDetector(
          onTap: () {
            String url = documents['url'];

            // Detect if file is local
            if (!File(url).existsSync() && !url.startsWith("http")) {
              // Relative path from backend → make full network URL
              url = "http://51.20.212.163:8906$url";
            }

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DocumentViewScreen(url: url),
              ),
            );
          },

          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Appcolors.darkGreyColor.withOpacity(0.2),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
              color: Appcolors.whiteColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Center(
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: ThumNailHelper.buildThumbnail(
                              documents['url'],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            documents['name'] ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Appcolors.darkGreyColor,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              getFileExtension(documents),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Appcolors.darkGreyColor,
                              ),
                            ),

                            SizedBox(width: 10),
                            Container(
                              height: 3,
                              width: 3,
                              decoration: BoxDecoration(
                                color: Color(0xFF645D73),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              documents["url"].toString().startsWith("/uploads")
                                  ? vendorSubTaskController
                                        .formatNetworkFileSize(
                                          double.parse(
                                            documents['size'].toString(),
                                          ),
                                        )
                                  : "${documents['size'] ?? ''}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Appcolors.darkGreyColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    vendorSubTaskController.removeDocument(index, isSingle);
                  },
                  icon: Icon(Icons.cancel),
                  color: Appcolors.redColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

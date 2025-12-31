import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:knot_iq/controllers/vendor_sub_task_controller.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/presentation/vender_sub_tasks_screen/widgets/document_widget_card.dart';
import 'package:knot_iq/utils/colors.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorSubTaskController>(
      builder: (vendorSubTaskController) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.addDocument,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Appcolors.whiteColor,
          ),
          body: SafeArea(
            child: Container(
              color: Appcolors.whiteColor,
              padding: EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: vendorSubTaskController
                    .selectedDocuments
                    .length, // Example item count
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: DocumentWidgetCard(
                      documents:
                          vendorSubTaskController.selectedDocuments[index],
                      index: index,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

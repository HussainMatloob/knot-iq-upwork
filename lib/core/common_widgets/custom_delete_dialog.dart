import 'package:flutter/material.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/utils/colors.dart';

Future<void> customDeleteDialog(BuildContext context, {VoidCallback? onTap}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        backgroundColor: Appcolors.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Appcolors.primaryColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_forever,
                  color: Appcolors.redColor,
                  size: 32,
                ),
              ),

              const SizedBox(height: 16),

              const SizedBox(height: 10),

              // Message
              Text(
                AppLocalizations.of(context)!.sureDeleteText,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 22),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Appcolors.primary2Color),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                          color: Appcolors.naviBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.deleteText,
                        //AppLocalizations.of(context)!.logout,
                        style: TextStyle(
                          color: Appcolors.naviBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

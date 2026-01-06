import 'package:flutter/material.dart';
import 'package:knot_iq/utils/colors.dart';

// Future<void> showCustomBottomSheet({
//   required BuildContext context,
//   required double initialChildSize, // e.g., 0.3
//   required double maxChildSize, // e.g., 0.8
//   required Widget child,
//   required double minChildSize,
//   bool isFixed = false,
// }) {
//   return showModalBottomSheet(
//     enableDrag: false,
//     isDismissible: false,
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,

//     builder: (context) {
//       // Get keyboard height
//       final bottomInset = MediaQuery.of(context).viewInsets.bottom;

//       return AnimatedPadding(
//         duration: const Duration(milliseconds: 50),
//         padding: EdgeInsets.only(bottom: bottomInset),
//         child: DraggableScrollableSheet(
//           initialChildSize: initialChildSize,
//           minChildSize: minChildSize,
//           maxChildSize: maxChildSize,

//           snap: true, // enable snapping
//           expand: false,
//           builder: (context, scrollController) {
//             return Container(
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color: Appcolors.backgroundColor,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//               ),
//               child: isFixed
//                   ? child
//                   : SingleChildScrollView(
//                       controller: scrollController,
//                       physics: const ClampingScrollPhysics(),
//                       child: child,
//                     ),
//             );
//           },
//         ),
//       );
//     },
//   );
// }

Future<void> showCustomBottomSheet({
  required BuildContext context,
  required double initialChildSize,
  required double maxChildSize,
  required double minChildSize,
  required Widget child,
  bool isFixed = false,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    // 1. Disable the Modal's built-in drag-to-dismiss
    enableDrag: false,
    // 2. Keep this true if you still want to tap the background to close,
    // or false if it MUST stay open until a button is pressed.
    isDismissible: true,

    builder: (context) {
      final bottomInset = MediaQuery.of(context).viewInsets.bottom;

      return AnimatedPadding(
        duration: const Duration(milliseconds: 50),
        padding: EdgeInsets.only(bottom: bottomInset),
        child: DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          // 3. This is the key property!
          // It stops the sheet from closing when it hits minChildSize.
          shouldCloseOnMinExtent: false,
          snap: true,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Appcolors.backgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: isFixed
                  ? child
                  : SingleChildScrollView(
                      controller: scrollController,
                      physics: const ClampingScrollPhysics(),
                      child: child,
                    ),
            );
          },
        ),
      );
    },
  );
}

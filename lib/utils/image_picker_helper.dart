import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/flush_message.dart';
//import 'package:permission_handler/permission_handler.dart';

class ImagePickerHelper {
  static Future<File?> selectOrCaptureImage(bool isGallery) async {
    final ImagePicker picker = ImagePicker();
    try {
      // Request camera permission
      // if (Platform.isAndroid) {
      //   // Try photos permission (Android 13+)
      //   final photoStatus = await Permission.photos.request();
      //   if (!photoStatus.isGranted) {
      //     // Fallback to storage permission (Android 12 or lower)
      //     final storageStatus = await Permission.storage.request();
      //     if (!storageStatus.isGranted) {
      //       FlushMessages.commonToast(
      //         "Gallery permission is required to upload images.",
      //         backGroundColor: Appcolors.darkGreyColor,
      //       );
      //       return null;
      //     }
      //   }
      // }

      final pickedFile = await picker.pickImage(
        source: isGallery ? ImageSource.gallery : ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }

      return null;
    } catch (e) {
      FlushMessages.commonToast(
        "Failed to pick image. Please try again.",
        backGroundColor: Appcolors.darkGreyColor,
      );
      return null;
    }
  }
}

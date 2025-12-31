import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/auth_controller.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthController controller = Get.put(AuthController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.initVideo(context);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Appcolors.naviBlue,
          body: Center(
            child: controller.isInitialized
                ? SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: controller.videoController.value.size.width,
                        height: controller.videoController.value.size.height,
                        child: VideoPlayer(controller.videoController),
                      ),
                    ),
                  )
                : Container(color: Appcolors.blackColor),
          ),
        );
      },
    );
  }
}

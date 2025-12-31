import 'package:flutter/material.dart';
import 'package:knot_iq/main.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300, // Light base color
      highlightColor: Colors.grey.shade100, // Light highlight color
      child: Row(
        children: [
          Container(
            height: mq.height / 14,
            width: mq.width / 6,
            decoration: BoxDecoration(
              color: Appcolors.whiteColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Container
              Container(
                height: mq.height / 20,
                width: mq.width / 2.2,
                decoration: BoxDecoration(
                  color: Appcolors.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              const SizedBox(height: 7),

              // Second Container
              Container(
                height: mq.height / 20,
                width: mq.width / 2.2,
                decoration: BoxDecoration(
                  color: Appcolors.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

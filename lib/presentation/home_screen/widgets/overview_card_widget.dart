import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:knot_iq/utils/constants.dart';

class OverviewCardWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String currentValue;
  final String totalValue;
  const OverviewCardWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.currentValue,
    required this.totalValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Appcolors.grey1Color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: SvgPicture.asset(
                  icon,
                  height: 20,
                  width: 20,
                  color: Appcolors.blackColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: headdingfontSize,
                    color: Appcolors.blackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                "${AppLocalizations.of(context)!.currencySymbol}${currentValue}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                "/${AppLocalizations.of(context)!.currencySymbol}${totalValue}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

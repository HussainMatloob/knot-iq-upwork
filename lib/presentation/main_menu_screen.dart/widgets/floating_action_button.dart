import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/home_controller.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/presentation/guests_screen/guests_screen.dart';
import 'package:knot_iq/utils/asset_path.dart';
import 'package:knot_iq/utils/colors.dart';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({super.key});

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _controller;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.125,
    ).animate(_controller);
  }

  void _toggleMenu() {
    if (_isOpen) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() => _isOpen = !_isOpen);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: GetBuilder<HomeController>(
        init: HomeController(),
        builder: (homeController) {
          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              // === Dimmed background overlay ===
              if (_isOpen)
                GestureDetector(
                  onTap: _toggleMenu, // close menu when tapping outside
                  child: Container(
                    color: Colors.black54, // semi-transparent black
                  ),
                ),

              // Overlay buttons
              if (_isOpen) ...[
                _buildOption(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => GuestsScreen()),
                    );
                  },
                  iconPath: AssetPath.familyActiveIcon,
                  label: AppLocalizations.of(context)!.addGuest,
                  offset: 1.9,
                ),
                _buildOption(
                  onPressed: () {
                    homeController.changeTab(1);
                  },
                  iconPath: AssetPath.vendorActiveIcon,
                  label: AppLocalizations.of(context)!.addVendors,
                  offset: 3.0,
                ),
                _buildOption(
                  onPressed: () {
                    homeController.changeTab(2);
                  },
                  iconPath: AssetPath.walletActiveIcon,
                  label: AppLocalizations.of(context)!.addBudget,
                  offset: 4.1,
                ),
                _buildOption(
                  onPressed: () {
                    homeController.changeTab(3);
                  },
                  iconPath: AssetPath.taskDoneActiveIcon,
                  label: AppLocalizations.of(context)!.addTask,
                  offset: 5.2,
                ),
              ],

              // Main FAB
              Padding(
                padding: const EdgeInsets.only(bottom: 97, right: 16),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Appcolors.primaryColor, width: 2),
                  ),
                  child: FloatingActionButton(
                    elevation: 0,
                    backgroundColor: Appcolors.primary2Color,
                    shape: const CircleBorder(),
                    onPressed: _toggleMenu,
                    child: AnimatedRotation(
                      duration: const Duration(milliseconds: 250),
                      turns: _isOpen ? 0.125 : 0.0,
                      child: const Icon(Icons.add, color: Appcolors.whiteColor),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Helper to build small FAB options
  Widget _buildOption({
    required VoidCallback onPressed,
    required String iconPath,
    required String label,
    required double offset,
  }) {
    return Positioned(
      bottom: 70.0 + (offset * 65.0), // vertical spacing
      right: 8,
      child: InkWell(
        onTap: () {
          onPressed.call();
          _toggleMenu();
        },
        child: Container(
          width: 158,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(41),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                height: 24,
                width: 24,
                iconPath,
                colorFilter: ColorFilter.mode(
                  Appcolors.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

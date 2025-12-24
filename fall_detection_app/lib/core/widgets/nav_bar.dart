import 'package:eldercare/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:eldercare/core/constants/icons.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final itemWidth = width / 3;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Stack(
            children: [
              // Garis biru animasi
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                top: 0,
                left: (itemWidth * currentIndex) + (itemWidth / 2) - 15,
                child: Container(
                  height: 3,
                  width: 30,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Items
              Row(
                children: [
                  _buildNavItem(AppIcons.home, 'Home', 0, itemWidth),
                  _buildNavItem(AppIcons.emergency, 'Emergency', 1, itemWidth),
                  _buildNavItem(AppIcons.profile, 'Profile', 2, itemWidth),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, double width) {
    final isSelected = currentIndex == index;
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(index),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 3),
              Icon(
                icon,
                color: isSelected ? AppColors.primaryBlue : Colors.black54,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? AppColors.primaryBlue : Colors.black54,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),

      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: AppColors.card,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(
          color: Colors.white10,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: 20,
          )
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          buildItem(
            icon: Icons.home_rounded,
            index: 0,
          ),

          buildItem(
            icon: Icons.inventory_2_rounded,
            index: 1,
          ),

          buildItem(
            icon: Icons.calculate_rounded,
            index: 2,
          ),

          buildItem(
            icon: Icons.bar_chart_rounded,
            index: 3,
          ),

          buildItem(
            icon: Icons.person_rounded,
            index: 4,
          ),
        ],
      ),
    );
  }

  Widget buildItem({
    required IconData icon,
    required int index,
  }) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.18)
              : Colors.transparent,

          borderRadius: BorderRadius.circular(16),
        ),

        child: Icon(
          icon,
          color: isActive
              ? AppColors.primary
              : Colors.white54,

          size: 28,
        ),
      ),
    );
  }
}
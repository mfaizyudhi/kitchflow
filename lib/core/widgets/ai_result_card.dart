import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AiResultCard extends StatelessWidget {
  final String title;
  final String confidence;
  final String recommendation;
  final IconData? icon;

  const AiResultCard({
    super.key,
    required this.title,
    required this.confidence,
    required this.recommendation,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPercent = confidence.contains('%');

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [

          /// ICON
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon ?? Icons.auto_awesome,
              color: AppColors.secondary,
              size: 22,
            ),
          ),

          const SizedBox(width: 14),

          /// INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  recommendation,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          /// CONFIDENCE BADGE
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isPercent
                  ? Colors.green.withOpacity(0.12)
                  : AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isPercent
                    ? Colors.green.withOpacity(0.3)
                    : AppColors.primary.withOpacity(0.3),
              ),
            ),
            child: Text(
              confidence,
              style: TextStyle(
                color: isPercent ? Colors.green : AppColors.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
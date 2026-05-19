// production_item_card.dart

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProductionItemCard extends StatelessWidget {
  final String name;
  final String needed;
  final String stock;
  final bool enough;
  final IconData? icon;

  const ProductionItemCard({
    super.key,
    required this.name,
    required this.needed,
    required this.stock,
    required this.enough,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = enough ? Colors.green : Colors.red;
    final double progress = enough ? 0.8 : 0.3;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: enough
              ? Colors.white10
              : Colors.red.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: enough
                ? Colors.transparent
                : Colors.red.withOpacity(0.08),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [

              /// ICON
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon ?? Icons.restaurant_rounded,
                  color: statusColor,
                  size: 18,
                ),
              ),

              const SizedBox(width: 14),

              /// INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "Butuh: $needed",
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                        const Text(
                          "  •  ",
                          style: TextStyle(
                            color: Colors.white24,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          "Stok: $stock",
                          style: TextStyle(
                            color: enough
                                ? Colors.green
                                : Colors.red,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// STATUS BADGE
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: statusColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      enough
                          ? Icons.check_circle_rounded
                          : Icons.warning_rounded,
                      color: statusColor,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      enough ? "Cukup" : "Kurang",
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// PROGRESS BAR
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StockCard extends StatelessWidget {
  final String title;
  final String stock;
  final String price;
  final String status;
  final String image;
  final VoidCallback? onEdit;

  const StockCard({
    super.key,
    required this.title,
    required this.stock,
    required this.price,
    required this.status,
    required this.image,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isHabis = status == "Habis";
    final isMenipis = status == "Menipis";
    final statusColor = isHabis
        ? Colors.red
        : isMenipis
            ? Colors.orange
            : Colors.green;

    final progressValue = isHabis
        ? 0.0
        : isMenipis
            ? 0.2
            : 0.75;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHabis
              ? Colors.red.withOpacity(0.3)
              : isMenipis
                  ? Colors.orange.withOpacity(0.2)
                  : Colors.white10,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [

          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              image,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Stok: $stock  •  $price",
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),

                /// PROGRESS BAR
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    minHeight: 4,
                    backgroundColor: Colors.white10,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          /// STATUS + EDIT
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              /// STATUS BADGE
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// TOMBOL EDIT
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: AppColors.primary,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
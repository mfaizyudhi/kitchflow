import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({
    super.key,
    required this.image,
    required this.title,
    required this.soldLabel,
    required this.badge,
    required this.soldRatio,
  });
 
  final String image;
  final String title;
  final String soldLabel;
  final String badge;
  final double soldRatio; // 0.0 – 1.0
 
  Color get _badgeBg {
    switch (badge) {
      case 'TOP 1': return const Color(0xFFFFD700).withOpacity(0.18);
      case 'TOP 2': return const Color(0xFFC0C0C0).withOpacity(0.18);
      case 'TOP 3': return const Color(0xFFCD7F32).withOpacity(0.18);
      default:      return Colors.white.withOpacity(0.08);
    }
  }
 
  Color get _badgeText {
    switch (badge) {
      case 'TOP 1': return const Color(0xFFFFD700);
      case 'TOP 2': return const Color(0xFFD0D0D0);
      case 'TOP 3': return const Color(0xFFCD9B60);
      default:      return Colors.white54;
    }
  }
 
  Color get _barColor {
    switch (badge) {
      case 'TOP 1': return AppColors.primary;
      case 'TOP 2': return AppColors.secondary;
      case 'TOP 3': return AppColors.warning;
      default:      return Colors.white24;
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── GAMBAR ────────────────────────────────────────────────
          Stack(
            children: [
              SizedBox(
                height: 88,
                width: double.infinity,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.background,
                    child: const Icon(Icons.restaurant_rounded,
                        color: Colors.white12, size: 30),
                  ),
                ),
              ),
              // Gradient overlay bawah
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [AppColors.card.withOpacity(0.9), Colors.transparent],
                    ),
                  ),
                ),
              ),
              // Badge ranking
              Positioned(
                top: 6, left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _badgeBg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _badgeText.withOpacity(0.4)),
                  ),
                  child: Text(badge,
                      style: TextStyle(
                          color: _badgeText, fontSize: 8, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
 
          // ── INFO ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(9, 7, 9, 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(soldLabel,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 9)),
                const SizedBox(height: 6),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: soldRatio.clamp(0.0, 1.0),
                    minHeight: 3,
                    backgroundColor: Colors.white.withOpacity(0.07),
                    valueColor: AlwaysStoppedAnimation<Color>(_barColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
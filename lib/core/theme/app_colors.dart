import 'package:flutter/material.dart';

class AppColors {
  // Base
  static const background = Color(0xFF070B14);
  static const card       = Color(0xFF111827);
  static const border     = Color(0xFF1F2937);

  // Brand
  static const primary    = Color(0xFF7B2FF7);
  static const secondary  = Color(0xFF00C6FF);

  // Gradient
  static const gradientStart = Color(0xFF7B2FF7);
  static const gradientEnd   = Color(0xFF00C6FF);

  // Text
  static const textPrimary   = Colors.white;
  static const textSecondary = Color(0xFF9CA3AF);
  static const textHint      = Color(0xFF4B5563);

  // Status
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const danger  = Color(0xFFEF4444);
  static const info    = Color(0xFF3B82F6);

  // ==========================
  // TAMBAHAN DARI KODE KEDUA
  // ==========================

  static const cardBorder = Color(0xFF252540);

  static const textMuted = Color(0xFF555566);

  static const heroGradient = LinearGradient(
    colors: [
      Color(0xFF1A0533),
      Color(0xFF0D1F3C),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradient helper
  static const LinearGradient brandGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color(0xFF0F172A),
      Color(0xFF111827),
      Color(0xFF1E1B4B),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
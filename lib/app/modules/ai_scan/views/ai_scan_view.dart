import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/ai_result_card.dart';
import '../../../../core/widgets/recommendation_card.dart';


class AiScanView extends StatefulWidget {
  const AiScanView({super.key});

  @override
  State<AiScanView> createState() => _AiScanViewState();
}

class _AiScanViewState extends State<AiScanView> {
  bool _hasScanned = false;
  bool _isScanning = false;

  void _startScan() async {
    setState(() => _isScanning = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isScanning = false;
      _hasScanned = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [

          /// GLOW TOP
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── HEADER ─────────────────────────────────────
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "AI Scan ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        TextSpan(
                          text: "Bahan",
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Scan bahan makanan untuk rekomendasi menu AI",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── CAMERA CARD ────────────────────────────────
                  Container(
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: _hasScanned
                            ? AppColors.primary.withOpacity(0.4)
                            : Colors.white10,
                        width: _hasScanned ? 1.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _hasScanned
                              ? AppColors.primary.withOpacity(0.15)
                              : Colors.transparent,
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: _isScanning
                        ? _buildScanningState()
                        : _hasScanned
                            ? _buildScannedState()
                            : _buildInitialState(),
                  ),

                  const SizedBox(height: 16),

                  // ── PILIHAN UPLOAD ─────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _uploadOption(
                          icon: Icons.camera_alt_rounded,
                          label: "Kamera",
                          onTap: _startScan,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _uploadOption(
                          icon: Icons.photo_library_rounded,
                          label: "Galeri",
                          onTap: _startScan,
                        ),
                      ),
                    ],
                  ),

                  if (_hasScanned) ...[

                    const SizedBox(height: 24),

                    // ── HASIL ANALISIS ─────────────────────────
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.analytics_rounded,
                            color: AppColors.secondary,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Hasil Analisis AI",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    AiResultCard(
                      title: "Bahan Terdeteksi",
                      confidence: "98%",
                      recommendation:
                          "Tempe, Cabe Merah, Bawang merah",
                      icon: Icons.document_scanner_rounded,
                    ),

                    const SizedBox(height: 10),


                    AiResultCard(
                      title: "Cek Ketersediaan Stok",
                      confidence: "Sinkron",
                      recommendation:
                          "Semua bahan tersedia di inventory",
                      icon: Icons.inventory_2_outlined,
                    ),

                    const SizedBox(height: 24),

                    // ── REKOMENDASI MENU ───────────────────────
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.restaurant_menu_rounded,
                            color: AppColors.primary,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Rekomendasi Menu",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    const RecommendationCard(
                      image: "assets/images/tempeorek.jpg",
                      title: "Orek Tempe",
                      profit: "Rp 350.000",
                      hpp: "Rp 8.500",
                      level: "Tinggi",
                    ),

                    const RecommendationCard(
                      image: "assets/images/tempecabebawang.jpg",
                      title: "Tempe Cabe Bawang",
                      profit: "Rp 220.000",
                      hpp: "Rp 10.000",
                      level: "Best Seller",
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── STATE WIDGETS ───────────────────────────────────────────────

  Widget _buildInitialState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.2),
                AppColors.secondary.withOpacity(0.1),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.camera_alt_rounded,
            size: 48,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Scan Bahan Makanan",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "AI akan mendeteksi bahan secara\notomatis dan memberi rekomendasi",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildScanningState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          color: AppColors.secondary,
          strokeWidth: 3,
        ),
        const SizedBox(height: 20),
        const Text(
          "AI sedang menganalisis...",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Mendeteksi bahan makanan",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildScannedState() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Image.asset(
            "assets/images/scanai.jpg",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        /// OVERLAY
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.6),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        /// SCAN RESULT OVERLAY
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  "3 bahan terdeteksi — 98% akurasi",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  _hasScanned = false;
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Text(
                    "Ulang",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        /// SCAN FRAME
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome,
                    color: Colors.white, size: 12),
                SizedBox(width: 4),
                Text(
                  "AI Scan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _uploadOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.secondary, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
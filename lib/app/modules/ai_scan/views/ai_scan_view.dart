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
  final TextEditingController _menuInputController =
      TextEditingController(text: "Orek Tempe");

  @override
  void dispose() {
    _menuInputController.dispose();
    super.dispose();
  }

  void _startScan() async {
    setState(() => _isScanning = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isScanning = false;
      _hasScanned = true;
    });
  }

  // ── DATA RESEP ─────────────────────────────────────────────────

  final Map<String, Map<String, dynamic>> _resepData = {
    "Orek Tempe": {
      "image": "assets/images/tempeorek.jpg",
      "porsi": "4 Porsi",
      "waktu": "20 Menit",
      "bahan": [
        {"nama": "Tempe", "jumlah": "250 gr"},
        {"nama": "Cabe Merah", "jumlah": "5 buah"},
        {"nama": "Cabe Rawit", "jumlah": "3 buah"},
        {"nama": "Bawang Putih", "jumlah": "3 siung"},
        {"nama": "Bawang Merah", "jumlah": "4 siung"},
        {"nama": "Kecap Manis", "jumlah": "2 sdm"},
        {"nama": "Gula Merah", "jumlah": "1 sdm"},
        {"nama": "Garam", "jumlah": "secukupnya"},
        {"nama": "Minyak Goreng", "jumlah": "3 sdm"},
      ],
      "langkah": [
        {
          "no": "1",
          "judul": "Potong Tempe",
          "detail":
              "Potong tempe berbentuk korek api atau dadu kecil sesuai selera.",
        },
        {
          "no": "2",
          "judul": "Goreng Tempe",
          "detail":
              "Goreng tempe dengan minyak panas hingga kering dan kecoklatan. Angkat dan tiriskan.",
        },
        {
          "no": "3",
          "judul": "Tumis Bumbu",
          "detail":
              "Iris tipis bawang merah, bawang putih, cabe merah, dan cabe rawit. Tumis dengan sedikit minyak hingga harum.",
        },
        {
          "no": "4",
          "judul": "Masukkan Tempe",
          "detail": "Masukkan tempe goreng ke dalam tumisan bumbu. Aduk rata.",
        },
        {
          "no": "5",
          "judul": "Bumbui",
          "detail":
              "Tambahkan kecap manis, gula merah, dan garam. Aduk terus di atas api sedang hingga bumbu meresap dan orek mengering.",
        },
        {
          "no": "6",
          "judul": "Sajikan",
          "detail":
              "Angkat dan sajikan orek tempe sebagai lauk pendamping nasi.",
        },
      ],
    },
    "Tempe Cabe Bawang": {
      "image": "assets/images/tempecabebawang.jpg",
      "porsi": "4 Porsi",
      "waktu": "25 Menit",
      "bahan": [
        {"nama": "Tempe", "jumlah": "300 gr"},
        {"nama": "Cabe Merah", "jumlah": "6 buah"},
        {"nama": "Cabe Rawit", "jumlah": "5 buah"},
        {"nama": "Bawang Merah", "jumlah": "6 siung"},
        {"nama": "Bawang Putih", "jumlah": "4 siung"},
        {"nama": "Tomat", "jumlah": "1 buah"},
        {"nama": "Daun Salam", "jumlah": "2 lembar"},
        {"nama": "Garam", "jumlah": "secukupnya"},
        {"nama": "Gula", "jumlah": "1 sdt"},
        {"nama": "Minyak Goreng", "jumlah": "4 sdm"},
      ],
      "langkah": [
        {
          "no": "1",
          "judul": "Potong Tempe",
          "detail":
              "Potong tempe sesuai selera, bisa berbentuk segitiga atau persegi. Goreng setengah matang lalu tiriskan.",
        },
        {
          "no": "2",
          "judul": "Haluskan Bumbu",
          "detail":
              "Iris kasar bawang merah, bawang putih, cabe merah, dan cabe rawit. Tidak perlu dihaluskan, cukup diiris.",
        },
        {
          "no": "3",
          "judul": "Tumis Bawang",
          "detail":
              "Panaskan minyak, tumis bawang merah dan bawang putih hingga layu dan harum.",
        },
        {
          "no": "4",
          "judul": "Masukkan Cabe & Tomat",
          "detail":
              "Masukkan irisan cabe merah, cabe rawit, tomat, dan daun salam. Tumis hingga cabe layu.",
        },
        {
          "no": "5",
          "judul": "Masukkan Tempe",
          "detail":
              "Masukkan tempe yang sudah digoreng. Tambahkan garam dan gula, aduk rata hingga bumbu meresap sempurna.",
        },
        {
          "no": "6",
          "judul": "Koreksi Rasa",
          "detail":
              "Cicipi dan koreksi rasa. Masak sebentar hingga bumbu kering dan meresap. Sajikan hangat.",
        },
      ],
    },
  };

  void _showResepBottomSheet(String namaMenu) {
    final resep = _resepData[namaMenu];
    if (resep == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // ── HANDLE ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 4),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── GAMBAR MENU ──────────────────────────
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        resep["image"],
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── NAMA + INFO CHIP ─────────────────────
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Resep ",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: namaMenu,
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        _resepChip(
                          Icons.people_rounded,
                          resep["porsi"],
                          Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        _resepChip(
                          Icons.timer_rounded,
                          resep["waktu"],
                          AppColors.primary,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── BAHAN-BAHAN ──────────────────────────
                    _sectionHeader(
                      Icons.inventory_2_outlined,
                      "Bahan-bahan",
                      AppColors.secondary,
                    ),

                    const SizedBox(height: 12),

                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        children: List.generate(
                          (resep["bahan"] as List).length,
                          (i) {
                            final bahan = resep["bahan"][i];
                            final isLast =
                                i == (resep["bahan"] as List).length - 1;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                border: isLast
                                    ? null
                                    : const Border(
                                        bottom:
                                            BorderSide(color: Colors.white10)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      bahan["nama"],
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: AppColors.secondary
                                              .withValues(alpha: 0.25)),
                                    ),
                                    child: Text(
                                      bahan["jumlah"],
                                      style: const TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── CARA PEMBUATAN ───────────────────────
                    _sectionHeader(
                      Icons.menu_book_rounded,
                      "Cara Pembuatan",
                      AppColors.primary,
                    ),

                    const SizedBox(height: 12),

                    Column(
                      children: List.generate(
                        (resep["langkah"] as List).length,
                        (i) {
                          final step = resep["langkah"][i];
                          final isLast =
                              i == (resep["langkah"] as List).length - 1;
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // NOMOR + LINE
                              Column(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      gradient: AppColors.brandGradient,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.4),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        step["no"],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (!isLast)
                                    Container(
                                      width: 2,
                                      height: 50,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(width: 14),

                              // KONTEN LANGKAH
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(bottom: isLast ? 0 : 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      Text(
                                        step["judul"],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        step["detail"],
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                          height: 1.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── TOMBOL TUTUP ─────────────────────────
                    Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: AppColors.brandGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => Navigator.pop(context),
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Gunakan Resep Ini",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 15),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _resepChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
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
                    AppColors.primary.withValues(alpha: 0.2),
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
                          text: "AI Visual ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        TextSpan(
                          text: "Menu Generator",
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
                    "Tulis ide menu makanan untuk memvisualisasikan dengan AI",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── CAMERA CARD (AI VISUAL DISPLAY) ────────────
                  Container(
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: _hasScanned
                            ? AppColors.primary.withValues(alpha: 0.4)
                            : Colors.white10,
                        width: _hasScanned ? 1.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _hasScanned
                              ? AppColors.primary.withValues(alpha: 0.15)
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

                  // ── INPUT TEXT USER & GENERATE BUTTON ───────────
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nama Menu / Bahan",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _menuInputController,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText:
                              "Masukkan nama menu (cth: Orek Tempe, Nasi Goreng)",
                          hintStyle: const TextStyle(
                              color: AppColors.textHint, fontSize: 13),
                          prefixIcon: const Icon(
                            Icons.restaurant_menu_rounded,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: AppColors.card,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: AppColors.secondary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: AppColors.brandGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: _startScan,
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.auto_awesome,
                                      color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    "Generate Visual Menu",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                            color: AppColors.secondary.withValues(alpha: 0.12),
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
                      recommendation: "Tempe, Cabe Merah, Bawang merah",
                      icon: Icons.document_scanner_rounded,
                    ),

                    const SizedBox(height: 10),

                    AiResultCard(
                      title: "Cek Ketersediaan Stok",
                      confidence: "Sinkron",
                      recommendation: "Semua bahan tersedia di inventory",
                      icon: Icons.inventory_2_outlined,
                    ),

                    const SizedBox(height: 24),

                    // ── REKOMENDASI MENU ───────────────────────
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
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

                    RecommendationCard(
                      image: "assets/images/tempeorek.jpg",
                      title: "Orek Tempe",
                      profit: "Rp 350.000",
                      hpp: "Rp 8.500",
                      level: "Tinggi",
                      onGunakanMenu: () => _showResepBottomSheet("Orek Tempe"),
                    ),

                    RecommendationCard(
                      image: "assets/images/tempecabebawang.jpg",
                      title: "Tempe Cabe Bawang",
                      profit: "Rp 220.000",
                      hpp: "Rp 10.000",
                      level: "Best Seller",
                      onGunakanMenu: () =>
                          _showResepBottomSheet("Tempe Cabe Bawang"),
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
                AppColors.primary.withValues(alpha: 0.2),
                AppColors.secondary.withValues(alpha: 0.1),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.auto_awesome,
            size: 48,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Visualisasikan Menu Anda",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Masukkan ide masakan untuk menghasilkan\nvisualisasi hidangan dengan AI",
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
          "AI sedang memproses...",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Menghasilkan visualisasi menu",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildScannedState() {
    String namaMenu = _menuInputController.text.trim();
    if (namaMenu.isEmpty) {
      namaMenu = "Orek Tempe";
    }
    String stylePrompt =
        "highly detailed food photography, 4k resolution, cinematic lighting, appetizing";
    String aiUrl =
        "https://image.pollinations.ai/prompt/${Uri.encodeComponent('$namaMenu, $stylePrompt')}";

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(
              aiUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.secondary,
                  ),
                );
              },
            ),
          ),
        ),

        /// OVERLAY
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.6),
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
                  color: Colors.green.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Visualisasi $namaMenu berhasil di-generate",
                  style: const TextStyle(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, color: Colors.white, size: 12),
                SizedBox(width: 4),
                Text(
                  "AI Generated",
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
}
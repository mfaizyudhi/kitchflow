// hpp_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/hpp_item_card.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../routes/app_pages.dart';

class HppView extends StatefulWidget {
  const HppView({super.key});

  @override
  State<HppView> createState() => _HppViewState();
}

class _HppViewState extends State<HppView> {
  String _wilayah         = "Kota Tegal, Jawa Tengah";
  String _koordinat       = "-6.8696° S, 109.1402° E";
  bool   _isLoadingLokasi = false;
  bool   _isLoadingHarga  = false;
  bool   _hargaLoaded     = false;

  final List<Map<String, dynamic>> _bahanList = [
    {
      "name":         "Tempe",
      "qty":          "2 Kg",
      "icon":         Icons.lunch_dining_rounded,
      "hargaNasional":"Rp 18.000",
      "hargaWilayah": "Rp 15.000",
      "totalHarga":   "Rp 30.000",
      "loaded":       false,
    },
    {
      "name":         "Cabe Merah",
      "qty":          "1 Kg",
      "icon":         Icons.eco_rounded,
      "hargaNasional":"Rp 45.000",
      "hargaWilayah": "Rp 38.000",
      "totalHarga":   "Rp 38.000",
      "loaded":       false,
    },
    {
      "name":         "Bawang Putih",
      "qty":          "500 gr",
      "icon":         Icons.spa_rounded,
      "hargaNasional":"Rp 18.000",
      "hargaWilayah": "Rp 16.000",
      "totalHarga":   "Rp 8.000",
      "loaded":       false,
    },
    {
      "name":         "Minyak Goreng",
      "qty":          "1 Liter",
      "icon":         Icons.opacity_rounded,
      "hargaNasional":"Rp 20.000",
      "hargaWilayah": "Rp 18.500",
      "totalHarga":   "Rp 18.500",
      "loaded":       false,
    },
  ];

  int get _totalModalWilayah => _hargaLoaded ? 94500  : 119000;
  int get _totalModalNasional => 119000;
  int get _hppPerPorsi        => _hargaLoaded ? 6750   : 8500;
  int get _rekomendasiHarga   => _hargaLoaded ? 13000  : 15000;
  int get _estimasiProfit     => _hargaLoaded ? 315000 : 350000;
  int get _selisihHarga       => _totalModalNasional - _totalModalWilayah;

  void _detectLokasi() async {
    setState(() => _isLoadingLokasi = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoadingLokasi = false;
      _wilayah         = "Kota Tegal, Jawa Tengah";
      _koordinat       = "-6.8696° S, 109.1402° E";
    });
  }

  void _loadHargaWilayah() async {
    setState(() => _isLoadingHarga = true);
    for (int i = 0; i < _bahanList.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() => _bahanList[i]["loaded"] = true);
    }
    setState(() {
      _isLoadingHarga = false;
      _hargaLoaded    = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [

          /// GLOW
          Positioned(
            top: -80, right: -60,
            child: Container(
              width: 220, height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withOpacity(0.2),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── HEADER ──────────────────────────────────────
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(children: [
                                TextSpan(
                                  text: "Perhitungan ",
                                  style: TextStyle(
                                    color: Colors.white, fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                TextSpan(
                                  text: "HPP",
                                  style: TextStyle(
                                    color: AppColors.secondary, fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ]),
                            ),
                            const Text(
                              "Harga berbasis wilayah & rekomendasi AI lokal",
                              style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── DETEKSI LOKASI GPS ───────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0D1F3C), Color(0xFF1A0533)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.secondary.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary.withOpacity(0.1),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.location_on_rounded,
                                color: AppColors.secondary, size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Lokasi Warteg Terdeteksi",
                                    style: TextStyle(
                                      color: Colors.white54, fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    _wilayah,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            GestureDetector(
                              onTap: _detectLokasi,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: AppColors.secondary.withOpacity(0.3)),
                                ),
                                child: _isLoadingLokasi
                                    ? const SizedBox(
                                        width: 16, height: 16,
                                        child: CircularProgressIndicator(
                                          color: AppColors.secondary,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.my_location_rounded,
                                        color: AppColors.secondary, size: 16,
                                      ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            const Icon(Icons.gps_fixed_rounded,
                                color: Colors.green, size: 12),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                _koordinat,
                                style: const TextStyle(
                                  color: Colors.white38, fontSize: 11,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "GPS Aktif",
                                style: TextStyle(
                                  color: Colors.green, fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        GestureDetector(
                          onTap: _hargaLoaded ? null : _loadHargaWilayah,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              gradient: _hargaLoaded
                                  ? null
                                  : AppColors.brandGradient,
                              color: _hargaLoaded
                                  ? Colors.green.withOpacity(0.12)
                                  : null,
                              borderRadius: BorderRadius.circular(12),
                              border: _hargaLoaded
                                  ? Border.all(
                                      color: Colors.green.withOpacity(0.3))
                                  : null,
                              boxShadow: _hargaLoaded
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.3),
                                        blurRadius: 10,
                                      ),
                                    ],
                            ),
                            child: Center(
                              child: _isLoadingHarga
                                  ? const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 16, height: 16,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "Mengambil harga dari wilayah...",
                                          style: TextStyle(
                                            color: Colors.white, fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          _hargaLoaded
                                              ? Icons.check_circle_rounded
                                              : Icons.auto_awesome,
                                          color: _hargaLoaded
                                              ? Colors.green
                                              : Colors.white,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            _hargaLoaded
                                                ? "Harga Wilayah Tegal Berhasil Dimuat"
                                                : "Ambil Harga Bahan dari Wilayah",
                                            style: TextStyle(
                                              color: _hargaLoaded
                                                  ? Colors.green
                                                  : Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── MENU SELECTED ────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1A0533), Color(0xFF0D1F3C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.15),
                          blurRadius: 20, offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            "assets/images/food_ai.jpg",
                            width: 80, height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Orek Tempe",
                                style: TextStyle(
                                  color: Colors.white, fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: AppColors.secondary.withOpacity(0.3)),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.auto_awesome,
                                        color: AppColors.secondary, size: 10),
                                    SizedBox(width: 4),
                                    Text(
                                      "AI Recommended",
                                      style: TextStyle(
                                        color: AppColors.secondary, fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "4 bahan • Estimasi 40 porsi",
                                style: TextStyle(
                                  color: AppColors.textSecondary, fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── KOMPOSISI BAHAN ──────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Komposisi Bahan",
                        style: TextStyle(
                          color: Colors.white, fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          if (_hargaLoaded)
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.green.withOpacity(0.3)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.location_on_rounded,
                                      color: Colors.green, size: 10),
                                  SizedBox(width: 4),
                                  Text(
                                    "Harga Lokal",
                                    style: TextStyle(
                                      color: Colors.green, fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.primary.withOpacity(0.2)),
                            ),
                            child: Text(
                              "${_bahanList.length} item",
                              style: const TextStyle(
                                color: AppColors.primary, fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // LIST BAHAN
                  ...List.generate(_bahanList.length, (i) {
                    final bahan = _bahanList[i];
                    final isLoaded = bahan["loaded"] as bool;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isLoaded
                              ? Colors.green.withOpacity(0.2)
                              : Colors.white10,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          // ICON
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              bahan["icon"] as IconData,
                              color: AppColors.primary, size: 18,
                            ),
                          ),

                          const SizedBox(width: 12),

                          // INFO — FIX: Expanded agar tidak overflow
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bahan["name"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  bahan["qty"],
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),

                                // FIX: Wrap baris harga agar tidak overflow
                                if (isLoaded) ...[
                                  const SizedBox(height: 6),
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 4,
                                    runSpacing: 2,
                                    children: [
                                      Text(
                                        bahan["hargaNasional"],
                                        style: const TextStyle(
                                          color: Colors.white24,
                                          fontSize: 10,
                                          decoration: TextDecoration.lineThrough,
                                          decorationColor: Colors.white24,
                                        ),
                                      ),
                                      const Icon(Icons.arrow_forward_rounded,
                                          color: Colors.green, size: 10),
                                      Text(
                                        bahan["hargaWilayah"],
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          "Harga Lokal",
                                          style: TextStyle(
                                            color: Colors.green, fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          // TOTAL HARGA KANAN
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isLoaded
                                      ? Colors.green.withOpacity(0.1)
                                      : AppColors.secondary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isLoaded
                                        ? Colors.green.withOpacity(0.2)
                                        : AppColors.secondary.withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  bahan["totalHarga"],
                                  style: TextStyle(
                                    color: isLoaded
                                        ? Colors.green
                                        : AppColors.secondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              if (isLoaded) ...[
                                const SizedBox(height: 4),
                                const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.location_on_rounded,
                                        color: Colors.green, size: 10),
                                    SizedBox(width: 2),
                                    Text(
                                      "Tegal",
                                      style: TextStyle(
                                        color: Colors.green, fontSize: 9,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // ── PENGHEMATAN ──────────────────────────────────
                  if (_hargaLoaded) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: Colors.green.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.savings_rounded,
                              color: Colors.green, size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Penghematan Harga Lokal",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Menggunakan harga bahan $_wilayah lebih hemat:",
                                  style: const TextStyle(
                                    color: Colors.white54, fontSize: 11,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "- Rp ${_fmt(_selisihHarga)}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],

                  // ── HASIL AI HPP ─────────────────────────────────
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.auto_awesome,
                                  color: AppColors.secondary, size: 14),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Hasil Analisis AI",
                                    style: TextStyle(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  if (_hargaLoaded)
                                    Text(
                                      "Berbasis harga pasar $_wilayah",
                                      style: const TextStyle(
                                        color: Colors.white38, fontSize: 10,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                            if (_hargaLoaded)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Colors.green.withOpacity(0.3)),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.location_on_rounded,
                                        color: Colors.green, size: 10),
                                    SizedBox(width: 4),
                                    Text(
                                      "Harga Lokal",
                                      style: TextStyle(
                                        color: Colors.green, fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        const Divider(color: Colors.white10),
                        const SizedBox(height: 16),

                        _buildResultRow(
                          "Total Modal Produksi",
                          "Rp ${_fmt(_totalModalWilayah)}",
                          Colors.white70,
                          AppColors.textSecondary,
                        ),
                        const SizedBox(height: 14),

                        _buildResultRow(
                          "HPP per Porsi",
                          "Rp ${_fmt(_hppPerPorsi)}",
                          Colors.white70,
                          AppColors.secondary,
                        ),
                        const SizedBox(height: 14),

                        const Divider(color: Colors.white10),
                        const SizedBox(height: 14),

                        // FIX: Rekomendasi Harga Jual — pakai Column agar nilai tidak terpotong
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Rekomendasi Harga Jual",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (_hargaLoaded)
                                        Text(
                                          "Disesuaikan daya beli $_wilayah",
                                          style: const TextStyle(
                                            color: Colors.white38, fontSize: 10,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "Rp ${_fmt(_rekomendasiHarga)}",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // PROFIT HIGHLIGHT
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: Colors.green.withOpacity(0.2)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.trending_up_rounded,
                                      color: Colors.green, size: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Estimasi Profit",
                                    style: TextStyle(
                                      color: Colors.white70, fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Rp ${_fmt(_estimasiProfit)}",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── AI SUGGESTION ────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: AppColors.secondary.withOpacity(0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_outline_rounded,
                            color: AppColors.secondary, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _hargaLoaded
                                ? "AI Suggestion: Harga jual Rp ${_fmt(_rekomendasiHarga)} per porsi sudah optimal untuk daya beli masyarakat $_wilayah dengan margin keuntungan ${((_rekomendasiHarga - _hppPerPorsi) / _rekomendasiHarga * 100).toStringAsFixed(0)}%."
                                : "AI Suggestion: Tap 'Ambil Harga Bahan dari Wilayah' untuk mendapatkan rekomendasi harga yang disesuaikan dengan kondisi pasar lokal warteg Anda.",
                            style: const TextStyle(
                              color: Colors.white60, fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── TOMBOL PRODUKSI ──────────────────────────────
                  Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 20, offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => Get.toNamed(Routes.PRODUCTION),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.restaurant_rounded,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 10),
                              Text(
                                "Lanjut Produksi",
                                style: TextStyle(
                                  color: Colors.white, fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── TOMBOL EXPORT ────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download_rounded,
                          color: AppColors.secondary, size: 18),
                      label: const Text(
                        "Export Laporan HPP",
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: AppColors.secondary.withOpacity(0.4)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
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
    );
  }

  Widget _buildResultRow(
    String title,
    String value,
    Color titleColor,
    Color valueColor, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: isBold ? 14 : 13,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.bold,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }

  String _fmt(int value) {
    final str = value.toString();
    final buf = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write('.');
      buf.write(str[i]);
    }
    return buf.toString();
  }
}
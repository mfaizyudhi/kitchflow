// sales_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../routes/app_pages.dart';

class SalesView extends StatefulWidget {
  const SalesView({super.key});

  @override
  State<SalesView> createState() => _SalesViewState();
}

class _SalesViewState extends State<SalesView> {
  final List<Map<String, dynamic>> _menuList = [
    {
      "name": "Ayam Goreng Lengkuas",
      "porsi": 40,
      "terjual": 0,
      "harga": 15000,
      "icon": Icons.set_meal_rounded,
    },
    {
      "name": "Sayur Lodeh Spesial",
      "porsi": 30,
      "terjual": 0,
      "harga": 8000,
      "icon": Icons.eco_rounded,
    },
    {
      "name": "Sambal Goreng Kentang",
      "porsi": 25,
      "terjual": 0,
      "harga": 7000,
      "icon": Icons.lunch_dining_rounded,
    },
  ];

  int get _totalPorsi => _menuList.fold(0, (s, i) => s + (i["porsi"] as int));
  int get _totalTerjual =>
      _menuList.fold(0, (s, i) => s + (i["terjual"] as int));
  int get _totalSisa => _totalPorsi - _totalTerjual;
  int get _totalModal => _menuList.fold(
      0, (s, i) => s + (i["porsi"] as int) * (i["harga"] as int) ~/ 2);
  int get _totalPenjualan => _menuList.fold(
      0, (s, i) => s + (i["terjual"] as int) * (i["harga"] as int));
  int get _labaBersih => _totalPenjualan - _totalModal;
  int get _kerugianSisa => _totalSisa * 3500;
  double get _progressTerjual =>
      _totalPorsi == 0 ? 0 : _totalTerjual / _totalPorsi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// GLOW
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withOpacity(0.12),
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
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Penjualan ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Harian",
                                    style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              "Evaluasi hasil penjualan & laba harian",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── PROGRESS PENJUALAN ───────────────────────────
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1A0533),
                          Color(0xFF0D1F3C),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border:
                          Border.all(color: AppColors.primary.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Progress Penjualan",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              "${(_progressTerjual * 100).toInt()}%",
                              style: const TextStyle(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: _progressTerjual,
                            minHeight: 8,
                            backgroundColor: Colors.white10,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.secondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _miniStat(
                                "Terjual",
                                "$_totalTerjual",
                                "porsi",
                                Colors.green,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _miniStat(
                                "Sisa",
                                "$_totalSisa",
                                "porsi",
                                _totalSisa > 5 ? Colors.orange : Colors.green,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _miniStat(
                                "Pendapatan",
                                "Rp ${_fmtShort(_totalPenjualan)}",
                                "",
                                AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── AI INSIGHT ───────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColors.secondary.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: AppColors.secondary,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "AI Insight: Input penjualan untuk memperbarui rekomendasi stok besok secara otomatis.",
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── INPUT PENJUALAN ──────────────────────────────
                  Row(
                    children: [
                      const Text(
                        "Input Penjualan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${_menuList.length} menu",
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  ...List.generate(_menuList.length, (i) {
                    final item = _menuList[i];
                    final double progress =
                        (item["terjual"] as int) / (item["porsi"] as int);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
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
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  item["icon"] as IconData,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                              ),

                              const SizedBox(width: 12),

                              /// INFO
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item["name"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      "${item["porsi"]} porsi  •  Rp ${_fmt(item["harga"])}",
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// COUNTER
                              Row(
                                children: [
                                  _counterBtn(
                                    icon: Icons.remove_rounded,
                                    onTap: () => setState(() {
                                      if (item["terjual"] > 0)
                                        item["terjual"]--;
                                    }),
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: Text(
                                      "${item["terjual"]}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  _counterBtn(
                                    icon: Icons.add_rounded,
                                    onTap: () => setState(() {
                                      if (item["terjual"] < item["porsi"]) {
                                        item["terjual"]++;
                                      }
                                    }),
                                    isAdd: true,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// PROGRESS
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 4,
                              backgroundColor: Colors.white10,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                progress > 0.7
                                    ? Colors.green
                                    : AppColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  // ── TAMBAH MENU ──────────────────────────────────
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_rounded,
                              color: Colors.white38, size: 18),
                          SizedBox(width: 8),
                          Text(
                            "Tambah Menu Lain",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── RINGKASAN PRODUKSI ───────────────────────────
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.summarize_rounded,
                              color: AppColors.secondary,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Ringkasan Produksi",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Colors.white10),
                        const SizedBox(height: 14),
                        _resultRow("Total Produksi", "$_totalPorsi Porsi",
                            Colors.white70),
                        const SizedBox(height: 12),
                        _resultRow("Porsi Terjual", "$_totalTerjual Porsi",
                            Colors.green),
                        const SizedBox(height: 12),
                        _resultRow(
                          "Sisa Makanan",
                          "$_totalSisa Porsi",
                          _totalSisa > 5 ? Colors.orange : Colors.green,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── HASIL ANALISIS ───────────────────────────────
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.analytics_rounded,
                              color: AppColors.primary,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Hasil Analisis Keuangan",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Colors.white10),
                        const SizedBox(height: 14),
                        _resultRow("Total Penjualan",
                            "Rp ${_fmt(_totalPenjualan)}", AppColors.secondary),
                        const SizedBox(height: 12),
                        _resultRow("Total Modal", "Rp ${_fmt(_totalModal)}",
                            AppColors.textSecondary),
                        const SizedBox(height: 12),
                        _resultRow(
                          "Kerugian Sisa",
                          "Rp ${_fmt(_kerugianSisa)}",
                          Colors.orange,
                        ),
                        const SizedBox(height: 16),

                        /// LABA HIGHLIGHT
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color:
                                (_labaBersih >= 0 ? Colors.green : Colors.red)
                                    .withOpacity(0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color:
                                  (_labaBersih >= 0 ? Colors.green : Colors.red)
                                      .withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: (_labaBersih >= 0
                                              ? Colors.green
                                              : Colors.red)
                                          .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _labaBersih >= 0
                                          ? Icons.trending_up_rounded
                                          : Icons.trending_down_rounded,
                                      color: _labaBersih >= 0
                                          ? Colors.green
                                          : Colors.red,
                                      size: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Laba Bersih",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Rp ${_fmt(_labaBersih.abs())}",
                                style: TextStyle(
                                  color: _labaBersih >= 0
                                      ? Colors.green
                                      : Colors.red,
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

                  const SizedBox(height: 24),

                  // ── SIMPAN BUTTON ────────────────────────────────
                  Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => Get.toNamed(Routes.ANALYTICS),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save_alt_rounded,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 10),
                              Text(
                                "Simpan Laporan Harian",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
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
    );
  }

  // ── HELPERS ──────────────────────────────────────────────────────

  Widget _miniStat(String label, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          if (unit.isNotEmpty)
            Text(
              unit,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 9,
              ),
            ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _counterBtn({
    required IconData icon,
    required VoidCallback onTap,
    bool isAdd = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          gradient: isAdd ? AppColors.brandGradient : null,
          color: isAdd ? null : Colors.white10,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _resultRow(String title, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
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

  String _fmtShort(int value) {
    if (value >= 1000000) {
      return "${(value / 1000000).toStringAsFixed(1)}JT";
    } else if (value >= 1000) {
      return "${(value / 1000).toStringAsFixed(0)}K";
    }
    return value.toString();
  }
}

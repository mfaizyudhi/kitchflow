// production_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/production_item_card.dart';
import '../../production/controllers/production_controller.dart';
import '../../hpp/controllers/hpp_controller.dart';
import '../../best_menu/controllers/best_menu_controller.dart';

class ProductionView extends StatefulWidget {
  const ProductionView({super.key});

  @override
  State<ProductionView> createState() => _ProductionViewState();
}

class _ProductionViewState extends State<ProductionView> {
  final TextEditingController _targetController = TextEditingController();
  bool _confirmed = false;

  @override
  Widget build(BuildContext context) {
    final prodCtrl = ProductionController.to;
    final hppCtrl  = HppController.to;
    final menuCtrl = BestMenuController.to;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [

          /// GLOW
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.18),
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
                                    text: "Produksi ",
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
                              "Target produksi & analisis kebutuhan bahan",
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
                            "AI menyarankan target 50 porsi berdasarkan data penjualan minggu lalu dan prediksi cuaca.",
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

                  const SizedBox(height: 20),

                  // ── TARGET PRODUKSI ──────────────────────────────
                  Obx(() {
                    final targetPorsi = prodCtrl.targetPorsi.value;

                    return GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.track_changes_rounded,
                                color: AppColors.primary,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Target Produksi",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          /// COUNTER TARGET
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              /// KURANG
                              GestureDetector(
                                onTap: () {
                                  if (targetPorsi > 10) {
                                    prodCtrl.targetPorsi.value -= 10;
                                  }
                                },
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.remove_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              /// NILAI
                              Column(
                                children: [
                                  Text(
                                    "$targetPorsi",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                  const Text(
                                    "Porsi",
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),

                              /// TAMBAH
                              GestureDetector(
                                onTap: () {
                                  prodCtrl.targetPorsi.value += 10;
                                },
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.brandGradient,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.3),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.add_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          /// INPUT MANUAL
                          TextField(
                            controller: _targetController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              final parsed = int.tryParse(val);
                              if (parsed != null) {
                                prodCtrl.targetPorsi.value = parsed; // ← reactive update
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Atau ketik jumlah porsi manual",
                              hintStyle: const TextStyle(
                                  color: AppColors.textHint, fontSize: 13),
                              prefixIcon: const Icon(
                                Icons.edit_rounded,
                                color: AppColors.textSecondary,
                                size: 18,
                              ),
                              filled: true,
                              fillColor: const Color(0xFF0F172A),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                    color: AppColors.primary, width: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // ── KEBUTUHAN BAHAN ──────────────────────────────
                  Obx(() {
                    final kebutuhan     = prodCtrl.kebutuhanBahan; // recalc saat porsi berubah
                    final jumlahKurang  = prodCtrl.jumlahBahanKurang;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Kebutuhan Bahan",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (jumlahKurang > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.red.withOpacity(0.2)),
                                ),
                                child: Text(
                                  "$jumlahKurang Kurang",
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.green.withOpacity(0.2)),
                                ),
                                child: const Text(
                                  "Stok Cukup",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // LIST KEBUTUHAN BAHAN dari ProductionController
                        ...kebutuhan.map((item) => ProductionItemCard(
  name:   item.name,
  needed: item.neededLabel,
  stock:  item.stockLabel,
  enough: item.enough,
  icon:   item.icon,
)),
                      ],
                    );
                  }),

                  const SizedBox(height: 24),

                  // ── RINGKASAN ────────────────────────────────────
                  Obx(() {
                    final prodCtrl      = ProductionController.to;
                    final hppCtrl       = HppController.to;
                    final targetPorsi   = prodCtrl.targetPorsi.value;
                    final rekHarga      = hppCtrl.rekomendasiHarga.value; // ← dari HPP
                    final totalModal    = hppCtrl.totalModal.value;        // ← dari HPP
                    final estimasiJual  = prodCtrl.estimasiPenjualan;
                    final estimasiProfit = prodCtrl.estimasiProfit;        // ← ke Dashboard

                    return GlassCard(
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
                          const SizedBox(height: 16),

                          _summaryRow(
                              "Target Produksi",
                              "$targetPorsi Porsi",
                              Colors.white70),
                          const SizedBox(height: 12),
                          _summaryRow(
                              "Total Modal",
                              "Rp ${_fmt(totalModal.toInt())}",     // ← dari HPP
                              AppColors.textSecondary),
                          const SizedBox(height: 12),
                          _summaryRow(
                              "Harga Jual / Porsi",
                              "Rp ${_fmt(rekHarga.toInt())}",       // ← dari HPP
                              AppColors.textSecondary),
                          const SizedBox(height: 12),
                          _summaryRow(
                              "Estimasi Penjualan",
                              "Rp ${_fmt(estimasiJual.toInt())}",
                              AppColors.textSecondary),
                          const SizedBox(height: 16),

                          /// PROFIT HIGHLIGHT
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
                                        color: Colors.green,
                                        size: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "Estimasi Profit",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Rp ${_fmt(estimasiProfit.toInt())}",
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
                    );
                  }),

                  const SizedBox(height: 24),

                  // ── TOMBOL KONFIRMASI ────────────────────────────
                  Obx(() {
                    final semuaCukup = prodCtrl.semuaBahanCukup;

                    return Column(
                      children: [
                        // STATUS KONFIRMASI
                        if (_confirmed)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: Colors.green.withOpacity(0.2)),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    color: Colors.green, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  "Produksi Berhasil Dikonfirmasi",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        Container(
                          width: double.infinity,
                          height: 58,
                          decoration: BoxDecoration(
                            gradient: semuaCukup && !_confirmed
                                ? AppColors.brandGradient
                                : const LinearGradient(
                                    colors: [Colors.white12, Colors.white12]),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: semuaCukup && !_confirmed
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.4),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: semuaCukup && !_confirmed
                                  ? () async {
                                      // Dialog konfirmasi
                                      final ok = await showDialog<bool>(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          backgroundColor: AppColors.card,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          title: const Text(
                                            "Konfirmasi Produksi",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          content: const Text(
                                            "Stok bahan akan dikurangi sesuai kebutuhan produksi. Lanjutkan?",
                                            style: TextStyle(color: Colors.white60),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text(
                                                "Batal",
                                                style: TextStyle(
                                                    color: Colors.white38),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text(
                                                "Konfirmasi",
                                                style: TextStyle(
                                                    color: AppColors.secondary),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (ok == true) {
                                        await prodCtrl.konfirmasiProduksi();
                                        // DashboardController otomatis recalc
                                        // via ever(sessionAktif)
                                        setState(() => _confirmed = true);
                                      }
                                    }
                                  : null,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _confirmed
                                          ? Icons.check_circle_rounded
                                          : Icons.check_circle_rounded,
                                      color: semuaCukup && !_confirmed
                                          ? Colors.white
                                          : Colors.white38,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      _confirmed
                                          ? "Produksi Selesai"
                                          : semuaCukup
                                              ? "Konfirmasi Produksi"
                                              : "Stok Tidak Mencukupi",
                                      style: TextStyle(
                                        color: semuaCukup && !_confirmed
                                            ? Colors.white
                                            : Colors.white38,
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
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value, Color valueColor) {
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
}
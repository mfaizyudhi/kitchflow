// analytics_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../best_menu/controllers/best_menu_controller.dart';
import '../../../../controllers/models/sales_controller.dart';
import '../../../../services/activity_log_service.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({super.key});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> {
  int _selectedPeriod = 0;
  final List<String> _periods = ["Harian", "Mingguan", "Bulanan"];

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
                    AppColors.primary.withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 100,
            left: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withOpacity(0.1),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TITLE
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Analitik ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                                height: 1.1,
                              ),
                            ),
                            TextSpan(
                              text: "Penjualan",
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// SUBTITLE
                      const Text(
                        "Performa penjualan Anda",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// PERIOD TOGGLE
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              _periods.length,
                              (i) {
                                final isActive = _selectedPeriod == i;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedPeriod = i;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 250),
                                    margin: EdgeInsets.only(
                                      right:
                                          i != _periods.length - 1 ? 4 : 0,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: isActive
                                          ? AppColors.brandGradient
                                          : null,
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      boxShadow: isActive
                                          ? [
                                              BoxShadow(
                                                color: AppColors.primary
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Text(
                                      _periods[i],
                                      style: TextStyle(
                                        color: isActive
                                            ? Colors.white
                                            : AppColors.textSecondary,
                                        fontSize: 12,
                                        fontWeight: isActive
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ✅ TOMBOL INPUT PENJUALAN
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: AppColors.brandGradient,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: _showInputPenjualanDialog,
                            child: const Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_chart_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Input Penjualan Harian",
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

                  const SizedBox(height: 20),

                  // ── STAT CARDS ───────────────────────────────────
                  Obx(() {
                    final salesCtrl = SalesController.to;
                    final stats = salesCtrl.statsForPeriod(_selectedPeriod);
                    final periodLabel = _statPeriodLabel();

                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _statCard(
                              "Penjualan\n$periodLabel",
                              _formatRupiah(stats.total),
                              Icons.trending_up_rounded,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _statCard(
                              "Porsi\n$periodLabel",
                              "${stats.porsi}",
                              Icons.dinner_dining_rounded,
                              AppColors.secondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _statCard(
                              "Transaksi\n$periodLabel",
                              "${stats.transaksi}",
                              Icons.receipt_long_rounded,
                              AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // ── GRAFIK ───────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Text(
                          "Grafik Pertumbuhan Penjualan",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _periodLabel(),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Obx(() {
                    final salesCtrl = SalesController.to;

                    if (salesCtrl.isLoading.value) {
                      return const GlassCard(
                        child: SizedBox(
                          height: 150,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      );
                    }

                    final data = _dataForPeriod(salesCtrl);

                    if (data.values.every((v) => v == 0)) {
                      return GlassCard(
                        child: SizedBox(
                          height: 150,
                          child: Center(
                            child: Text(
                              "Belum ada data penjualan",
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return GlassCard(
                      child: _buildBarChart(data),
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

  // ── AMBIL DATA SESUAI TOGGLE PERIODE ────────────────────────────────
  Map<DateTime, double> _dataForPeriod(SalesController salesCtrl) {
    switch (_selectedPeriod) {
      case 1:
        return salesCtrl.weeklyTotals();
      case 2:
        return salesCtrl.monthlyTotals();
      default:
        return salesCtrl.dailyTotals();
    }
  }

  String _periodLabel() {
    switch (_selectedPeriod) {
      case 1:
        return "8 minggu terakhir";
      case 2:
        return "6 bulan terakhir";
      default:
        return "7 hari terakhir";
    }
  }

  String _statPeriodLabel() {
    switch (_selectedPeriod) {
      case 1:
        return "Minggu Ini";
      case 2:
        return "Bulan Ini";
      default:
        return "Hari Ini";
    }
  }

  String _formatRupiah(double value) {
    final str = value.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final posFromRight = str.length - i;
      buffer.write(str[i]);
      if (posFromRight > 1 && posFromRight % 3 == 1) {
        buffer.write('.');
      }
    }
    return "Rp $buffer";
  }

  // ── DIALOG INPUT PENJUALAN ──────────────────────────────────────────
  void _showInputPenjualanDialog() {
    final menuCtrl = BestMenuController.to;
    final salesCtrl = SalesController.to;

    dynamic selectedMenu;
    final qtyCtrl = TextEditingController(text: '1');

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── HANDLE ─────────────────────────────────────
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── HEADER ─────────────────────────────────────
                RichText(
                  text: const TextSpan(children: [
                    TextSpan(
                      text: "Input ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "Penjualan",
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ),
                const Text(
                  "Catat penjualan menu hari ini",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),

                // ── PILIH MENU (dari Best Menu) ──────────────
                const Text(
                  "Pilih Menu",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),

                Obx(() {
                  final menus = menuCtrl.menus;

                  if (menus.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: const Text(
                        "Belum ada menu. Tambahkan menu di halaman List Menu terlebih dahulu.",
                        style: TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    );
                  }

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<dynamic>(
                        isExpanded: true,
                        dropdownColor: AppColors.card,
                        value: selectedMenu,
                        hint: const Text(
                          "Pilih menu yang terjual",
                          style: TextStyle(color: Colors.white38, fontSize: 13),
                        ),
                        items: menus.map((m) {
                          return DropdownMenuItem(
                            value: m,
                            child: Text(
                              m.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setModalState(() => selectedMenu = val);
                        },
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 14),

                // ── JUMLAH PORSI ──────────────────────────────
                const Text(
                  "Jumlah Porsi Terjual",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: qtyCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Contoh: 20",
                    hintStyle: const TextStyle(
                      color: AppColors.textHint,
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.dinner_dining_rounded,
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
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                // ── PREVIEW TOTAL ─────────────────────────────
                if (selectedMenu != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.secondary.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Estimasi Total",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _formatRupiah(
                            (selectedMenu.hargaJual as double) *
                                (int.tryParse(qtyCtrl.text) ?? 0),
                          ),
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // ── TOMBOL SIMPAN ──────────────────────────────
                Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: AppColors.brandGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () async {
                        if (selectedMenu == null) {
                          Get.snackbar(
                            "Perhatian",
                            "Pilih menu terlebih dahulu",
                            backgroundColor: Colors.orange.withOpacity(0.8),
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                          );
                          return;
                        }

                        final qty = int.tryParse(qtyCtrl.text) ?? 0;
                        if (qty <= 0) {
                          Get.snackbar(
                            "Perhatian",
                            "Jumlah porsi harus lebih dari 0",
                            backgroundColor: Colors.orange.withOpacity(0.8),
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                          );
                          return;
                        }

                        await salesCtrl.addSale(
                          menuId: selectedMenu.id,
                          menuName: selectedMenu.name,
                          qty: qty,
                          hargaSatuan: selectedMenu.hargaJual,
                        );

                        await ActivityLogService.log(
    type: 'penjualan',
    title: 'Penjualan dicatat',
    description:
        '${selectedMenu.name} x$qty (${_formatRupiah(selectedMenu.hargaJual * qty)})',
  );

                        Get.back();
                        Get.snackbar(
                          "Berhasil! 🎉",
                          "Laporan penjualan ${selectedMenu.name} tersimpan",
                          backgroundColor: Colors.green.withOpacity(0.85),
                          colorText: Colors.white,
                          snackPosition: SnackPosition.TOP,
                        );
                      },
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Simpan Laporan",
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
      ),
    );
  }

  // ── HELPERS ──────────────────────────────────────────────────────

  Widget _statCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      height: 128,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(Map<DateTime, double> data) {
    final entries = data.entries.toList();
    final maxVal = entries
        .map((e) => e.value)
        .fold<double>(0, (a, b) => a > b ? a : b);
    final safeMax = maxVal == 0 ? 1.0 : maxVal;

    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: entries.map((e) {
          final isMax = e.value == maxVal && maxVal > 0;
          final barHeight = (e.value / safeMax) * 90;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isMax)
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _shortValue(e.value),
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                const SizedBox(height: 20),

              Container(
                width: 30,
                height: barHeight,
                decoration: BoxDecoration(
                  gradient: isMax
                      ? AppColors.brandGradient
                      : LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.25),
                            AppColors.secondary.withOpacity(0.25),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isMax
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
              ),

              const SizedBox(height: 6),

              Text(
                _dateLabel(e.key),
                style: TextStyle(
                  color: isMax ? Colors.white70 : Colors.white30,
                  fontSize: 10,
                  fontWeight:
                      isMax ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _shortValue(double value) {
    if (value >= 1000000) {
      return "${(value / 1000000).toStringAsFixed(1)}jt";
    }
    if (value >= 1000) {
      return "${(value / 1000).toStringAsFixed(0)}rb";
    }
    return value.toStringAsFixed(0);
  }

  String _dateLabel(DateTime date) {
    if (_selectedPeriod == 0) {
      const hari = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"];
      return hari[date.weekday - 1];
    } else if (_selectedPeriod == 1) {
      return "${date.day}/${date.month}";
    } else {
      const bulan = [
        "Jan", "Feb", "Mar", "Apr", "Mei", "Jun",
        "Jul", "Ags", "Sep", "Okt", "Nov", "Des",
      ];
      return bulan[date.month - 1];
    }
  }
}
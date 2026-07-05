// dashboard_view.dart - HANYA BAGIAN LIST MENU YANG DIOPTIMASI

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/menu_card.dart';
import '../../../../routes/app_pages.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/harga_bahan_baku_chart.dart';
import 'package:kitchflow/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:kitchflow/app/modules/inventory/controllers/inventory_controller.dart';
import 'package:kitchflow/app/modules/best_menu/controllers/best_menu_controller.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final dash     = DashboardController.to;
    final inv      = InventoryController.to;
    final menuCtrl = BestMenuController.to;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
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
          Positioned(
            bottom: 100, left: -60,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.secondary.withOpacity(0.1),
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
                  _buildHeader(),
                  const SizedBox(height: 20),

                  Obx(() => _buildProfitCard(
                    keuntungan:  dash.estimasiKeuntungan.value,
                    stok:        dash.totalStokQty.value,
                    menuCount:   dash.totalProduksiMenu.value,
                    isConfirmed: dash.isDataFinal,
                  )),
                  const SizedBox(height: 16),

                  Obx(() => _buildStockAlert(
                    menipis: dash.itemMenipis,
                    habis:   dash.itemHabis,
                    items:   dash.inventoryItems,
                  )),
                  const SizedBox(height: 24),

                  _buildSectionHeader(
                    title: 'List Menu',
                    actionLabel: 'Lihat Semua',
                    actionColor: AppColors.secondary,
                    onTap: () => Get.toNamed(Routes.BEST_MENU),
                  ),
                  const SizedBox(height: 14),

                  // ================================================
                  // 🔽 YANG DIUBAH: LIST MENU
                  // ================================================
                  Obx(() => _buildMenuGrid(dash.menus)),
                  // ================================================

                  const SizedBox(height: 28),

                  _buildSectionHeader(
                    title: 'Harga Bahan Baku',
                    actionLabel: '7 Hari',
                    actionColor: AppColors.success,
                  ),
                  const SizedBox(height: 14),

                  const HargaBahanBakuChart(),
                  const SizedBox(height: 24),

                  _buildSectionHeader(title: 'Ringkasan Keuangan'),
                  const SizedBox(height: 14),

                  Obx(() => _buildFinanceSummary(
                    penjualan:   dash.totalPenjualan,
                    pengeluaran: dash.totalPengeluaran,
                    profit:      dash.profitBersih,
                    isFinal:     dash.isDataFinal,
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.restaurant_rounded,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            RichText(
              text: const TextSpan(children: [
                TextSpan(
                  text: 'Kitch',
                  style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextSpan(
                  text: 'Flow',
                  style: TextStyle(
                    color: AppColors.secondary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextSpan(
                  text: ' AI',
                  style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ]),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white10),
          ),
          child: Stack(
            children: [
              const Icon(Icons.notifications_none_rounded,
                  color: Colors.white, size: 22),
              Positioned(
                top: 0, right: 0,
                child: Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfitCard({
    required double keuntungan,
    required double stok,
    required int    menuCount,
    required bool   isConfirmed,
  }) {
    final label = isConfirmed ? 'PROFIT TERKONFIRMASI' : 'ESTIMASI KEUNTUNGAN';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 30, offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 11,
                    letterSpacing: 1.2, fontWeight: FontWeight.w600,
                  )),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isConfirmed
                      ? Icons.check_circle_rounded
                      : Icons.trending_up_rounded,
                  color: Colors.green, size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Rp ${_fmt(keuntungan.toInt())}',
            style: const TextStyle(
              color: Colors.white, fontSize: 34,
              fontWeight: FontWeight.bold, letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Text(
              isConfirmed ? '✓ Produksi dikonfirmasi' : '↑ +12% dari kemarin',
              style: const TextStyle(
                color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _statMiniCard(
                  label: 'Total Stok',
                  value: '${stok.toStringAsFixed(1)} kg',
                  icon: Icons.inventory_2_outlined,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statMiniCard(
                  label: 'Produksi',
                  value: '$menuCount Menu',
                  icon: Icons.restaurant_menu_outlined,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statMiniCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: Colors.white38, fontSize: 10)),
              Text(value,
                  style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStockAlert({
    required int menipis,
    required int habis,
    required List<dynamic> items,
  }) {
    final kritis      = items.where((e) => e.status == 'Habis').toList();
    final displayItem = kritis.isNotEmpty
        ? kritis.first
        : items.where((e) => e.status == 'Menipis').firstOrNull;

    final stockText = displayItem != null
        ? 'Persediaan ${displayItem.name} tersisa ${displayItem.stockLabel}. Segera restock!'
        : 'Semua stok dalam kondisi aman.';

    final alertColor = habis > 0
        ? Colors.red
        : menipis > 0
            ? Colors.orange
            : Colors.green;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: alertColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: alertColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: alertColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              habis > 0
                  ? Icons.error_outline_rounded
                  : menipis > 0
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_outline_rounded,
              color: alertColor, size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habis > 0
                      ? 'Notifikasi Stok Habis ($habis item)'
                      : menipis > 0
                          ? 'Notifikasi Stok Hampir Habis ($menipis item)'
                          : 'Stok Aman',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold, fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  stockText,
                  style: const TextStyle(
                    color: Colors.white54, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.white24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    String?   actionLabel,
    Color     actionColor = AppColors.secondary,
    VoidCallback? onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        if (actionLabel != null)
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: actionColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: actionColor.withOpacity(0.3)),
              ),
              child: Text(actionLabel,
                  style: TextStyle(
                    color: actionColor, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ),
      ],
    );
  }

  // ==============================================================
  // 🔽 YANG DIUBAH: MENU GRID - OVERLOAD PIXEL DIKURANGI
  // ==============================================================
  Widget _buildMenuGrid(List<dynamic> menus) {
    if (menus.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Belum ada menu',
              style: TextStyle(color: Colors.white38, fontSize: 14)),
        ),
      );
    }

    final displayMenus = menus.take(6).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,      // 🔽 10 → 8 (lebih kecil)
        mainAxisSpacing: 8,       // 🔽 10 → 8 (lebih kecil)
        childAspectRatio: 0.68,   // 🔽 0.72 → 0.68 (lebih pipih = lebih ringan)
      ),
      itemCount: displayMenus.length,
      itemBuilder: (_, i) {
        final m = displayMenus[i];
        return MenuCard(
          image:     m.imagePath,
          title:     m.name,
          soldLabel: '${m.targetPorsi} porsi',
          badge:     'TOP ${m.rank}',
          soldRatio: m.rekomendasiHarga > 0
              ? (m.hppPerPorsi / m.rekomendasiHarga).clamp(0.0, 1.0)
              : 0.5,
        );
      },
    );
  }
  // ==============================================================

  Widget _buildFinanceSummary({
    required double penjualan,
    required double pengeluaran,
    required double profit,
    required bool   isFinal,
  }) {
    return GlassCard(
      child: Column(
        children: [
          _financeRow(
            isFinal ? 'Total Penjualan' : 'Est. Penjualan',
            'Rp ${_fmt(penjualan.toInt())}',
            AppColors.success,
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 12),
          _financeRow(
            isFinal ? 'Total Pengeluaran' : 'Est. Pengeluaran',
            'Rp ${_fmt(pengeluaran.toInt())}',
            AppColors.warning,
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 12),
          _financeRow(
            isFinal ? 'Profit Bersih' : 'Est. Profit',
            'Rp ${_fmt(profit.toInt())}',
            AppColors.secondary,
          ),
          if (isFinal) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.2)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.green, size: 12),
                  SizedBox(width: 6),
                  Text('Data Produksi Terkonfirmasi',
                      style: TextStyle(color: Colors.green, fontSize: 11)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _financeRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 13)),
        Text(value,
            style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 14)),
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
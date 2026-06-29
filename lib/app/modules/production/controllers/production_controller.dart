// lib/modules/production/controllers/production_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchflow/app/modules/best_menu/controllers/best_menu_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../controllers/models/menu_item.dart';
import '../../../modules/hpp/controllers/hpp_controller.dart';
import '../../../modules/inventory/controllers/inventory_controller.dart';
import '../../../../controllers/models/production_session.dart';
import '../../../../controllers/models/inventory_item.dart';

export '../../../../controllers/models/production_session.dart';

// ── MODEL ─────────────────────────────────────────────────────────────────────

class KebutuhanBahanItem {
  final String   name;
  final double   needed;
  final double   stock;
  final bool     enough;
  final IconData icon;
  final String   unit;

  const KebutuhanBahanItem({
    required this.name,
    required this.needed,
    required this.stock,
    required this.enough,
    required this.icon,
    required this.unit,
  });

  String get neededLabel =>
      "${needed % 1 == 0 ? needed.toInt() : needed} $unit";

  String get stockLabel =>
      "${stock % 1 == 0 ? stock.toInt() : stock} $unit";
}

// ── CONTROLLER ────────────────────────────────────────────────────────────────

class ProductionController extends GetxController {
  static ProductionController get to => Get.find();

  final _sb = Supabase.instance.client;

  // ── STATE ──────────────────────────────────────────────────────────────────

  /// Target porsi yang bisa diubah user di ProductionView
  final RxInt targetPorsi = 50.obs;

  /// Sesi produksi yang sudah dikonfirmasi (dipakai Dashboard)
  final Rx<ProductionSession?> sessionAktif = Rx<ProductionSession?>(null);

  // ── COMPUTED ───────────────────────────────────────────────────────────────

  /// Menu yang sedang diproduksi (dari BestMenuController)
  MenuItem? get activeMenu => BestMenuController.to.activeMenu.value;

  /// Rekomendasi harga jual per porsi (dari HppController)
  double get hargaJualPerPorsi => HppController.to.rekomendasiHarga.value;

  /// Total modal produksi (dari HppController)
  double get totalModal => HppController.to.totalModal.value;

  /// Estimasi total penjualan = hargaJual × targetPorsi
  double get estimasiPenjualan => hargaJualPerPorsi * targetPorsi.value;

  /// Estimasi profit = penjualan - modal
  double get estimasiProfit => estimasiPenjualan - totalModal;

  /// Hitung kebutuhan bahan untuk porsi tertentu vs stok inventory.
  /// Return List<KebutuhanBahanItem> — type-safe, langsung pakai di View.
  List<KebutuhanBahanItem> get kebutuhanBahan {
    final menu = activeMenu;
    if (menu == null) return [];

    return menu.ingredients.map((ing) {
      final item = InventoryController.to.findById(ing.inventoryItemId);
      if (item == null) return null;

      final needed = ing.qtyNeeded * targetPorsi.value;
      return KebutuhanBahanItem(
        name:   item.name,
        needed: needed,
        stock:  item.stockQty,
        enough: item.stockQty >= needed,
        icon:   Icons.lunch_dining_rounded,
        unit:   item.unit,
      );
    }).whereType<KebutuhanBahanItem>().toList();
  }

  /// Apakah semua bahan mencukupi untuk targetPorsi saat ini
  bool get semuaBahanCukup =>
      kebutuhanBahan.isNotEmpty &&
      kebutuhanBahan.every((k) => k.enough);

  /// Jumlah bahan yang tidak cukup
  int get jumlahBahanKurang =>
      kebutuhanBahan.where((k) => !k.enough).length;

  // ── SET TARGET PORSI ───────────────────────────────────────────────────────

  /// Sinkronkan targetPorsi dengan menu baru saat pindah menu
  void syncTargetPorsi() {
    targetPorsi.value = activeMenu?.targetPorsi ?? 50;
  }

  // ── KONFIRMASI PRODUKSI ────────────────────────────────────────────────────

  Future<void> konfirmasiProduksi() async {
    final menu  = activeMenu;
    final porsi = targetPorsi.value;
    if (menu == null || porsi <= 0) return;

    // 1. Kurangi stok
    for (final ing in menu.ingredients) {
      final item = InventoryController.to.findById(ing.inventoryItemId);
      if (item == null) continue;
      final newQty = (item.stockQty - ing.qtyNeeded * porsi)
          .clamp(0.0, double.infinity);
      await InventoryController.to.updateStok(item.id, newQty);
    }

    // 2. Simpan ke Supabase
    final session = ProductionSession(
      menuId:            menu.id,
      targetPorsi:       porsi,
      totalModal:        totalModal,
      estimasiPenjualan: estimasiPenjualan,
      estimasiProfit:    estimasiProfit,
      status:            'confirmed',
    );

    await _sb.from('productions').insert(session.toJson());

    // 3. Update state aktif → DashboardController.ever(sessionAktif) recalc
    session.status     = 'confirmed';
    sessionAktif.value = session;
  }

  // ── LOAD PRODUKSI HARI INI ─────────────────────────────────────────────────

  Future<void> loadProduksiHariIni() async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day).toIso8601String();
    final end   = DateTime(today.year, today.month, today.day, 23, 59, 59)
        .toIso8601String();

    final rows = await _sb
        .from('productions')
        .select()
        .eq('status', 'confirmed')
        .gte('created_at', start)
        .lte('created_at', end)
        .order('created_at', ascending: false)
        .limit(1);

    if ((rows as List).isNotEmpty) {
      sessionAktif.value =
          ProductionSession.fromJson(rows.first as Map<String, dynamic>);
    }
  }
}
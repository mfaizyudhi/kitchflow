// lib/controllers/inventory_controller.dart
//
// TANGGUNG JAWAB:
//   • Stream realtime tabel inventory_items dari Supabase
//   • CRUD: addItem, updateStok, deleteItem
//   • Expose RxList<InventoryItem> yang dipakai oleh:
//       - InventoryView (tampilan utama)
//       - HppController (harga per unit untuk hitung HPP)
//       - ProductionController (cek stok vs kebutuhan bahan)
//       - BestMenuController (pilih bahan saat tambah menu)
//       - DashboardController (totalStokKg, itemMenipis, itemHabis)
//
// TABEL SUPABASE: inventory_items
//   id, name, stock_qty, unit, price_per_unit, category, status, image_path

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../controllers/models/inventory_item.dart';

export '../../../../controllers/models/inventory_item.dart';

class InventoryController extends GetxController {

  
  bool cekStokCukup(String itemId, double kebutuhan) {
  final item = findById(itemId);
  if (item == null) return false;
  return item.stockQty >= kebutuhan;
}
  static InventoryController get to => Get.find();

  final _sb = Supabase.instance.client;

  // ── STATE ─────────────────────────────────────────────────────────────────

  /// List inventory realtime — semua controller lain baca dari sini
  final RxList<InventoryItem> items = <InventoryItem>[].obs;
  final RxBool isLoading = false.obs;

  // ── COMPUTED ──────────────────────────────────────────────────────────────

  /// Total qty semua item (untuk Dashboard → "Total Stok")
  double get totalStokQty =>
      items.fold(0.0, (sum, i) => sum + i.stockQty);

  /// Jumlah item berstatus Menipis
  int get itemMenipis =>
      items.where((i) => i.status == 'Menipis').length;

  /// Jumlah item berstatus Habis
  int get itemHabis =>
      items.where((i) => i.status == 'Habis').length;

  /// Cari item by id (dipakai HppController & ProductionController)
  InventoryItem? findById(String id) =>
      items.firstWhereOrNull((i) => i.id == id);

  // ── LIFECYCLE ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _listenInventory();
  }

  // ── REALTIME STREAM ───────────────────────────────────────────────────────

  /// Subscribe perubahan tabel inventory_items → update RxList otomatis
  void _listenInventory() {
    isLoading.value = true;
    _sb
        .from('inventory_items')
        .stream(primaryKey: ['id'])
        .listen((rows) {
          items.value = rows.map(InventoryItem.fromJson).toList();
          isLoading.value = false;
        });
  }

  // ── CRUD ──────────────────────────────────────────────────────────────────

  /// Update qty stok sebuah item.
  /// Status otomatis dihitung: Habis / Menipis / Aman.
  /// Dipanggil dari:
  ///   - InventoryView (edit manual)
  ///   - ProductionController.konfirmasiProduksi() (kurangi stok)
  Future<void> updateStok(String itemId, double newQty) async {
    final status = InventoryItem.resolveStatus(newQty);
    await _sb.from('inventory_items').update({
      'stock_qty': newQty,
      'status':    status,
    }).eq('id', itemId);
    // Stream otomatis refresh items
  }

  /// Tambah item baru ke Supabase.
  /// Dipanggil dari InventoryView (form tambah bahan).
  Future<void> addItem(InventoryItem item) async {
    final json = item.toJson()..remove('id'); // id di-generate Supabase
    await _sb.from('inventory_items').insert(json);
  }

  /// Hapus item dari Supabase.
  Future<void> deleteItem(String itemId) async {
    await _sb.from('inventory_items').delete().eq('id', itemId);
  }

  // ── HELPER ────────────────────────────────────────────────────────────────

  /// Harga per unit item berdasarkan id
  /// Dipakai HppController saat harga wilayah tidak tersedia
  double hargaNasional(String itemId) =>
      findById(itemId)?.pricePerUnit ?? 0;
}
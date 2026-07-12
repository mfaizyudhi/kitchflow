import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// ── IMPORT DARI KODE BARU ──────────────────────────────────────────────────
import '../../../../app/modules/inventory/controllers/inventory_controller.dart';
import '../../../../app/modules/best_menu/controllers/best_menu_controller.dart';
import '../../../../app/modules/production/controllers/production_controller.dart';

class DashboardController extends GetxController {
  // Tambahan dari kode baru untuk mempermudah pemanggilan secara global
  static DashboardController get to => Get.find();

  // ── STATE (KODE LAMA) ───────────────────────────────────────────────────
  final hargaBahanBaku = <String, List<Map<String, dynamic>>>{}.obs;
  final statistikHarga = <String, Map<String, dynamic>>{}.obs;
  final daftarKomoditas = <String>[].obs;
  final isLoadingHarga = false.obs;
  final hargaError = ''.obs;

  // ── STATE AGREGASI (KODE BARU) ──────────────────────────────────────────
  /// Estimasi keuntungan yang ditampilkan di hero card Dashboard.
  final RxDouble estimasiKeuntungan = 0.0.obs;

  /// Total qty semua stok (dari InventoryController)
  final RxDouble totalStokQty = 0.0.obs;

  /// Total menu aktif (dari BestMenuController)
  final RxInt totalProduksiMenu = 0.obs;

  // ── CONFIG (KODE LAMA) ──────────────────────────────────────────────────
  // 🔴 GANTI dengan URL ngrok dari output Cell 5 Colab
  static const String baseUrl =
      "https://prognosticable-drema-whiningly.ngrok-free.dev";

  // Daftar tab default (fallback kalau API /komoditas belum tersedia)
  static const List<String> defaultTabs = [
    'Ayam Broiler',
    'Minyak Goreng',
    'Telur Ayam',
    'Beras',
    'Cabai Merah',
    'Bawang Merah',
  ];

  // Warna per komoditas — urutan sama dengan defaultTabs
  static const List<Color> _tabColors = [
    Color(0xFF9B7FE8), // Ayam Broiler  — ungu
    Color(0xFF7EC8E3), // Minyak Goreng — biru
    Color(0xFFEF9F27), // Telur Ayam    — kuning
    Color(0xFF4CAF50), // Beras         — hijau
    Color(0xFFE24B4A), // Cabai Merah   — merah
    Color(0xFFFF7043), // Bawang Merah  — oranye
    Color(0xFF9B7FE8), // fallback
  ];

  // ── COMPUTED (KODE BARU) ────────────────────────────────────────────────
  ProductionSession? get sessionAktif =>
      ProductionController.to.sessionAktif.value;

  /// Total penjualan: dari sesi produksi atau estimasi dari HPP
  double get totalPenjualan =>
      sessionAktif?.estimasiPenjualan ??
      ProductionController.to.estimasiPenjualan;

  /// Total pengeluaran (modal): dari sesi produksi atau dari HPP
  double get totalPengeluaran =>
      sessionAktif?.totalModal ?? ProductionController.to.totalModal;

  /// Profit bersih: dari sesi produksi atau estimasi
  double get profitBersih =>
      sessionAktif?.estimasiProfit ?? ProductionController.to.estimasiProfit;

  /// Apakah data di Dashboard sudah final (dari produksi confirmed)
  bool get isDataFinal => sessionAktif?.status == 'confirmed';

  // ── LIFECYCLE ──────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();

    if (Get.testMode) {
      daftarKomoditas.value = defaultTabs;
      return;
    }

    // Menjalankan inisialisasi dari kode lama
    _loadAll();

    // Menjalankan inisialisasi dari kode baru
    _setupReactivity();
    _loadInitialData();
  }

  // Penggabungan fungsi refresh (mengakomodasi kode lama)
  Future<void> refreshData() => _loadAll();

  // ── LIFECYCLE HANDLERS (KODE LAMA) ──────────────────────────────────────

  Future<void> _loadAll() async {
    await Future.wait([
      fetchKomoditas(),
      fetchHargaBahanBaku(),
      fetchStatistik(),
    ]);
  }

  // ── LIFECYCLE HANDLERS (KODE BARU) ──────────────────────────────────────

  void _setupReactivity() {
    // Setiap inventory berubah → recalc totalStok + estimasi
    ever(InventoryController.to.items, (_) => _recalc());

    // Setiap menus berubah (termasuk setelah HPP diupdate) → recalc estimasi
    ever(BestMenuController.to.menus, (_) => _recalc());

    // Setiap sesi produksi berubah → recalc estimasi keuntungan final
    ever(ProductionController.to.sessionAktif, (_) => _recalc());
  }

  Future<void> _loadInitialData() async {
    // Cek apakah ada produksi hari ini yang sudah dikonfirmasi
    await ProductionController.to.loadProduksiHariIni();
    _recalc();
  }

  // ── RECALCULATE (KODE BARU) ─────────────────────────────────────────────

  /// Dipanggil otomatis setiap ada perubahan di inventory, menus, atau production.
  void _recalc() {
    // ── Total stok dari inventory ──
    totalStokQty.value = InventoryController.to.totalStokQty;

    // ── Total menu aktif ──
    totalProduksiMenu.value = BestMenuController.to.menus.length;

    // ── Estimasi keuntungan ──
    final sesi = ProductionController.to.sessionAktif.value;
    if (sesi != null && sesi.status == 'confirmed') {
      // Ada produksi terkonfirmasi hari ini → tampilkan profit aktual
      estimasiKeuntungan.value = sesi.estimasiProfit;
    } else {
      // Belum ada produksi → jumlah estimasiProfit semua menu dari HPP
      estimasiKeuntungan.value = BestMenuController.to.totalEstimasiProfit;
    }
  }

  // ── FETCH METHODS (KODE LAMA) ──────────────────────────────────────────

  Future<void> fetchKomoditas() async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/api/komoditas'),
        headers: {'ngrok-skip-browser-warning': 'true'},
      ).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final list = (body['data'] as List).cast<String>();
        daftarKomoditas.value = list.isNotEmpty ? list : defaultTabs;
      }
    } catch (e) {
      print('fetchKomoditas error type: ${e.runtimeType}');
      print('fetchKomoditas error detail: $e');
      daftarKomoditas.value = defaultTabs;
    }
  }

  Future<void> fetchHargaBahanBaku({int hari = 7}) async {
    isLoadingHarga.value = true;
    hargaError.value = '';

    try {
      final uri = Uri.parse('$baseUrl/api/harga-bahan-baku')
          .replace(queryParameters: {'hari': '$hari'});

      final res = await http.get(uri, headers: {
        'ngrok-skip-browser-warning': 'true'
      }).timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        print('raw response.body: ${res.body}');
        final body = jsonDecode(res.body) as Map<String, dynamic>;

        if (body['status'] == 'ok' && body['data'] != null) {
          final Map<String, List<Map<String, dynamic>>> grouped = {};
          
          if (body['data'] is List) {
            // Format List
            final rawList = body['data'] as List;
            for (final item in rawList) {
              if (item is Map) {
                final typedItem = Map<String, dynamic>.from(item);
                final komoditas = typedItem['komoditas'] as String? ?? '';
                if (komoditas.isNotEmpty) {
                  grouped.putIfAbsent(komoditas, () => []);
                  grouped[komoditas]!.add(<String, dynamic>{
                    'tanggal': typedItem['tanggal'] as String? ?? '',
                    'hari': typedItem['hari'] as String? ?? '',
                    'harga': (typedItem['harga'] as num?)?.toDouble() ?? 0.0,
                    'satuan': typedItem['satuan'] as String? ?? 'Rp/kg',
                  });
                }
              }
            }
          } else if (body['data'] is Map) {
            // Format Map (seperti dari Google Colab Anda)
            final rawMap = body['data'] as Map<String, dynamic>;
            rawMap.forEach((komoditas, listData) {
              if (listData is List) {
                grouped[komoditas] = listData.map((item) {
                  final m = Map<String, dynamic>.from(item as Map);
                  return <String, dynamic>{
                    'tanggal': m['tanggal'] as String? ?? '',
                    'hari': m['hari'] as String? ?? '',
                    'harga': (m['harga'] as num?)?.toDouble() ?? 0.0,
                    'satuan': m['satuan'] as String? ?? 'Rp/kg',
                  };
                }).toList();
              }
            });
          }
          hargaBahanBaku.value = grouped;
        } else {
          hargaError.value = body['message'] as String? ?? 'Gagal memuat data';
        }
      } else {
        hargaError.value = 'Server error (${res.statusCode})';
      }
    } catch (e) {
      print('fetchHargaBahanBaku error type: ${e.runtimeType}');
      print('fetchHargaBahanBaku error detail: $e');
      debugPrint('fetchHargaBahanBaku error: $e');
      hargaError.value =
          'Tidak dapat terhubung ke server.\nPastikan Google Colab masih berjalan.';
    } finally {
      isLoadingHarga.value = false;
    }
  }

  Future<void> fetchStatistik({int hari = 7}) async {
    try {
      final uri = Uri.parse('$baseUrl/api/statistik')
          .replace(queryParameters: {'hari': '$hari'});

      final res = await http.get(uri, headers: {
        'ngrok-skip-browser-warning': 'true'
      }).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        if (body['status'] == 'ok' && body['data'] != null) {
          final raw = body['data'] as Map<String, dynamic>;
          statistikHarga.value = raw.map((k, v) {
            if (v is Map) {
              return MapEntry(k, Map<String, dynamic>.from(v));
            }
            return MapEntry(k, <String, dynamic>{});
          });
        }
      }
    } catch (e) {
      print('fetchStatistik error type: ${e.runtimeType}');
      print('fetchStatistik error detail: $e');
      debugPrint('fetchStatistik error: $e');
    }
  }

  // ── HELPERS & SHORTCUTS (KODE LAMA & BARU) ──────────────────────────────

  Color colorForKomoditas(String nama) {
    final idx = defaultTabs.indexOf(nama);
    if (idx >= 0 && idx < _tabColors.length) return _tabColors[idx];
    return _tabColors.last;
  }

  static String formatRupiah(double value) {
    if (value <= 0) return '-';
    return 'Rp ${value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        )}';
  }

  /// Shortcut ke inventory items (dipakai _buildStockAlert di DashboardView)
  List get inventoryItems => InventoryController.to.items;

  int get itemMenipis => InventoryController.to.itemMenipis;
  int get itemHabis => InventoryController.to.itemHabis;

  /// Shortcut ke menus (dipakai _buildMenuGrid di DashboardView)
  List get menus => BestMenuController.to.menus;
  bool get isLoadingMenus => BestMenuController.to.isLoading.value;
}
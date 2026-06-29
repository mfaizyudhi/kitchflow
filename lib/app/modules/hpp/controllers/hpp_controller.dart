// lib/modules/hpp/controllers/hpp_controller.dart

import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kitchflow/app/modules/best_menu/controllers/best_menu_controller.dart';
import 'package:kitchflow/app/modules/inventory/controllers/inventory_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../controllers/models/menu_item.dart';

// Mode sumber harga
enum SumberHarga { lokal, pasar }

class HppController extends GetxController {
  static HppController get to => Get.find();

  final _sb = Supabase.instance.client;

  // ── STATE ──────────────────────────────────────────────────────────────────
  final RxDouble hppPerPorsi      = 0.0.obs;
  final RxDouble rekomendasiHarga = 0.0.obs;
  final RxDouble totalModal       = 0.0.obs;
  final RxBool   hppSudahDihitung = false.obs;
  final RxBool   hppDikonfirmasi  = false.obs;
  final RxBool   isLoading        = false.obs;
  final RxBool   tidakAdaBahan    = false.obs;

  // HPP & rekomendasi per mode
  final RxDouble hppLokal         = 0.0.obs;
  final RxDouble rekomendasiLokal = 0.0.obs;
  final RxDouble modalLokal       = 0.0.obs;

  final RxDouble hppPasar         = 0.0.obs;
  final RxDouble rekomendasiPasar = 0.0.obs;
  final RxDouble modalPasar       = 0.0.obs;

  // Mode aktif
  final Rx<SumberHarga> modeSumber = SumberHarga.lokal.obs;

  // Harga pasar yang diinput manual user: itemId → harga
  final RxMap<String, double> hargaPasarManual = <String, double>{}.obs;

  // Lokasi
  final RxString wilayah   = 'Mendeteksi lokasi...'.obs;
  final RxString koordinat = ''.obs;
  final RxBool   isLoadingLokasi = false.obs;

  Map<String, double> _hargaWilayahAktif = {};

  // ── COMPUTED ───────────────────────────────────────────────────────────────
  MenuItem? get activeMenu => BestMenuController.to.activeMenu.value;

  double get estimasiProfitHpp {
    final porsi = activeMenu?.targetPorsi ?? 0;
    return (rekomendasiHarga.value - hppPerPorsi.value) * porsi;
  }

  double get estimasiProfitLokal {
    final porsi = activeMenu?.targetPorsi ?? 0;
    return (rekomendasiLokal.value - hppLokal.value) * porsi;
  }

  double get estimasiProfitPasar {
    final porsi = activeMenu?.targetPorsi ?? 0;
    return (rekomendasiPasar.value - hppPasar.value) * porsi;
  }

  double get selisihHarga {
    final menu = activeMenu;
    if (menu == null) return 0;
    return modalPasar.value > 0
        ? modalPasar.value - modalLokal.value
        : 0;
  }

  // ── DETEKSI LOKASI ─────────────────────────────────────────────────────────
  Future<void> detectLokasi() async {
    isLoadingLokasi.value = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        wilayah.value   = 'Layanan GPS tidak aktif';
        koordinat.value = '';
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          wilayah.value   = 'Izin lokasi ditolak';
          koordinat.value = '';
          return;
        }
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      koordinat.value =
          '${pos.latitude.toStringAsFixed(4)}° ${pos.latitude < 0 ? 'S' : 'N'}, '
          '${pos.longitude.toStringAsFixed(4)}° ${pos.longitude < 0 ? 'W' : 'E'}';

      final placemarks = await placemarkFromCoordinates(
          pos.latitude, pos.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        wilayah.value =
            '${p.subAdministrativeArea ?? p.locality ?? ''}, ${p.administrativeArea ?? ''}';
      }
    } catch (e) {
      wilayah.value   = 'Gagal deteksi lokasi';
      koordinat.value = '';
    } finally {
      isLoadingLokasi.value = false;
    }
  }

  // ── HITUNG HPP LOKAL (dari harga wilayah 85%) ──────────────────────────────
  Future<void> hitungHPP({
    required Map<String, double> hargaWilayah,
    int? porsiTarget,
  }) async {
    final menu = activeMenu;
    if (menu == null || menu.ingredients.isEmpty) {
      tidakAdaBahan.value    = true;
      hppSudahDihitung.value = false;
      isLoading.value        = false;
      return;
    }

    tidakAdaBahan.value    = false;
    _hargaWilayahAktif     = hargaWilayah;
    final porsi            = porsiTarget ?? menu.targetPorsi;
    isLoading.value        = true;

    double modal = 0;
    for (final ing in menu.ingredients) {
      final harga = hargaWilayah[ing.inventoryItemId] ??
          InventoryController.to.hargaNasional(ing.inventoryItemId);
      modal += harga * ing.qtyNeeded * porsi;
    }

    final hpp         = porsi > 0 ? modal / porsi : 0.0;
    final rekomendasi = _bulatkanRibu(hpp * 1.4);

    modalLokal.value       = modal;
    hppLokal.value         = hpp;
    rekomendasiLokal.value = rekomendasi;

    // Set aktif jika mode lokal
    if (modeSumber.value == SumberHarga.lokal) {
      totalModal.value       = modal;
      hppPerPorsi.value      = hpp;
      rekomendasiHarga.value = rekomendasi;
    }

    hppSudahDihitung.value = true;
    hppDikonfirmasi.value  = false;

    try {
      await _sb.from('hpp_results').insert({
        'menu_id':           menu.id,
        'hpp_per_porsi':     hpp,
        'rekomendasi_harga': rekomendasi,
        'total_modal':       modal,
      });
    } catch (e) {
      print('Error saving HPP: $e');
    }

    await BestMenuController.to.refreshMenuHpp(
      menuId:      menu.id,
      hpp:         hpp,
      rekomendasi: rekomendasi,
      modal:       modal,
    );

    isLoading.value = false;
  }

  // ── HITUNG HPP PASAR (dari harga manual user) ──────────────────────────────
  Future<void> hitungHPPPasar({int? porsiTarget}) async {
    final menu = activeMenu;
    if (menu == null || menu.ingredients.isEmpty) return;

    final porsi = porsiTarget ?? menu.targetPorsi;
    isLoading.value = true;

    double modal = 0;
    for (final ing in menu.ingredients) {
      final harga = hargaPasarManual[ing.inventoryItemId] ??
          InventoryController.to.hargaNasional(ing.inventoryItemId);
      modal += harga * ing.qtyNeeded * porsi;
    }

    final hpp         = porsi > 0 ? modal / porsi : 0.0;
    final rekomendasi = _bulatkanRibu(hpp * 1.4);

    modalPasar.value       = modal;
    hppPasar.value         = hpp;
    rekomendasiPasar.value = rekomendasi;

    // Update aktif jika mode pasar
    if (modeSumber.value == SumberHarga.pasar) {
      totalModal.value       = modal;
      hppPerPorsi.value      = hpp;
      rekomendasiHarga.value = rekomendasi;
    }

    hppSudahDihitung.value = true;
    isLoading.value        = false;
  }

  // ── GANTI MODE ─────────────────────────────────────────────────────────────
  void gantiMode(SumberHarga mode) {
    modeSumber.value = mode;
    if (mode == SumberHarga.lokal && hppLokal.value > 0) {
      totalModal.value       = modalLokal.value;
      hppPerPorsi.value      = hppLokal.value;
      rekomendasiHarga.value = rekomendasiLokal.value;
    } else if (mode == SumberHarga.pasar && hppPasar.value > 0) {
      totalModal.value       = modalPasar.value;
      hppPerPorsi.value      = hppPasar.value;
      rekomendasiHarga.value = rekomendasiPasar.value;
    }
  }

  // ── SET HARGA PASAR MANUAL ─────────────────────────────────────────────────
  void setHargaPasar(String itemId, double harga) {
    hargaPasarManual[itemId] = harga;
  }

  // ── KONFIRMASI ─────────────────────────────────────────────────────────────
  void confirmHPP() => hppDikonfirmasi.value = true;

  // ── RESET ──────────────────────────────────────────────────────────────────
  void resetHpp() {
    hppPerPorsi.value      = 0;
    rekomendasiHarga.value = 0;
    totalModal.value       = 0;
    hppSudahDihitung.value = false;
    hppDikonfirmasi.value  = false;
    tidakAdaBahan.value    = false;
    hppLokal.value         = 0;
    rekomendasiLokal.value = 0;
    modalLokal.value       = 0;
    hppPasar.value         = 0;
    rekomendasiPasar.value = 0;
    modalPasar.value       = 0;
    modeSumber.value       = SumberHarga.lokal;
    hargaPasarManual.clear();
    _hargaWilayahAktif     = {};
  }

  // ── HELPER ─────────────────────────────────────────────────────────────────
  double _bulatkanRibu(double v) => (v / 1000).ceil() * 1000.0;

  double hargaEfektif(String itemId) =>
      _hargaWilayahAktif[itemId] ??
      InventoryController.to.hargaNasional(itemId);

  @override
  void onInit() {
    super.onInit();
    detectLokasi();
  }
}
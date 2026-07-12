// lib/modules/hpp/controllers/hpp_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:kitchflow/core/theme/app_colors.dart';
import 'package:kitchflow/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:kitchflow/app/modules/best_menu/controllers/best_menu_controller.dart';
import 'package:kitchflow/app/modules/inventory/controllers/inventory_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Mode sumber harga
enum SumberHarga { lokal, pasar }

class HppController extends GetxController {
  static HppController get to => Get.find();

  SupabaseClient get _sb => Supabase.instance.client;

  // ── STATE ──────────────────────────────────────────────────────────────────
  final RxDouble hppPerPorsi = 0.0.obs;
  final RxDouble rekomendasiHarga = 0.0.obs;
  final RxDouble totalModal = 0.0.obs;
  final RxBool hppSudahDihitung = false.obs;
  final RxBool hppDikonfirmasi = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool tidakAdaBahan = false.obs;

  // HPP & rekomendasi per mode
  final RxDouble hppLokal = 0.0.obs;
  final RxDouble rekomendasiLokal = 0.0.obs;
  final RxDouble modalLokal = 0.0.obs;

  final RxDouble hppPasar = 0.0.obs;
  final RxDouble rekomendasiPasar = 0.0.obs;
  final RxDouble modalPasar = 0.0.obs;

  // Mode aktif
  final Rx<SumberHarga> modeSumber = SumberHarga.lokal.obs;

  // Harga pasar yang diinput manual user: itemId → harga
  final RxMap<String, double> hargaPasarManual = <String, double>{}.obs;

  // Lokasi
  final RxString wilayah = 'Mendeteksi lokasi...'.obs;
  final RxString koordinat = ''.obs;
  final RxBool isLoadingLokasi = false.obs;

  // New Location override and Fallback states
  final RxBool isOverrideActive = false.obs;
  final RxString overrideKota = ''.obs;
  final RxBool isLocationFallbackActive = false.obs;
  final RxMap<String, String> sumberLevels = <String, String>{}.obs;

  late final overrideKotaController = TextEditingController();

  Map<String, double> _hargaWilayahAktif = {};

  String get namaKotaEfektif {
    if (isOverrideActive.value && overrideKota.value.isNotEmpty) {
      return overrideKota.value;
    }
    if (wilayah.value == 'Mendeteksi lokasi...' ||
        wilayah.value == 'Layanan GPS tidak aktif' ||
        wilayah.value == 'Izin lokasi ditolak' ||
        wilayah.value == 'Izin lokasi ditolak permanen' ||
        wilayah.value == 'Lokasi tidak terdeteksi') {
      return '';
    }
    return wilayah.value.split(',').first.trim();
  }

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
    return modalPasar.value > 0 ? modalPasar.value - modalLokal.value : 0;
  }

  // ── DETEKSI LOKASI ─────────────────────────────────────────────────────────
  void _showPermissionDialog() {
    Get.defaultDialog(
      title: "Izin Lokasi Diperlukan",
      middleText:
          "Aplikasi membutuhkan izin lokasi untuk menentukan harga lokal komoditas. Harap aktifkan izin lokasi di Pengaturan.",
      textConfirm: "Buka Pengaturan",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: AppColors.secondary,
      onConfirm: () async {
        Get.back();
        await openAppSettings();
      },
    );
  }

  Future<void> detectLokasi() async {
    isLoadingLokasi.value = true;
    isLocationFallbackActive.value = false;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        wilayah.value = 'Layanan GPS tidak aktif';
        koordinat.value = '';
        isLocationFallbackActive.value = true;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        _showPermissionDialog();
        wilayah.value = 'Izin lokasi ditolak permanen';
        koordinat.value = '';
        isLocationFallbackActive.value = true;
        return;
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          wilayah.value = 'Izin lokasi ditolak';
          koordinat.value = '';
          isLocationFallbackActive.value = true;
          return;
        }
        if (permission == LocationPermission.deniedForever) {
          _showPermissionDialog();
          wilayah.value = 'Izin lokasi ditolak permanen';
          koordinat.value = '';
          isLocationFallbackActive.value = true;
          return;
        }
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      koordinat.value =
          '${pos.latitude.toStringAsFixed(4)}° ${pos.latitude < 0 ? 'S' : 'N'}, '
          '${pos.longitude.toStringAsFixed(4)}° ${pos.longitude < 0 ? 'W' : 'E'}';

      try {
        final placemarks =
            await placemarkFromCoordinates(pos.latitude, pos.longitude)
                .timeout(const Duration(seconds: 5));
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          wilayah.value =
              '${p.subAdministrativeArea ?? p.locality ?? ''}, ${p.administrativeArea ?? ''}';
          isLocationFallbackActive.value = false;
        } else {
          isLocationFallbackActive.value = true;
          wilayah.value = 'Lokasi tidak terdeteksi';
        }
      } catch (e) {
        print('Reverse geocoding failed/timeout, falling back to national: $e');
        isLocationFallbackActive.value = true;
        wilayah.value = 'Lokasi tidak terdeteksi';
      }
    } catch (e) {
      print('detectLokasi error: $e');
      wilayah.value = 'Gagal deteksi lokasi';
      koordinat.value = '';
      isLocationFallbackActive.value = true;
    } finally {
      isLoadingLokasi.value = false;
    }
  }

  Future<double> fetchHargaLokasi(
      String kota, String komoditasName, String itemId) async {
    // 1. Coba cari di database Supabase 'local_prices' terlebih dahulu
    try {
      if (kota.isNotEmpty) {
        final dbRes = await _sb
            .from('local_prices')
            .select('price, tanggal')
            .eq('kota', kota)
            .eq('komoditas', komoditasName)
            .order('tanggal', ascending: false)
            .limit(1)
            .maybeSingle();

        if (dbRes != null && dbRes['price'] != null) {
          final harga = (dbRes['price'] as num).toDouble();
          sumberLevels[itemId] = 'lokal';
          return harga;
        }
      }
    } catch (e) {
      print('Error querying local_prices from Supabase for $komoditasName: $e');
    }

    // 2. Fallback ke API Python/Colab (PIHPS/BI Scraping) jika tidak ditemukan di Supabase
    try {
      final uri =
          Uri.parse('${DashboardController.baseUrl}/api/harga-lokasi').replace(
        queryParameters: {
          'kota': kota,
          'komoditas': komoditasName,
        },
      );
      final res = await http.get(uri, headers: {
        'ngrok-skip-browser-warning': 'true',
      }).timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        double harga = 0.0;
        String level = 'nasional';
        if (body is Map<String, dynamic>) {
          if (body['data'] is Map<String, dynamic>) {
            final data = body['data'] as Map<String, dynamic>;
            harga = (data['harga'] as num?)?.toDouble() ?? 0.0;
            level = data['sumber_level'] as String? ?? 'nasional';
          } else {
            harga = (body['harga'] as num?)?.toDouble() ?? 0.0;
            level = body['sumber_level'] as String? ?? 'nasional';
          }
        }
        sumberLevels[itemId] = level;
        if (harga <= 0) {
          harga = InventoryController.to.hargaNasional(itemId);
          sumberLevels[itemId] = 'nasional';
        }
        return harga;
      }
    } catch (e) {
      print('Error fetching local price for $komoditasName: $e');
    }
    // Fallback to national price
    sumberLevels[itemId] = 'nasional';
    return InventoryController.to.hargaNasional(itemId);
  }

  // ── HITUNG HPP LOKAL (dari harga wilayah 85%) ──────────────────────────────
  Future<void> hitungHPP({
    required Map<String, double> hargaWilayah,
    int? porsiTarget,
  }) async {
    final menu = activeMenu;
    if (menu == null || menu.ingredients.isEmpty) {
      tidakAdaBahan.value = true;
      hppSudahDihitung.value = false;
      isLoading.value = false;
      return;
    }

    tidakAdaBahan.value = false;
    _hargaWilayahAktif = hargaWilayah;
    final porsi = porsiTarget ?? menu.targetPorsi;
    isLoading.value = true;

    double modal = 0;
    for (final ing in menu.ingredients) {
      final harga = hargaWilayah[ing.inventoryItemId] ??
          InventoryController.to.hargaNasional(ing.inventoryItemId);
      modal += harga * ing.qtyNeeded * porsi;
    }

    final hpp = porsi > 0 ? modal / porsi : 0.0;
    final rekomendasi = _bulatkanRibu(hpp * 1.4);

    modalLokal.value = modal;
    hppLokal.value = hpp;
    rekomendasiLokal.value = rekomendasi;

    // Set aktif jika mode lokal
    if (modeSumber.value == SumberHarga.lokal) {
      totalModal.value = modal;
      hppPerPorsi.value = hpp;
      rekomendasiHarga.value = rekomendasi;
    }

    hppSudahDihitung.value = true;
    hppDikonfirmasi.value = false;

    if (!Get.testMode) {
      try {
        await _sb.from('hpp_results').insert({
          'menu_id': menu.id,
          'hpp_per_porsi': hpp,
          'rekomendasi_harga': rekomendasi,
          'total_modal': modal,
        });
      } catch (e) {
        print('Error saving HPP: $e');
      }
    }

    await BestMenuController.to.refreshMenuHpp(
      menuId: menu.id,
      hpp: hpp,
      rekomendasi: rekomendasi,
      modal: modal,
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

    final hpp = porsi > 0 ? modal / porsi : 0.0;
    final rekomendasi = _bulatkanRibu(hpp * 1.4);

    modalPasar.value = modal;
    hppPasar.value = hpp;
    rekomendasiPasar.value = rekomendasi;

    // Update aktif jika mode pasar
    if (modeSumber.value == SumberHarga.pasar) {
      totalModal.value = modal;
      hppPerPorsi.value = hpp;
      rekomendasiHarga.value = rekomendasi;
    }

    hppSudahDihitung.value = true;
    isLoading.value = false;
  }

  // ── GANTI MODE ─────────────────────────────────────────────────────────────
  void gantiMode(SumberHarga mode) {
    modeSumber.value = mode;
    if (mode == SumberHarga.lokal && hppLokal.value > 0) {
      totalModal.value = modalLokal.value;
      hppPerPorsi.value = hppLokal.value;
      rekomendasiHarga.value = rekomendasiLokal.value;
    } else if (mode == SumberHarga.pasar && hppPasar.value > 0) {
      totalModal.value = modalPasar.value;
      hppPerPorsi.value = hppPasar.value;
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
    hppPerPorsi.value = 0;
    rekomendasiHarga.value = 0;
    totalModal.value = 0;
    hppSudahDihitung.value = false;
    hppDikonfirmasi.value = false;
    tidakAdaBahan.value = false;
    hppLokal.value = 0;
    rekomendasiLokal.value = 0;
    modalLokal.value = 0;
    hppPasar.value = 0;
    rekomendasiPasar.value = 0;
    modalPasar.value = 0;
    modeSumber.value = SumberHarga.lokal;
    hargaPasarManual.clear();
    _hargaWilayahAktif = {};
  }

  // ── HELPER ─────────────────────────────────────────────────────────────────
  double _bulatkanRibu(double v) => (v / 1000).ceil() * 1000.0;

  double hargaEfektif(String itemId) =>
      _hargaWilayahAktif[itemId] ??
      InventoryController.to.hargaNasional(itemId);

  @override
  void onInit() {
    super.onInit();
    if (Get.testMode) {
      wilayah.value = 'Kota Tegal, Jawa Tengah';
      return;
    }
    detectLokasi();
    // Sync controller with overrideKota state
    overrideKotaController.text = overrideKota.value;
    overrideKota.listen((val) {
      if (overrideKotaController.text != val) {
        overrideKotaController.text = val;
      }
    });
  }

  @override
  void onClose() {
    overrideKotaController.dispose();
    super.onClose();
  }
}
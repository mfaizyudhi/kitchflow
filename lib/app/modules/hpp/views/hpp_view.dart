// hpp_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../routes/app_pages.dart';
import '../../hpp/controllers/hpp_controller.dart';
import '../../best_menu/controllers/best_menu_controller.dart';
import '../../inventory/controllers/inventory_controller.dart';

class HppView extends StatefulWidget {
  const HppView({super.key});

  @override
  State<HppView> createState() => _HppViewState();
}

class _HppViewState extends State<HppView> {
  bool _hargaLoaded = false;
  Map<String, double> _hargaWilayah = {};
  final Map<String, bool> _itemLoaded = {};
  final Map<String, TextEditingController> _hargaPasarControllers = {};

  @override
  void dispose() {
    for (final c in _hargaPasarControllers.values) c.dispose();
    super.dispose();
  }

  Set<String> _bahanIds(BestMenuController menuCtrl) {
    final m = menuCtrl.activeMenu.value;
    if (m == null) return {};
    return m.ingredients.map((b) => b.inventoryItemId).toSet();
  }

  Future<void> _loadHargaWilayah() async {
    final invCtrl = InventoryController.to;
    final hppCtrl = HppController.to;
    final menuCtrl = BestMenuController.to;

    final bahanIds = _bahanIds(menuCtrl);
    if (bahanIds.isEmpty) {
      Get.snackbar("Bahan Kosong",
          "Menu belum memiliki bahan. Tambahkan bahan terlebih dahulu.",
          backgroundColor: AppColors.card, colorText: Colors.white);
      return;
    }

    final items = invCtrl.items.where((i) => bahanIds.contains(i.id)).toList();

    setState(() {
      _hargaLoaded = false;
      _itemLoaded.clear();
    });

    final Map<String, double> hasil = {};
    for (final item in items) {
      await Future.delayed(const Duration(milliseconds: 400));
      hasil[item.id] = item.pricePerUnit * 0.85;
      setState(() => _itemLoaded[item.id] = true);
    }

    _hargaWilayah = hasil;
    await hppCtrl.hitungHPP(hargaWilayah: hasil);

    setState(() => _hargaLoaded = true);
  }

  Future<void> _hitungHargaPasar() async {
    final hppCtrl = HppController.to;
    // Simpan semua harga pasar dari controller input
    for (final entry in _hargaPasarControllers.entries) {
      final val = double.tryParse(entry.value.text);
      if (val != null && val > 0) {
        hppCtrl.setHargaPasar(entry.key, val);
      }
    }
    await hppCtrl.hitungHPPPasar();
  }

  @override
  Widget build(BuildContext context) {
    final hppCtrl = HppController.to;
    final menuCtrl = BestMenuController.to;
    final invCtrl = InventoryController.to;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
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
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 18),
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
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                TextSpan(
                                  text: "HPP",
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ]),
                            ),
                            const Text(
                              "Harga berbasis lokasi & harga pasar",
                              style: TextStyle(
                                  color: AppColors.textSecondary, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── LOKASI GPS REALTIME ──────────────────────────
                  Obx(() {
                    final isLoading = hppCtrl.isLoadingLokasi.value;
                    final wilayah = hppCtrl.wilayah.value;
                    final koordinat = hppCtrl.koordinat.value;

                    return Container(
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
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.location_on_rounded,
                                    color: AppColors.secondary, size: 18),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Lokasi Warteg",
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 11)),
                                    Text(
                                      isLoading
                                          ? "Mendeteksi..."
                                          : wilayah,
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
                                onTap: hppCtrl.detectLokasi,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColors.secondary
                                            .withOpacity(0.3)),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            color: AppColors.secondary,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.my_location_rounded,
                                          color: AppColors.secondary, size: 16),
                                ),
                              ),
                            ],
                          ),
                          if (koordinat.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.gps_fixed_rounded,
                                    color: Colors.green, size: 12),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(koordinat,
                                      style: const TextStyle(
                                          color: Colors.white38, fontSize: 11),
                                      overflow: TextOverflow.ellipsis),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text("GPS Aktif",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 14),
                          // TOMBOL AMBIL HARGA LOKAL
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
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _hargaLoaded
                                          ? Icons.check_circle_rounded
                                          : Icons.public_rounded,
                                      color: _hargaLoaded
                                          ? Colors.green
                                          : Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _hargaLoaded
                                          ? "Harga Lokal ${wilayah.split(',').first} Dimuat"
                                          : "Ambil Harga Bahan dari Wilayah",
                                      style: TextStyle(
                                        color: _hargaLoaded
                                            ? Colors.green
                                            : Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 20),

                  // ── MENU AKTIF ────────────────────────────────────
                  Obx(() {
                    final m = menuCtrl.activeMenu.value;
                    if (m == null) return const SizedBox.shrink();

                    return Container(
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
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              m.imagePath,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.fastfood_rounded,
                                    color: AppColors.primary, size: 28),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    )),
                                const SizedBox(height: 4),
                                Text(
                                  "${m.ingredients.length} bahan • Target ${m.targetPorsi} porsi",
                                  style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Harga jual: Rp ${_fmt(m.hargaJual.toInt())}",
                                  style: const TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),

                  // ── TOGGLE MODE SUMBER HARGA ─────────────────────
                  Obx(() {
                    final mode = hppCtrl.modeSumber.value;
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => hppCtrl.gantiMode(SumberHarga.lokal),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  gradient: mode == SumberHarga.lokal
                                      ? AppColors.brandGradient
                                      : null,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.public_rounded,
                                        color: mode == SumberHarga.lokal
                                            ? Colors.white
                                            : Colors.white38,
                                        size: 18),
                                    const SizedBox(height: 4),
                                    Text("Harga Lokal",
                                        style: TextStyle(
                                          color: mode == SumberHarga.lokal
                                              ? Colors.white
                                              : Colors.white38,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Text("(dari website nasional)",
                                        style: TextStyle(
                                          color: mode == SumberHarga.lokal
                                              ? Colors.white70
                                              : Colors.white24,
                                          fontSize: 9,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => hppCtrl.gantiMode(SumberHarga.pasar),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  gradient: mode == SumberHarga.pasar
                                      ? const LinearGradient(colors: [
                                          Color(0xFF2E7D32),
                                          Color(0xFF1B5E20),
                                        ])
                                      : null,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.store_rounded,
                                        color: mode == SumberHarga.pasar
                                            ? Colors.white
                                            : Colors.white38,
                                        size: 18),
                                    const SizedBox(height: 4),
                                    Text("Harga Pasar",
                                        style: TextStyle(
                                          color: mode == SumberHarga.pasar
                                              ? Colors.white
                                              : Colors.white38,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Text("(harga beli kamu)",
                                        style: TextStyle(
                                          color: mode == SumberHarga.pasar
                                              ? Colors.white70
                                              : Colors.white24,
                                          fontSize: 9,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 20),

                  // ── KOMPOSISI BAHAN ──────────────────────────────
                  Obx(() {
                    final m = menuCtrl.activeMenu.value;
                    final bahanIds = _bahanIds(menuCtrl);
                    final items = invCtrl.items
                        .where((i) => bahanIds.contains(i.id))
                        .toList();
                    final mode = hppCtrl.modeSumber.value;

                    if (m == null) return const SizedBox.shrink();

                    // Inisialisasi controller input harga pasar
                    for (final item in items) {
                      _hargaPasarControllers.putIfAbsent(
                        item.id,
                        () => TextEditingController(
                            text: hppCtrl.hargaPasarManual[item.id]
                                    ?.toStringAsFixed(0) ??
                                item.pricePerUnit.toStringAsFixed(0)),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Komposisi Bahan",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: AppColors.primary.withOpacity(0.2)),
                              ),
                              child: Text("${items.length} bahan",
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        if (items.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.orange.withOpacity(0.2)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded,
                                    color: Colors.orange, size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Bahan \"${m.name}\" belum ada di inventory. Tambahkan bahan terlebih dahulu.",
                                    style: const TextStyle(
                                        color: Colors.white60, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ...items.map((item) {
                            final ing = m.ingredients.firstWhereOrNull(
                                (i) => i.inventoryItemId == item.id);
                            final qtyNeeded = (ing?.qtyNeeded ?? 1) * m.targetPorsi;
                            final isLoaded = _itemLoaded[item.id] == true;

                            // Harga yang ditampilkan sesuai mode
                            final hargaLokal =
                                _hargaWilayah[item.id] ?? item.pricePerUnit;
                            final hargaPasar =
                                hppCtrl.hargaPasarManual[item.id] ??
                                    item.pricePerUnit;
                            final hargaAktif = mode == SumberHarga.lokal
                                ? hargaLokal
                                : hargaPasar;
                            final totalHarga = hargaAktif * qtyNeeded;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isLoaded && mode == SumberHarga.lokal
                                      ? Colors.green.withOpacity(0.2)
                                      : mode == SumberHarga.pasar
                                          ? Colors.orange.withOpacity(0.2)
                                          : Colors.white10,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                            Icons.lunch_dining_rounded,
                                            color: AppColors.primary,
                                            size: 16),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(item.name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                )),
                                            Text(
                                              "Kebutuhan: ${qtyNeeded % 1 == 0 ? qtyNeeded.toInt() : qtyNeeded} ${item.unit} • Stok: ${item.stockLabel}",
                                              style: const TextStyle(
                                                  color: AppColors
                                                      .textSecondary,
                                                  fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Rp ${_fmt(totalHarga.toInt())}",
                                            style: TextStyle(
                                              color: mode == SumberHarga.lokal
                                                  ? Colors.green
                                                  : Colors.orange,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            "@ Rp ${_fmt(hargaAktif.toInt())}/${item.unit}",
                                            style: const TextStyle(
                                                color: Colors.white38,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Perbandingan harga lokal vs nasional (mode lokal)
                                  if (mode == SumberHarga.lokal && isLoaded) ...[
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.06),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Nasional: Rp ${_fmt(item.pricePerUnit.toInt())}",
                                            style: const TextStyle(
                                              color: Colors.white38,
                                              fontSize: 10,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              decorationColor: Colors.white38,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          const Icon(Icons.arrow_forward_rounded,
                                              color: Colors.green, size: 10),
                                          const SizedBox(width: 6),
                                          Text(
                                            "Lokal: Rp ${_fmt(hargaLokal.toInt())}",
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.green
                                                  .withOpacity(0.12),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              "Hemat ${_fmt((item.pricePerUnit - hargaLokal).toInt())}",
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  // Input harga pasar manual
                                  if (mode == SumberHarga.pasar) ...[
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.store_rounded,
                                            color: Colors.orange, size: 14),
                                        const SizedBox(width: 6),
                                        const Text("Harga beli di pasar:",
                                            style: TextStyle(
                                                color: Colors.white60,
                                                fontSize: 11)),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: TextField(
                                            controller:
                                                _hargaPasarControllers[item.id],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                            keyboardType:
                                                TextInputType.number,
                                            decoration: InputDecoration(
                                              hintText: "Rp / ${item.unit}",
                                              hintStyle: const TextStyle(
                                                  color: AppColors.textHint,
                                                  fontSize: 11),
                                              prefixText: "Rp ",
                                              prefixStyle: const TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 13),
                                              filled: true,
                                              fillColor:
                                                  const Color(0xFF0F172A),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Colors.orange,
                                                    width: 1.5),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }),
                      ],
                    );
                  }),

                  // ── TOMBOL HITUNG HARGA PASAR (dipindahkan ke sini) ──
                  Obx(() {
                    if (hppCtrl.modeSumber.value != SumberHarga.pasar)
                      return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: GestureDetector(
                        onTap: _hitungHargaPasar,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              Color(0xFF2E7D32),
                              Color(0xFF1B5E20),
                            ]),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calculate_rounded,
                                  color: Colors.white, size: 18),
                              SizedBox(width: 8),
                              Text("Hitung HPP Harga Pasar",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),

                  // ── PENGHEMATAN ─────────────────────────────
                  if (_hargaLoaded) ...[
                    Obx(() {
                      if (hppCtrl.modeSumber.value != SumberHarga.lokal)
                        return const SizedBox.shrink();
                      final selisih = hppCtrl.selisihHarga;
                      if (selisih <= 0) return const SizedBox.shrink();

                      return Column(
                        children: [
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
                                  child: const Icon(Icons.savings_rounded,
                                      color: Colors.green, size: 20),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Penghematan Harga Lokal",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          )),
                                      const SizedBox(height: 4),
                                      Obx(() => Text(
                                            "vs harga nasional di ${hppCtrl.wilayah.value.split(',').first}:",
                                            style: const TextStyle(
                                              color: Colors.white54,
                                              fontSize: 11,
                                              height: 1.4,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "- Rp ${_fmt(selisih.toInt())}",
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
                      );
                    }),
                  ],

                  // ── HASIL HPP ─────────────────────────────────────
                  Obx(() {
                    final mode = hppCtrl.modeSumber.value;
                    final isLoading = hppCtrl.isLoading.value;
                    final sudahDihitung = hppCtrl.hppSudahDihitung.value;
                    final tidakAdaBahan = hppCtrl.tidakAdaBahan.value;

                    final totalModal = mode == SumberHarga.lokal
                        ? hppCtrl.modalLokal.value
                        : hppCtrl.modalPasar.value;
                    final hpp = mode == SumberHarga.lokal
                        ? hppCtrl.hppLokal.value
                        : hppCtrl.hppPasar.value;
                    final rekomendasi = mode == SumberHarga.lokal
                        ? hppCtrl.rekomendasiLokal.value
                        : hppCtrl.rekomendasiPasar.value;
                    final profit = mode == SumberHarga.lokal
                        ? hppCtrl.estimasiProfitLokal
                        : hppCtrl.estimasiProfitPasar;

                    final modeLabel = mode == SumberHarga.lokal
                        ? "Harga Lokal ${hppCtrl.wilayah.value.split(',').first}"
                        : "Harga Pasar (input manual)";
                    final modeColor = mode == SumberHarga.lokal
                        ? Colors.green
                        : Colors.orange;

                    return GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: modeColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  mode == SumberHarga.lokal
                                      ? Icons.public_rounded
                                      : Icons.store_rounded,
                                  color: modeColor,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Hasil Analisis HPP",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        )),
                                    Text(modeLabel,
                                        style: TextStyle(
                                            color: modeColor.withOpacity(0.8),
                                            fontSize: 10),
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: modeColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: modeColor.withOpacity(0.3)),
                                ),
                                child: Text(
                                  mode == SumberHarga.lokal
                                      ? "Harga Lokal"
                                      : "Harga Pasar",
                                  style: TextStyle(
                                    color: modeColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(color: Colors.white10),
                          const SizedBox(height: 16),

                          if (isLoading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: CircularProgressIndicator(
                                    color: AppColors.secondary, strokeWidth: 2),
                              ),
                            )
                          else if (tidakAdaBahan)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  "Menu belum punya bahan baku.\nTambahkan bahan terlebih dahulu.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white38,
                                      fontSize: 13,
                                      height: 1.5),
                                ),
                              ),
                            )
                          else if (!sudahDihitung)
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  mode == SumberHarga.lokal
                                      ? "Tap 'Ambil Harga Bahan dari Wilayah'\nuntuk menghitung HPP"
                                      : "Isi harga beli di pasar lalu tap\n'Hitung HPP Harga Pasar'",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 13,
                                      height: 1.5),
                                ),
                              ),
                            )
                          else ...[
                            _buildResultRow(
                              "Total Modal (${menuCtrl.activeMenu.value?.targetPorsi ?? 0} porsi)",
                              "Rp ${_fmt(totalModal.toInt())}",
                              Colors.white70,
                              AppColors.textSecondary,
                            ),
                            const SizedBox(height: 14),
                            _buildResultRow(
                              "HPP per Porsi",
                              "Rp ${_fmt(hpp.toInt())}",
                              Colors.white70,
                              AppColors.secondary,
                            ),
                            const SizedBox(height: 14),
                            const Divider(color: Colors.white10),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Rekomendasi Harga Jual",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          )),
                                      Text(
                                        "HPP × 1.4 — margin 29% (${mode == SumberHarga.lokal ? 'harga lokal' : 'harga pasar'})",
                                        style: const TextStyle(
                                            color: Colors.white38,
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "Rp ${_fmt(rekomendasi.toInt())}",
                                  style: TextStyle(
                                    color: modeColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Perbandingan 2 mode jika keduanya sudah dihitung
                            if (hppCtrl.hppLokal.value > 0 &&
                                hppCtrl.hppPasar.value > 0) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.04),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Column(
                                  children: [
                                    const Text("Perbandingan HPP",
                                        style: TextStyle(
                                            color: Colors.white60,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _compareCard(
                                            "Harga Lokal",
                                            hppCtrl.hppLokal.value,
                                            hppCtrl.rekomendasiLokal.value,
                                            Colors.green,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: _compareCard(
                                            "Harga Pasar",
                                            hppCtrl.hppPasar.value,
                                            hppCtrl.rekomendasiPasar.value,
                                            Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: modeColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: modeColor.withOpacity(0.2)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: modeColor.withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Icon(Icons.trending_up_rounded,
                                            color: modeColor, size: 14),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text("Estimasi Profit",
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14)),
                                    ],
                                  ),
                                  Text(
                                    "Rp ${_fmt(profit.toInt())}",
                                    style: TextStyle(
                                      color: modeColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),

                  // ── CATATAN ──────────────────────────────────────
                  Obx(() {
                    final rekomendasi = hppCtrl.rekomendasiHarga.value;
                    final hpp = hppCtrl.hppPerPorsi.value;
                    final mode = hppCtrl.modeSumber.value;
                    final margin = rekomendasi > 0
                        ? ((rekomendasi - hpp) / rekomendasi * 100)
                            .toStringAsFixed(0)
                        : '0';

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppColors.secondary.withOpacity(0.2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lightbulb_outline_rounded,
                              color: AppColors.secondary, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              rekomendasi > 0
                                  ? "Rekomendasi harga jual Rp ${_fmt(rekomendasi.toInt())} (margin $margin%) berdasarkan ${mode == SumberHarga.lokal ? 'harga bahan lokal ${hppCtrl.wilayah.value.split(',').first}' : 'harga beli pasar Anda'}."
                                  : "Ambil harga bahan dari wilayah atau isi harga pasar untuk mendapatkan rekomendasi harga jual.",
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),

                  // ── TOMBOL LANJUT PRODUKSI ───────────────────────
                  Obx(() {
                    final sudah = hppCtrl.hppSudahDihitung.value;
                    return Container(
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                        gradient: sudah
                            ? AppColors.brandGradient
                            : const LinearGradient(
                                colors: [Colors.white12, Colors.white12]),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: sudah
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
                          onTap: sudah
                              ? () {
                                  hppCtrl.confirmHPP();
                                  Get.toNamed(Routes.PRODUCTION);
                                }
                              : null,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.restaurant_rounded,
                                    color: sudah ? Colors.white : Colors.white38,
                                    size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  sudah
                                      ? "Lanjut ke Produksi"
                                      : "Hitung HPP Terlebih Dahulu",
                                  style: TextStyle(
                                    color: sudah ? Colors.white : Colors.white38,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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

  Widget _compareCard(String label, double hpp, double rekomendasi, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("HPP: Rp ${_fmt(hpp.toInt())}",
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
          Text("Jual: Rp ${_fmt(rekomendasi.toInt())}",
              style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
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
          child: Text(title,
              style: TextStyle(
                color: titleColor,
                fontSize: isBold ? 14 : 13,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              )),
        ),
        const SizedBox(width: 12),
        Text(value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: isBold ? 16 : 14,
            )),
      ],
    );
  }

  String _fmt(int v) {
    final s = v.toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return b.toString();
  }
}
// modules/dashboard/views/menu_terlaris_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_pages.dart';

class BestMenuView extends StatefulWidget {
  const BestMenuView({super.key});

  @override
  State<BestMenuView> createState() => _BestMenuViewState();
}

class _BestMenuViewState extends State<BestMenuView> {
  int _selectedFilter = 0;
  final List<String> _filters = ["Semua", "Terlaris", "Profit Tinggi", "Baru"];

  // Simulasi stok dari inventory
  final List<Map<String, dynamic>> _stokInventory = [
    {"nama": "Ayam Broiler",  "stok": "2.5 Kg",  "satuan": "Kg"},
    {"nama": "Telur Ayam",    "stok": "8 Kg",    "satuan": "Kg"},
    {"nama": "Tempe",         "stok": "24 Kg",   "satuan": "Kg"},
    {"nama": "Cabe Merah",    "stok": "12 Kg",   "satuan": "Kg"},
    {"nama": "Bawang Putih",  "stok": "5 Kg",    "satuan": "Kg"},
    {"nama": "Kubis",         "stok": "10 Kg",   "satuan": "Kg"},
    {"nama": "Minyak Goreng", "stok": "5 Liter", "satuan": "Liter"},
    {"nama": "Beras Putih",   "stok": "50 Kg",   "satuan": "Kg"},
    {"nama": "Tomat",         "stok": "3 Kg",    "satuan": "Kg"},
    {"nama": "Santan",        "stok": "4 Liter", "satuan": "Liter"},
    {"nama": "Jahe",          "stok": "1 Kg",    "satuan": "Kg"},
    {"nama": "Bawang Merah",  "stok": "4 Kg",    "satuan": "Kg"},
  ];

  final List<Map<String, dynamic>> _menuList = [
    {
      "name":       "Ayam Goreng",
      "image":      "assets/images/ayamgoreng.jpg",
      "porsi":      84,
      "profit":     "Rp 350.000",
      "harga":      "Rp 15.000",
      "modal":      "Rp 119.000",
      "level":      "Best Seller",
      "levelColor": Colors.orange,
      "bahan":      ["Ayam Broiler", "Minyak Goreng", "Bawang Putih", "Jahe"],
      "rank":       1,
    },
    {
      "name":       "Telor Balado",
      "image":      "assets/images/telorbalado.jpg",
      "porsi":      62,
      "profit":     "Rp 280.000",
      "harga":      "Rp 12.000",
      "modal":      "Rp 85.000",
      "level":      "Tinggi",
      "levelColor": Colors.green,
      "bahan":      ["Telur Ayam", "Cabe Merah", "Bawang Putih", "Tomat"],
      "rank":       2,
    },
    {
      "name":       "Orek Tempe",
      "image":      "assets/images/tempeorek.jpg",
      "porsi":      55,
      "profit":     "Rp 210.000",
      "harga":      "Rp 10.000",
      "modal":      "Rp 65.000",
      "level":      "Populer",
      "levelColor": AppColors.secondary,
      "bahan":      ["Tempe", "Cabe Merah", "Bawang Putih", "Minyak Goreng"],
      "rank":       3,
    },
    {
      "name":       "Sayur Lodeh",
      "image":      "assets/images/sayurlodeh.jpg",
      "porsi":      48,
      "profit":     "Rp 190.000",
      "harga":      "Rp 8.000",
      "modal":      "Rp 55.000",
      "level":      "Populer",
      "levelColor": AppColors.secondary,
      "bahan":      ["Kubis", "Santan", "Tempe", "Bawang Putih"],
      "rank":       4,
    },
    {
      "name":       "Ayam Balado",
      "image":      "assets/images/ayambalado.jpg",
      "porsi":      40,
      "profit":     "Rp 320.000",
      "harga":      "Rp 20.000",
      "modal":      "Rp 145.000",
      "level":      "Profit Tinggi",
      "levelColor": Colors.purple,
      "bahan":      ["Ayam Broiler", "Cabe Merah", "Bawang Merah", "Tomat"],
      "rank":       5,
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_selectedFilter == 0) return _menuList;
    if (_selectedFilter == 1) {
      return [..._menuList]
        ..sort((a, b) => (b["porsi"] as int).compareTo(a["porsi"] as int));
    }
    if (_selectedFilter == 2) {
      return _menuList
          .where((m) =>
              m["level"] == "Profit Tinggi" || m["level"] == "Best Seller")
          .toList();
    }
    return _menuList.reversed.toList();
  }

  void _showTambahMenuDialog() {
    final namaController  = TextEditingController();
    final hargaController = TextEditingController();
    final porsiController = TextEditingController();
    List<String> selectedBahan = [];

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
            left: 24, right: 24, top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // HANDLE
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // JUDUL
                RichText(
                  text: const TextSpan(children: [
                    TextSpan(
                      text: "Tambah ",
                      style: TextStyle(
                        color: Colors.white, fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "Menu",
                      style: TextStyle(
                        color: AppColors.secondary, fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ),
                const Text(
                  "Isi detail menu yang akan diproduksi",
                  style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 12,
                  ),
                ),

                const SizedBox(height: 20),

                // NAMA MENU
                _modalField(
                  label: "Nama Menu",
                  hint: "Contoh: Ayam Goreng",
                  controller: namaController,
                  icon: Icons.restaurant_rounded,
                ),

                const SizedBox(height: 14),

                // HARGA JUAL + TARGET PORSI
                Row(
                  children: [
                    Expanded(
                      child: _modalField(
                        label: "Harga Jual (Rp)",
                        hint: "15000",
                        controller: hargaController,
                        icon: Icons.sell_rounded,
                        isNumber: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _modalField(
                        label: "Target Porsi",
                        hint: "50",
                        controller: porsiController,
                        icon: Icons.dinner_dining_rounded,
                        isNumber: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // BAHAN DARI INVENTORY
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.secondary, size: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Pilih Bahan dari Inventory",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (selectedBahan.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${selectedBahan.length} dipilih",
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                // LIST BAHAN DARI INVENTORY
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    children: List.generate(
                      _stokInventory.length,
                      (i) {
                        final bahan = _stokInventory[i];
                        final isSelected =
                            selectedBahan.contains(bahan["nama"]);

                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              if (isSelected) {
                                selectedBahan.remove(bahan["nama"]);
                              } else {
                                selectedBahan.add(bahan["nama"]);
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.08)
                                  : Colors.transparent,
                              border: i < _stokInventory.length - 1
                                  ? const Border(
                                      bottom: BorderSide(
                                          color: Colors.white10))
                                  : null,
                              borderRadius: i == 0
                                  ? const BorderRadius.vertical(
                                      top: Radius.circular(16))
                                  : i == _stokInventory.length - 1
                                      ? const BorderRadius.vertical(
                                          bottom: Radius.circular(16))
                                      : null,
                            ),
                            child: Row(
                              children: [

                                // CHECKBOX
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? AppColors.brandGradient
                                        : null,
                                    color: isSelected
                                        ? null
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.transparent
                                          : Colors.white24,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 14,
                                        )
                                      : null,
                                ),

                                const SizedBox(width: 12),

                                // INFO BAHAN
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bahan["nama"],
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.white70,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        "Stok: ${bahan["stok"]}",
                                        style: TextStyle(
                                          color: isSelected
                                              ? AppColors.secondary
                                              : Colors.white38,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // SATUAN BADGE
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary.withOpacity(0.15)
                                        : Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    bahan["satuan"],
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.white38,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // PREVIEW BAHAN TERPILIH
                if (selectedBahan.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.secondary.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Bahan Terpilih:",
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: selectedBahan
                              .map((b) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary
                                          .withOpacity(0.12),
                                      borderRadius:
                                          BorderRadius.circular(8),
                                      border: Border.all(
                                          color: AppColors.primary
                                              .withOpacity(0.25)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          b,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        GestureDetector(
                                          onTap: () => setModalState(() =>
                                              selectedBahan.remove(b)),
                                          child: const Icon(
                                            Icons.close_rounded,
                                            color: Colors.white38,
                                            size: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // TOMBOL SIMPAN
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
                      onTap: () {
                        if (namaController.text.isEmpty ||
                            hargaController.text.isEmpty) {
                          Get.snackbar(
                            "Perhatian",
                            "Nama menu dan harga jual wajib diisi",
                            backgroundColor: Colors.orange.withOpacity(0.8),
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                          );
                          return;
                        }

                        final porsi = int.tryParse(porsiController.text) ?? 0;
                        final hargaInt = int.tryParse(hargaController.text) ?? 0;
                        final profit = porsi > 0
                            ? "Rp ${(porsi * hargaInt * 0.4).toInt()}"
                            : "Rp 0";

                        setState(() {
                          _menuList.add({
                            "name":       namaController.text,
                            "image":      "assets/images/food_ai.jpg",
                            "porsi":      porsi,
                            "profit":     profit,
                            "harga":      "Rp ${hargaController.text}",
                            "modal":      "Rp 0",
                            "level":      "Populer",
                            "levelColor": AppColors.secondary,
                            "bahan":      List<String>.from(selectedBahan),
                            "rank":       _menuList.length + 1,
                          });
                        });

                        Get.back();
                        Get.snackbar(
                          "Berhasil! 🎉",
                          "${namaController.text} berhasil ditambahkan",
                          backgroundColor: Colors.green.withOpacity(0.85),
                          colorText: Colors.white,
                          snackPosition: SnackPosition.TOP,
                        );
                      },
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_rounded,
                                color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "Simpan Menu",
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

  Color _getLevelColor(String level) {
    switch (level) {
      case "Best Seller":   return Colors.orange;
      case "Profit Tinggi": return Colors.purple;
      case "Terlaris":      return Colors.red;
      case "Tinggi":        return Colors.green;
      case "Baru":          return AppColors.primary;
      default:              return AppColors.secondary;
    }
  }

  Widget _modalField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70, fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
                color: AppColors.textHint, fontSize: 13),
            prefixIcon: Icon(icon,
                color: AppColors.textSecondary, size: 18),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [

          // GLOW
          Positioned(
            top: -80, right: -60,
            child: Container(
              width: 220, height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withOpacity(0.18),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── HEADER ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
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
                            color: Colors.white, size: 18,
                          ),
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
                                  text: "List ",
                                  style: TextStyle(
                                    color: Colors.white, fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                TextSpan(
                                  text: "Menu",
                                  style: TextStyle(
                                    color: AppColors.secondary, fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ]),
                            ),
                            const Text(
                              "Analisis menu terlaris & profit",
                              style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // BADGE JUMLAH MENU
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Text(
                          "${_menuList.length} Menu",
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // TOMBOL TAMBAH
                      GestureDetector(
                        onTap: _showTambahMenuDialog,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: AppColors.brandGradient,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: Colors.white, size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── FILTER ──────────────────────────────────────
                SizedBox(
                  height: 42,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filters.length,
                    itemBuilder: (context, i) {
                      final isActive = _selectedFilter == i;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedFilter = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: isActive
                                ? AppColors.brandGradient
                                : null,
                            color: isActive ? null : AppColors.card,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: isActive
                                  ? Colors.transparent
                                  : Colors.white12,
                            ),
                            boxShadow: isActive
                                ? [BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 10,
                                  )]
                                : [],
                          ),
                          child: Text(
                            _filters[i],
                            style: TextStyle(
                              color: isActive
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              fontSize: 13,
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // ── LIST MENU ────────────────────────────────────
                Expanded(
                  child: _filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.restaurant_menu_rounded,
                                  color: Colors.white12, size: 60),
                              const SizedBox(height: 16),
                              const Text(
                                "Belum ada menu",
                                style: TextStyle(
                                  color: Colors.white38, fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Tap tombol + untuk menambahkan menu",
                                style: TextStyle(
                                  color: Colors.white24, fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _filtered.length,
                          itemBuilder: (context, i) =>
                              _menuCard(_filtered[i], i),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuCard(Map<String, dynamic> menu, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // IMAGE + BADGES
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24)),
                child: Image.asset(
                  menu["image"],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // GRADIENT OVERLAY
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.card.withOpacity(0.95),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // RANK BADGE
              Positioned(
                top: 14, left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: AppColors.brandGradient,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Text(
                    "TOP ${menu["rank"]}",
                    style: const TextStyle(
                      color: Colors.white, fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // LEVEL BADGE
              Positioned(
                top: 14, right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: (menu["levelColor"] as Color).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: (menu["levelColor"] as Color).withOpacity(0.4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Text(
                    menu["level"],
                    style: const TextStyle(
                      color: Colors.white, fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // DELETE BUTTON
              Positioned(
                bottom: 14, right: 14,
                child: GestureDetector(
                  onTap: () {
                    setState(() => _menuList.removeWhere(
                        (m) => m["name"] == menu["name"]));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.redAccent, size: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // CONTENT
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // NAMA + PROFIT
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      menu["name"],
                      style: const TextStyle(
                        color: Colors.white, fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      menu["profit"],
                      style: const TextStyle(
                        color: Colors.green, fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // INFO CHIPS
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _infoChip(
                      Icons.sell_rounded,
                      "Jual ${menu["harga"]}",
                      Colors.green,
                    ),
                    _infoChip(
                      Icons.shopping_bag_rounded,
                      "${menu["porsi"]} Porsi",
                      Colors.orange,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // BAHAN TAGS
                if ((menu["bahan"] as List).isNotEmpty) ...[
                  const Text(
                    "Bahan:",
                    style: TextStyle(
                      color: Colors.white38, fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: (menu["bahan"] as List).map((bahan) =>
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Text(
                          bahan.toString(),
                          style: const TextStyle(
                            color: Colors.white54, fontSize: 11,
                          ),
                        ),
                      )
                    ).toList(),
                  ),
                ],

                const SizedBox(height: 16),

                // TOMBOL ACTION
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Get.toNamed(Routes.HPP),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppColors.primary.withOpacity(0.4)),
                          ),
                          child: const Center(
                            child: Text(
                              "Hitung HPP",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Get.toNamed(Routes.PRODUCTION),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: AppColors.brandGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "Produksi",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color, fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
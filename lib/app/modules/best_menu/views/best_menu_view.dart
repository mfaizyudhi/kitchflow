// modules/dashboard/views/menu_terlaris_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_pages.dart';
import '../../best_menu/controllers/best_menu_controller.dart';
import '../../inventory/controllers/inventory_controller.dart';
import '../../hpp/controllers/hpp_controller.dart';
import '../../production/controllers/production_controller.dart';

class BestMenuView extends StatefulWidget {
  const BestMenuView({super.key});

  @override
  State<BestMenuView> createState() => _BestMenuViewState();
}

class _BestMenuViewState extends State<BestMenuView> {
  int _selectedFilter = 0;
  final List<String> _filters = ["Semua", "Terlaris", "Profit Tinggi", "Baru"];

  // ── HELPER DEFAULT QTY ──────────────────────────────────────────────────
  double _getDefaultQty(String bahanName) {
    final name = bahanName.toLowerCase();
    if (name.contains('ayam') || name.contains('daging') || name.contains('ikan')) {
      return 0.25;
    } else if (name.contains('bawang') || name.contains('cabai')) {
      return 0.02;
    } else if (name.contains('telur')) {
      return 0.5;
    } else if (name.contains('minyak') || name.contains('saus')) {
      return 0.05;
    } else if (name.contains('tepung')) {
      return 0.05;
    } else if (name.contains('garam') || name.contains('gula')) {
      return 0.005;
    }
    return 0.1;
  }

  // ── DIALOG TAMBAH MENU ─────────────────────────────────────────────────
  void _showTambahMenuDialog() {
    final invCtrl = InventoryController.to;
    final menuCtrl = BestMenuController.to;
    final namaCtrl = TextEditingController();
    final hargaCtrl = TextEditingController();
    final porsiCtrl = TextEditingController();
    
    // Pakai List dan Map biasa (bukan Rx)
    final List<String> selectedBahan = [];
    final Map<String, TextEditingController> qtyControllers = {};

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
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
                      text: "Tambah ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "Menu",
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ),
                const Text(
                  "Isi detail menu yang akan diproduksi",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),

                // ── NAMA MENU ──────────────────────────────────
                _modalField(
                  label: "Nama Menu",
                  hint: "Contoh: Ayam Goreng",
                  controller: namaCtrl,
                  icon: Icons.restaurant_rounded,
                ),
                const SizedBox(height: 14),

                // ── HARGA & TARGET PORSI ──────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _modalField(
                        label: "Harga Jual (Rp)",
                        hint: "15000",
                        controller: hargaCtrl,
                        icon: Icons.sell_rounded,
                        isNumber: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _modalField(
                        label: "Target Porsi",
                        hint: "50",
                        controller: porsiCtrl,
                        icon: Icons.dinner_dining_rounded,
                        isNumber: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── PILIH BAHAN ──────────────────────────────
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
                        color: AppColors.secondary,
                        size: 14,
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
                          horizontal: 8,
                          vertical: 3,
                        ),
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

                // ── LIST BAHAN ──────────────────────────────
                Obx(() {
                  final stokInventory = invCtrl.items;
                  if (stokInventory.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: const Center(
                        child: Text(
                          "Belum ada bahan di inventory",
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }
                  
                  // Inisialisasi qty controller untuk bahan baru
                  for (final bahan in stokInventory) {
                    if (!qtyControllers.containsKey(bahan.id)) {
                      qtyControllers[bahan.id] = TextEditingController(
                        text: _getDefaultQty(bahan.name).toString(),
                      );
                    }
                  }
                  
                  return Container(
                    constraints: const BoxConstraints(maxHeight: 300),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: stokInventory.length,
                      itemBuilder: (context, i) {
                        final bahan = stokInventory[i];
                        final isSelected = selectedBahan.contains(bahan.id);
                        
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedBahan.remove(bahan.id);
                                  } else {
                                    selectedBahan.add(bahan.id);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary.withOpacity(0.08)
                                      : Colors.transparent,
                                  border: i < stokInventory.length - 1
                                      ? const Border(
                                          bottom: BorderSide(
                                            color: Colors.white10,
                                          ),
                                        )
                                      : null,
                                ),
                                child: Row(
                                  children: [
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
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            bahan.name,
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
                                            "Stok: ${bahan.stockLabel}",
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
                                    if (isSelected) ...[
                                      const SizedBox(width: 8),
                                      SizedBox(
                                        width: 80,
                                        child: TextField(
                                          controller: qtyControllers[bahan.id],
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'Qty',
                                            hintStyle: const TextStyle(
                                              color: Colors.white24,
                                              fontSize: 10,
                                            ),
                                            suffixText: bahan.unit,
                                            suffixStyle: const TextStyle(
                                              color: Colors.white38,
                                              fontSize: 10,
                                            ),
                                            filled: true,
                                            fillColor: Colors.black.withOpacity(0.3),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                color: AppColors.secondary,
                                                width: 1,
                                              ),
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 6,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            if (isSelected) ...[
                              Container(
                                padding: const EdgeInsets.fromLTRB(60, 0, 16, 8),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.info_outline_rounded,
                                      color: Colors.white24,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Contoh: 0.25 = 1/4 ${bahan.unit} per porsi',
                                      style: const TextStyle(
                                        color: Colors.white24,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(color: Colors.white10, height: 1),
                            ],
                          ],
                        );
                      },
                    ),
                  );
                }),

                // ── SUMMARY BAHAN TERPILIH ────────────────────
                if (selectedBahan.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.secondary.withOpacity(0.2),
                      ),
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
                          children: selectedBahan.map((id) {
                            final nama = InventoryController.to
                                    .findById(id)
                                    ?.name ??
                                id;
                            final qty = qtyControllers[id]?.text ?? '0';
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.25),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$nama ($qty)',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedBahan.remove(id);
                                      });
                                    },
                                    child: const Icon(
                                      Icons.close_rounded,
                                      color: Colors.white38,
                                      size: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
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
                        if (namaCtrl.text.isEmpty || hargaCtrl.text.isEmpty) {
                          Get.snackbar(
                            "Perhatian",
                            "Nama menu dan harga jual wajib diisi",
                            backgroundColor: Colors.orange.withOpacity(0.8),
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                          );
                          return;
                        }

                        if (selectedBahan.isEmpty) {
                          Get.snackbar(
                            "Perhatian",
                            "Pilih minimal 1 bahan",
                            backgroundColor: Colors.orange.withOpacity(0.8),
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                          );
                          return;
                        }

                        // KUMPULKAN QTY
                        final List<double> qtyList = [];
                        for (final id in selectedBahan) {
                          final controller = qtyControllers[id];
                          if (controller != null) {
                            final qty = double.tryParse(controller.text) ?? 0.1;
                            qtyList.add(qty);
                          } else {
                            qtyList.add(0.1);
                          }
                        }

                        await menuCtrl.addMenu(
                          name: namaCtrl.text,
                          hargaJual: double.tryParse(hargaCtrl.text) ?? 0.0,
                          targetPorsi: int.tryParse(porsiCtrl.text) ?? 1,
                          inventoryItemIds: List<String>.from(selectedBahan),
                          qtyNeededList: qtyList,
                        );

                        Get.back();
                        Get.snackbar(
                          "Berhasil! 🎉",
                          "${namaCtrl.text} berhasil ditambahkan",
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

  // ── WIDGET FIELD ──────────────────────────────────────────────────────
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
            color: Colors.white70,
            fontSize: 12,
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
              color: AppColors.textHint,
              fontSize: 13,
            ),
            prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
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
      ],
    );
  }

  // ── DIALOG HAPUS ──────────────────────────────────────────────────────
  void _confirmHapusMenu(BuildContext context, dynamic menu) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Hapus Menu",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Yakin ingin menghapus menu \"${menu.name}\"?\nSemua data HPP menu ini juga akan dihapus.",
          style: const TextStyle(
            color: Colors.white60,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Batal",
              style: TextStyle(color: Colors.white38),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await BestMenuController.to.deleteMenu(menu.id);
              Get.snackbar(
                "Dihapus",
                "${menu.name} berhasil dihapus",
                backgroundColor: Colors.red.withOpacity(0.8),
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
              );
            },
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // ── FILTER ────────────────────────────────────────────────────────────
  List<dynamic> _getFiltered(BestMenuController menuCtrl) {
    final menus = menuCtrl.menus;
    if (_selectedFilter == 0) return menus;
    if (_selectedFilter == 1) {
      return [...menus]..sort((a, b) => b.targetPorsi.compareTo(a.targetPorsi));
    }
    if (_selectedFilter == 2) {
      return menus
          .where((m) => m.level == 'Profit Tinggi' || m.level == 'Best Seller')
          .toList();
    }
    return menus.reversed.toList();
  }

  // ── BUILD ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final menuCtrl = BestMenuController.to;

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
                // ── HEADER ──────────────────────────────────
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
                              text: const TextSpan(children: [
                                TextSpan(
                                  text: "List ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                TextSpan(
                                  text: "Menu",
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ]),
                            ),
                            const Text(
                              "Analisis menu terlaris & profit",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(() => Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Text(
                              "${menuCtrl.menus.length} Menu",
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
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
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── FILTERS ─────────────────────────────────
                SizedBox(
                  height: 42,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filters.length,
                    itemBuilder: (context, i) {
                      final isActive = _selectedFilter == i;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedFilter = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            gradient: isActive
                                ? AppColors.brandGradient
                                : null,
                            color: isActive ? null : AppColors.card,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: isActive ? Colors.transparent : Colors.white12,
                            ),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 10,
                                    )
                                  ]
                                : [],
                          ),
                          child: Text(
                            _filters[i],
                            style: TextStyle(
                              color: isActive ? Colors.white : AppColors.textSecondary,
                              fontSize: 13,
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // ── LIST MENU ──────────────────────────────
                Expanded(
                  child: Obx(() {
                    if (menuCtrl.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    final filtered = _getFiltered(menuCtrl);

                    if (filtered.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.restaurant_menu_rounded,
                              color: Colors.white12,
                              size: 60,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Belum ada menu",
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Tap tombol + untuk menambahkan menu",
                              style: TextStyle(
                                color: Colors.white24,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: filtered.length,
                      itemBuilder: (context, i) =>
                          _menuCard(filtered[i], menuCtrl),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── MENU CARD ─────────────────────────────────────────────────────────
  Widget _menuCard(dynamic menu, BestMenuController menuCtrl) {
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
          // ── GAMBAR + BADGE ──────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  color: Colors.white.withOpacity(0.05),
                  child: const Icon(
                    Icons.fastfood_rounded,
                    color: Colors.white24,
                    size: 40,
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    menu.level ?? "Baru",
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () => _confirmHapusMenu(context, menu),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── INFO MENU ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menu.name ?? "Tanpa Nama",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Harga: Rp ${menu.hargaJual.toInt()} | Target: ${menu.targetPorsi} Porsi",
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${menu.ingredients.length} bahan terdaftar",
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── DIVIDER ──────────────────────────────────
          const Divider(color: Colors.white10, height: 1),

          // ── TOMBOL BAWAH ─────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      menuCtrl.setActiveMenu(menu);
                      HppController.to.resetHpp();
                      Get.toNamed(Routes.HPP);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: AppColors.brandGradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calculate_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Hitung HPP",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: menu.hppPerPorsi > 0
                        ? () {
                            menuCtrl.setActiveMenu(menu);
                            ProductionController.to.syncTargetPorsi();
                            Get.toNamed(Routes.PRODUCTION);
                          }
                        : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: menu.hppPerPorsi > 0
                            ? Colors.green.withOpacity(0.12)
                            : Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: menu.hppPerPorsi > 0
                              ? Colors.green.withOpacity(0.3)
                              : Colors.white10,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant_rounded,
                            color: menu.hppPerPorsi > 0
                                ? Colors.green
                                : Colors.white24,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Produksi",
                            style: TextStyle(
                              color: menu.hppPerPorsi > 0
                                  ? Colors.green
                                  : Colors.white24,
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
          ),
        ],
      ),
    );
  }
}
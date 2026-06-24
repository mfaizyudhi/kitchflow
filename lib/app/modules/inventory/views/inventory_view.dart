import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/stock_card.dart';
import '../../../../routes/app_pages.dart';
import 'package:get/get.dart';


class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  int _selectedCategory = 0;

  final List<Map<String, dynamic>> _categories = [
    {"label": "Semua",   "icon": Icons.apps_rounded},
    {"label": "Protein", "icon": Icons.set_meal_rounded},
    {"label": "Sayuran", "icon": Icons.eco_rounded},
    {"label": "Bumbu",   "icon": Icons.opacity_rounded},
    {"label": "Lainnya", "icon": Icons.more_horiz_rounded},
  ];

  final List<Map<String, dynamic>> _stokList = [
    {
      "title": "Ayam Broiler",
      "stock": "2.5 Kg",
      "price": "Rp 45.000 / Kg",
      "status": "Menipis",
      "image": "assets/images/ayam.jpg",
      "category": "Protein",
    },
    {
      "title": "Telur Ayam",
      "stock": "8 Kg",
      "price": "Rp 30.000 / Kg",
      "status": "Menipis",
      "image": "assets/images/telur.jpg",
      "category": "Protein",
    },
    {
      "title": "Tempe",
      "stock": "24 Kg",
      "price": "Rp 18.000 / Kg",
      "status": "Aman",
      "image": "assets/images/tempe.jpg",
      "category": "Protein",
    },
    {
      "title": "Cabe Merah",
      "stock": "12 Kg",
      "price": "Rp 45.000 / Kg",
      "status": "Aman",
      "image": "assets/images/cabemerah.jpg",
      "category": "Sayuran",
    },
    {
      "title": "Bawang Merah",
      "stock": "5 Kg",
      "price": "Rp 38.000 / Kg",
      "status": "Menipis",
      "image": "assets/images/bawangmerah.jpg",
      "category": "Sayuran",
    },
    {
      "title": "Wortel",
      "stock": "10 Kg",
      "price": "Rp 12.000 / Kg",
      "status": "Aman",
      "image": "assets/images/wortel.jpg",
      "category": "Sayuran",
    },
    {
      "title": "Minyak Goreng",
      "stock": "5 Liter",
      "price": "Rp 20.000 / Liter",
      "status": "Aman",
      "image": "assets/images/minyak.jpg",
      "category": "Bumbu",
    },
    {
      "title": "Garam",
      "stock": "0 Kg",
      "price": "Rp 5.000 / Kg",
      "status": "Habis",
      "image": "assets/images/garam.jpg",
      "category": "Bumbu",
    },
    {
      "title": "Beras",
      "stock": "50 Kg",
      "price": "Rp 13.000 / Kg",
      "status": "Aman",
      "image": "assets/images/beras.jpg",
      "category": "Lainnya",
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_selectedCategory == 0) return _stokList;
    final cat = _categories[_selectedCategory]["label"];
    return _stokList.where((e) => e["category"] == cat).toList();
  }

  int get _totalItem => _stokList.length;
  int get _menipis =>
      _stokList.where((e) => e["status"] == "Menipis").length;
  int get _habis =>
      _stokList.where((e) => e["status"] == "Habis").length;

  void _showEditDialog(Map<String, dynamic> item) {
    final controller =
        TextEditingController(text: item["stock"].toString());

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HANDLE
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

            Text(
              "Edit Stok — ${item["title"]}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Masukkan jumlah stok baru",
                hintStyle:
                    const TextStyle(color: AppColors.textHint),
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

            const SizedBox(height: 20),

            /// TOMBOL SIMPAN
            Container(
              width: double.infinity,
              height: 54,
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
                    setState(() {
                      item["stock"] = controller.text;
                    });
                    Navigator.pop(context);
                  },
                  child: const Center(
                    child: Text(
                      "Simpan Perubahan",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [

          /// GLOW
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── HEADER ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Inventory",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Kelola stok bahan makanan",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),

                      /// TOMBOL TAMBAH
                      Container(
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
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => Get.toNamed(Routes.TAMBAH_BAHAN),
                            child: const Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── SUMMARY ────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _summaryCard(
                          "Total Item",
                          "$_totalItem",
                          Icons.inventory_2_outlined,
                          AppColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _summaryCard(
                          "Menipis",
                          "$_menipis",
                          Icons.warning_amber_rounded,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _summaryCard(
                          "Habis",
                          "$_habis",
                          Icons.remove_circle_outline,
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── SEARCH ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Cari bahan makanan...",
                      hintStyle: const TextStyle(
                          color: AppColors.textHint, fontSize: 14),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: AppColors.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ── KATEGORI FILTER ────────────────────────────
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _categories.length,
                    itemBuilder: (context, i) {
                      final isActive = _selectedCategory == i;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategory = i),
                        child: AnimatedContainer(
                          duration:
                              const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: isActive
                                ? AppColors.brandGradient
                                : null,
                            color: isActive
                                ? null
                                : AppColors.card,
                            borderRadius:
                                BorderRadius.circular(20),
                            border: Border.all(
                              color: isActive
                                  ? Colors.transparent
                                  : Colors.white12,
                            ),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withOpacity(0.3),
                                      blurRadius: 10,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _categories[i]["icon"] as IconData,
                                color: isActive
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                size: 13,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _categories[i]["label"],
                                style: TextStyle(
                                  color: isActive
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: isActive
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 14),

                // ── LIST STOK ──────────────────────────────────
                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filtered.length,
                    itemBuilder: (context, i) {
                      final item = _filtered[i];
                      return StockCard(
                        title: item["title"],
                        stock: item["stock"],
                        price: item["price"],
                        status: item["status"],
                        image: item["image"],
                        onEdit: () => _showEditDialog(item),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
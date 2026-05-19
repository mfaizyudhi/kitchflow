// lib/app/modules/best_menu/views/best_menu_view.dart

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

  final List<String> _filters = [
    "Semua",
    "Terlaris",
    "Profit Tinggi",
    "Baru",
  ];

  final List<Map<String, dynamic>> _menuList = [
    {
      "name": "Ayam Goreng",
      "image": "assets/images/ayamgoreng.jpg",
      "porsi": 84,
      "profit": "Rp 350.000",
      "hpp": "Rp 8.500",
      "harga": "Rp 15.000",
      "modal": "Rp 119.000",
      "level": "Best Seller",
      "levelColor": Colors.orange,
      "bahan": [
        "Ayam Broiler",
        "Minyak Goreng",
        "Bawang Putih",
        "Jahe",
      ],
      "rank": 1,
    },
    {
      "name": "Telor Balado",
      "image": "assets/images/telorbalado.jpg",
      "porsi": 62,
      "profit": "Rp 280.000",
      "hpp": "Rp 6.500",
      "harga": "Rp 12.000",
      "modal": "Rp 85.000",
      "level": "Tinggi",
      "levelColor": Colors.green,
      "bahan": [
        "Telur Ayam",
        "Cabe Merah",
        "Bawang Putih",
        "Tomat",
      ],
      "rank": 2,
    },
    {
      "name": "Orek Tempe",
      "image": "assets/images/tempeorek.jpg",
      "porsi": 55,
      "profit": "Rp 210.000",
      "hpp": "Rp 5.000",
      "harga": "Rp 10.000",
      "modal": "Rp 65.000",
      "level": "Populer",
      "levelColor": AppColors.secondary,
      "bahan": [
        "Tempe",
        "Cabe Merah",
        "Bawang Putih",
        "Minyak Goreng",
      ],
      "rank": 3,
    },
    {
      "name": "Sayur Lodeh",
      "image": "assets/images/sayurlodeh.jpg",
      "porsi": 48,
      "profit": "Rp 190.000",
      "hpp": "Rp 4.500",
      "harga": "Rp 8.000",
      "modal": "Rp 55.000",
      "level": "Populer",
      "levelColor": AppColors.secondary,
      "bahan": [
        "Kubis",
        "Wortel",
        "Santan",
        "Tempe",
      ],
      "rank": 4,
    },
    {
      "name": "Ayam Balado",
      "image": "assets/images/ayambalado.jpg",
      "porsi": 40,
      "profit": "Rp 320.000",
      "hpp": "Rp 12.000",
      "harga": "Rp 20.000",
      "modal": "Rp 145.000",
      "level": "Profit Tinggi",
      "levelColor": Colors.purple,
      "bahan": [
        "Ayam Broiler",
        "Cabe Merah",
        "Bawang Merah",
        "Tomat",
      ],
      "rank": 5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          /// GLOW EFFECT
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.18),
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
                _buildHeader(),

                const SizedBox(height: 18),

                _buildFilter(),

                const SizedBox(height: 18),

                /// MENU LIST
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _menuList.length,
                    itemBuilder: (context, index) {
                      final menu = _menuList[index];
                      return _buildMenuCard(menu);
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

  // ================= HEADER =================

  Widget _buildHeader() {
    return Padding(
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
              children: const [
                Text(
                  "Best Menu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Analisis menu terlaris & profit",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
              ),
            ),
            child: Text(
              "${_menuList.length} Menu",
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= FILTER =================

  Widget _buildFilter() {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final isActive = _selectedFilter == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                gradient:
                    isActive ? AppColors.brandGradient : null,
                color: isActive ? null : AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? Colors.transparent
                      : Colors.white12,
                ),
              ),
              child: Text(
                _filters[index],
                style: TextStyle(
                  color: isActive
                      ? Colors.white
                      : AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= MENU CARD =================

  Widget _buildMenuCard(Map<String, dynamic> menu) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Image.asset(
                  menu["image"],
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              /// TOP BADGE
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.brandGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "TOP ${menu["rank"]}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              /// LEVEL
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: menu["levelColor"],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    menu["level"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// CONTENT
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// NAME + PROFIT
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      menu["name"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      menu["profit"],
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// INFO CHIP
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _infoChip(
                      Icons.receipt_long_rounded,
                      "HPP ${menu["hpp"]}",
                      AppColors.secondary,
                    ),
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

                const SizedBox(height: 14),

                /// BAHAN
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: (menu["bahan"] as List<String>)
                      .map(
                        (item) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 16),

                /// BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.HPP);
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color:
                                AppColors.primary.withOpacity(0.12),
                            borderRadius:
                                BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.primary
                                  .withOpacity(0.3),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Hitung HPP",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.PRODUCTION);
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: AppColors.brandGradient,
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: Text(
                              "Produksi",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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

  // ================= CHIP =================

  Widget _infoChip(
    IconData icon,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
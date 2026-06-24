// modules/inventory/views/tambah_bahan_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';

class TambahBahanView extends StatefulWidget {
  const TambahBahanView({super.key});

  @override
  State<TambahBahanView> createState() => _TambahBahanViewState();
}

class _TambahBahanViewState extends State<TambahBahanView> {
  final _namaController      = TextEditingController();
  final _hargaBeliController = TextEditingController();
  final _beratController     = TextEditingController();
  final _stokAwalController  = TextEditingController();

  String _selectedSatuan   = 'kg';
  String _selectedKategori = 'Protein';

  final List<String> _satuanList = [
    'kg',
    'gram',
    'liter',
    'ml',
    'buah',
    'ikat',
    'bungkus'
  ];

  final List<String> _kategoriList = [
    'Protein',
    'Sayuran',
    'Bumbu',
    'Minyak',
    'Lainnya'
  ];

  // Simulasi data stok yang sudah ada
  final List<Map<String, dynamic>> _stokList = [
    {
      "nama": "Ayam Broiler",
      "harga": "Rp 35/gram",
      "stok": "5.000 gram",
      "status": "OK"
    },
    {
      "nama": "Tepung Bumbu",
      "harga": "Rp 40/gram",
      "stok": "2.000 gram",
      "status": "OK"
    },
    {
      "nama": "Minyak Goreng",
      "harga": "Rp 15/ml",
      "stok": "5.000 ml",
      "status": "OK"
    },
    {
      "nama": "Sambal Geprek",
      "harga": "Rp 20/gram",
      "stok": "3.000 gram",
      "status": "OK"
    },
    {
      "nama": "Beras Putih",
      "harga": "Rp 14/gram",
      "stok": "10.000 gram",
      "status": "OK"
    },
  ];

  String _wilayah = "Kota Tegal, Jawa Tengah";

  void _tambahBahan() {
    if (_namaController.text.isEmpty ||
        _hargaBeliController.text.isEmpty ||
        _beratController.text.isEmpty) {
      Get.snackbar(
        "Perhatian",
        "Lengkapi semua field yang diperlukan",
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    setState(() {
      _stokList.insert(0, {
        "nama": _namaController.text,
        "harga": "Rp ${_hargaBeliController.text}/$_selectedSatuan",
        "stok": "${_beratController.text} $_selectedSatuan",
        "status": "OK",
      });

      _namaController.clear();
      _hargaBeliController.clear();
      _beratController.clear();
      _stokAwalController.clear();
    });

    Get.snackbar(
      "Berhasil",
      "Bahan berhasil ditambahkan ke gudang",
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
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
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Tambah ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Bahan",
                                    style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Text(
                              "Kelola stok bahan makanan gudang",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── LOKASI WILAYAH ───────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.secondary.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.secondary,
                            size: 16,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Lokasi Wilayah Aktif",
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                              ),

                              Text(
                                _wilayah,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Aktif",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── STOK BAHAN BAKU ──────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Stok Bahan Baku",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          "${_stokList.length} item",
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // LIST STOK
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: List.generate(_stokList.length, (i) {
                        final item = _stokList[i];

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: i < _stokList.length - 1
                                ? const Border(
                                    bottom: BorderSide(
                                      color: Colors.white10,
                                    ),
                                  )
                                : null,
                          ),
                          child: Row(
                            children: [

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item["nama"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),

                                    const SizedBox(height: 3),

                                    Text(
                                      "${item["harga"]}  •  stok ${item["stok"]}",
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // STATUS
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.green.withOpacity(0.3),
                                  ),
                                ),
                                child: const Text(
                                  "OK",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              // DELETE
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _stokList.removeAt(i)),
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.red.withOpacity(0.2),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.redAccent,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── TAMBAH BAHAN ─────────────────────────────────
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: AppColors.brandGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Text(
                        "Tambah Bahan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // NAMA + SATUAN
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildField(
                                label: "Nama Bahan",
                                hint: "Nama bahan",
                                controller: _namaController,
                                icon: Icons.restaurant_rounded,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Satuan",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F172A),
                                      borderRadius:
                                          BorderRadius.circular(14),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedSatuan,
                                        dropdownColor: AppColors.card,
                                        isExpanded: true,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color:
                                              AppColors.textSecondary,
                                        ),
                                        items: _satuanList
                                            .map(
                                              (s) => DropdownMenuItem(
                                                value: s,
                                                child: Text(
                                                  s,
                                                  style:
                                                      const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (val) => setState(
                                          () => _selectedSatuan = val!,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // KATEGORI
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Kategori",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 8),

                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children:
                                    _kategoriList.map((k) {
                                  final isSelected =
                                      _selectedKategori == k;

                                  return GestureDetector(
                                    onTap: () => setState(
                                      () => _selectedKategori = k,
                                    ),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                          milliseconds: 200),
                                      margin:
                                          const EdgeInsets.only(
                                              right: 8),
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: isSelected
                                            ? AppColors
                                                .brandGradient
                                            : null,
                                        color: isSelected
                                            ? null
                                            : const Color(
                                                0xFF0F172A),
                                        borderRadius:
                                            BorderRadius.circular(
                                                20),
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.transparent
                                              : Colors.white12,
                                        ),
                                      ),
                                      child: Text(
                                        k,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : AppColors
                                                  .textSecondary,
                                          fontSize: 12,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // HARGA BELI
                        _buildField(
                          label: "Harga Beli (Rp)",
                          hint: "Harga beli per satuan",
                          controller: _hargaBeliController,
                          icon: Icons.payments_rounded,
                          isNumber: true,
                        ),

                        const SizedBox(height: 14),

                        // BERAT/VOLUME + STOK AWAL
                        Row(
                          children: [
                            Expanded(
                              child: _buildField(
                                label: "Berat/Volume Total",
                                hint: "1000",
                                controller: _beratController,
                                icon: Icons.scale_rounded,
                                isNumber: true,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: _buildField(
                                label: "Stok Awal",
                                hint: "0",
                                controller:
                                    _stokAwalController,
                                icon:
                                    Icons.inventory_2_outlined,
                                isNumber: true,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // TOMBOL TAMBAH
                        Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: AppColors.brandGradient,
                            borderRadius:
                                BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary
                                    .withOpacity(0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(16),
                              onTap: _tambahBahan,
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),

                                    SizedBox(width: 8),

                                    Text(
                                      "Tambah ke Gudang",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight:
                                            FontWeight.bold,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
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
          keyboardType:
              isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textHint,
              fontSize: 13,
            ),
            prefixIcon: Icon(
              icon,
              color: AppColors.textSecondary,
              size: 18,
            ),
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
}
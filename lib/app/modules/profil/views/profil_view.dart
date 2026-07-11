import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_pages.dart';
import 'informasi_pengguna_view.dart';
import '../../best_menu/controllers/best_menu_controller.dart';
import '../../../../controllers/models/sales_controller.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  final SupabaseClient _supabase = Supabase.instance.client;
  Future<Map<String, dynamic>?>? _profileFuture;
  Future<List<Map<String, dynamic>>>? _activityLogsFuture;
  bool _isUploadingPhoto = false;

  // Tambahkan controller
  final SalesController _salesController = Get.find<SalesController>();
  final BestMenuController _bestMenuController = Get.find<BestMenuController>();

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
    _fetchActivityLogs();
    // Data penjualan dan menu otomatis ter-load dari stream
    // Tidak perlu panggil method apapun
  }

  void _fetchProfileData() {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      setState(() {
        _profileFuture = _supabase
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();
      });
    }
  }

  // ── FETCH LOG AKTIVITAS ────────────────────────────────────────
  void _fetchActivityLogs() {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    setState(() {
      _activityLogsFuture = _supabase
          .from('activity_logs')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(10)
          .then((data) => List<Map<String, dynamic>>.from(data));
    });
  }

  // ── UPLOAD FOTO PROFIL ──────────────────────────────────────────
  Future<void> _pickAndUploadPhoto() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (image == null) return;

    setState(() => _isUploadingPhoto = true);

    try {
      final file = File(image.path);
      final fileExt = image.path.split('.').last;
      final fileName = '${user.id}/avatar.$fileExt';

      await _supabase.storage.from('avatars').upload(
            fileName,
            file,
            fileOptions: const FileOptions(upsert: true),
          );

      final publicUrl = _supabase.storage.from('avatars').getPublicUrl(fileName);
      final urlWithTimestamp =
          '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}';

      await _supabase
          .from('profiles')
          .update({'avatar_url': urlWithTimestamp})
          .eq('id', user.id);

      _fetchProfileData();
      Get.snackbar(
        'Berhasil',
        'Foto profil berhasil diperbarui',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal mengupload foto: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      if (mounted) setState(() => _isUploadingPhoto = false);
    }
  }

  // ── EDIT NAMA ────────────────────────────────────────────────────
  Future<void> _editName(String currentName) async {
    final controller = TextEditingController(text: currentName);
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final result = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Nama', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Masukkan nama',
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: const Color(0xFF0F172A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Simpan', style: TextStyle(color: AppColors.secondary)),
          ),
        ],
      ),
    );

    if (result == true && controller.text.trim().isNotEmpty) {
      try {
        await _supabase
            .from('profiles')
            .update({'nama_pemilik': controller.text.trim()})
            .eq('id', user.id);
        _fetchProfileData();
        Get.snackbar(
          'Berhasil',
          'Nama berhasil diperbarui',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } catch (e) {
        Get.snackbar(
          'Gagal',
          'Gagal memperbarui nama: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// GLOW TOP
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

          /// GLOW BOTTOM
          Positioned(
            bottom: 80,
            left: -60,
            child: Container(
              width: 180,
              height: 180,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── HEADER ──────────────────────────────────────
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Profil ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        TextSpan(
                          text: "& Pengaturan",
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Kelola akun dan preferensi aplikasi",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── PROFILE CARD (FUTUREBUILDER) ──────────────────
                  FutureBuilder<Map<String, dynamic>?>(
                    future: _profileFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final currentUser = _supabase.auth.currentUser;
                      String displayName = "Pengguna KitchFlow";
                      String emailUser = currentUser?.email ?? "-";
                      String? avatarUrl;

                      if (snapshot.hasData && snapshot.data != null) {
                        final profileData = snapshot.data!;

                        if (profileData['nama_pemilik'] != null &&
                            profileData['nama_pemilik'].toString().isNotEmpty) {
                          displayName = profileData['nama_pemilik'];
                        } else if (currentUser?.userMetadata?['full_name'] != null) {
                          displayName = currentUser!.userMetadata!['full_name'];
                        }

                        avatarUrl = profileData['avatar_url'];
                      } else {
                        if (currentUser?.userMetadata?['full_name'] != null) {
                          displayName = currentUser!.userMetadata!['full_name'];
                        }
                      }

                      return _buildProfileCard(
                        namaUser: displayName,
                        emailUser: emailUser,
                        avatarUrl: avatarUrl,
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // ── BUSINESS STAT (DENGAN DATA REAL) ─────────────
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() {
                          // 0 = Harian (sama seperti di AnalyticsView)
                          final stats = _salesController.statsForPeriod(0);
                          final totalPenjualan = _formatRupiah(stats.total);
                          return _statCard(
                            "Penjualan\nHari Ini",
                            totalPenjualan,
                            Icons.trending_up_rounded,
                            Colors.green,
                          );
                        }),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(() {
                          // Hitung total menu (sama seperti di AnalyticsView)
                          final totalMenus = _bestMenuController.menus.length;
                          return _statCard(
                            "Total\nMenu",
                            "$totalMenus",
                            Icons.restaurant_menu_rounded,
                            AppColors.secondary,
                          );
                        }),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── LOG AKTIVITAS ─────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _sectionTitle("Aktivitas Terbaru"),
                      GestureDetector(
                        onTap: _fetchActivityLogs,
                        child: const Icon(
                          Icons.refresh_rounded,
                          color: Colors.white38,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  _buildActivityLogSection(),

                  const SizedBox(height: 28),

                  // ── PENGATURAN AKUN ──────────────────────────────
                  _sectionTitle("Pengaturan Akun"),
                  const SizedBox(height: 14),

                  _menuTile(
                    icon: Icons.person_outline_rounded,
                    color: AppColors.primary,
                    title: "Informasi Pengguna",
                    subtitle: "Nama lengkap, data diri, kontak",
                    onTap: () => Get.to(() => const InformasiPenggunaView()),
                  ),
                  _menuTile(
                    icon: Icons.security_rounded,
                    color: Colors.blue,
                    title: "Keamanan & Password",
                    subtitle: "Password dan autentikasi",
                    onTap: () => Get.to(() => const InformasiPenggunaView()),
                  ),

                  const SizedBox(height: 40),

                  // ── VERSI APP ────────────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: const Text(
                            "KitchFlow  •  v1.0.0",
                            style: TextStyle(
                              color: Colors.white24,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── LOGOUT ───────────────────────────────────────
                  Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                      color: Colors.redAccent.withOpacity(0.06),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () async {
                          await _supabase.auth.signOut();
                          Get.offAllNamed(Routes.LOGIN);
                        },
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Logout Dari Sesi",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
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
        ],
      ),
    );
  }

  // ── CARD PROFILE WIDGET ──────────────────────────────────────────
  Widget _buildProfileCard({
    required String namaUser,
    required String emailUser,
    String? avatarUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A0533), Color(0xFF0D1F3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── AVATAR (bisa diklik untuk ganti foto) ──────────────
          GestureDetector(
            onTap: _isUploadingPhoto ? null : _pickAndUploadPhoto,
            child: Stack(
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    gradient: (avatarUrl == null || avatarUrl.isEmpty)
                        ? AppColors.brandGradient
                        : null,
                    shape: BoxShape.circle,
                    image: (avatarUrl != null && avatarUrl.isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(avatarUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 18,
                      ),
                    ],
                  ),
                  child: _isUploadingPhoto
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : ((avatarUrl == null || avatarUrl.isEmpty)
                          ? const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 34,
                            )
                          : null),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF0D1F3C), width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  namaUser,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  emailUser,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _badge("AKTIF", Colors.green),
                    const SizedBox(width: 8),
                    _badge("PREMIUM", AppColors.secondary),
                  ],
                ),
              ],
            ),
          ),
          // ── TOMBOL EDIT NAMA ─────────────────────────────────────
          GestureDetector(
            onTap: () => _editName(namaUser),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: Colors.white54,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── SECTION LOG AKTIVITAS ─────────────────────────────────────────
  Widget _buildActivityLogSection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _activityLogsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white10),
            ),
            child: const Center(
              child: Text(
                "Gagal memuat aktivitas",
                style: TextStyle(color: Colors.white38, fontSize: 13),
              ),
            ),
          );
        }

        final logs = snapshot.data ?? [];

        if (logs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white10),
            ),
            child: const Center(
              child: Text(
                "Belum ada aktivitas",
                style: TextStyle(color: Colors.white38, fontSize: 13),
              ),
            ),
          );
        }

        return Column(
          children: logs.map((log) => _activityTile(log)).toList(),
        );
      },
    );
  }

  Widget _activityTile(Map<String, dynamic> log) {
    final type = log['activity_type'] as String? ?? '';
    final title = log['title'] as String? ?? '';
    final description = log['description'] as String?;
    final createdAt = DateTime.tryParse(log['created_at']?.toString() ?? '');

    final iconData = _iconForType(type);
    final color = _colorForType(type);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(iconData, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (description != null && description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (createdAt != null)
            Text(
              _formatWaktuRelatif(createdAt),
              style: const TextStyle(color: Colors.white24, fontSize: 10),
            ),
        ],
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'tambah_menu':
        return Icons.restaurant_menu_rounded;
      case 'hapus_menu':
        return Icons.delete_outline_rounded;
      case 'tambah_bahan':
        return Icons.inventory_2_outlined;
      case 'hapus_bahan':
        return Icons.remove_circle_outline_rounded;
      case 'penjualan':
        return Icons.point_of_sale_rounded;
      default:
        return Icons.history_rounded;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'tambah_menu':
      case 'tambah_bahan':
        return Colors.green;
      case 'hapus_menu':
      case 'hapus_bahan':
        return Colors.redAccent;
      case 'penjualan':
        return AppColors.secondary;
      default:
        return Colors.white54;
    }
  }

  String _formatWaktuRelatif(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m lalu';
    if (diff.inHours < 24) return '${diff.inHours}j lalu';
    return '${diff.inDays}h lalu';
  }

  // ── HELPERS ──────────────────────────────────────────────────────

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white24,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  // ── FORMAT RUPIAH (sama dengan di AnalyticsView) ──────────────
  String _formatRupiah(double value) {
    final str = value.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final posFromRight = str.length - i;
      buffer.write(str[i]);
      if (posFromRight > 1 && posFromRight % 3 == 1) {
        buffer.write('.');
      }
    }
    return "Rp $buffer";
  }
}
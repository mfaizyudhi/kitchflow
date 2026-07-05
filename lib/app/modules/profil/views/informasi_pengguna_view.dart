import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';

class InformasiPenggunaView extends StatefulWidget {
  const InformasiPenggunaView({super.key});

  @override
  State<InformasiPenggunaView> createState() => _InformasiPenggunaViewState();
}

class _InformasiPenggunaViewState extends State<InformasiPenggunaView> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoadingNama = false;
  bool _isLoadingPassword = false;
  bool _obscurePassword = true;

  String get _email => _supabase.auth.currentUser?.email ?? "-";

  @override
  void initState() {
    super.initState();
    _loadNama();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadNama() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    try {
      final data = await _supabase
          .from('profiles')
          .select('nama_pemilik')
          .eq('id', user.id)
          .maybeSingle();
      if (mounted) {
        setState(() => _namaController.text = data?['nama_pemilik'] ?? '');
      }
    } catch (_) {
      // biarkan kosong kalau gagal load, user masih bisa isi manual
    }
  }

  Future<void> _saveNama() async {
    final user = _supabase.auth.currentUser;
    if (user == null || _namaController.text.trim().isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Nama tidak boleh kosong',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    setState(() => _isLoadingNama = true);
    try {
      await _supabase
          .from('profiles')
          .update({'nama_pemilik': _namaController.text.trim()})
          .eq('id', user.id);
      Get.snackbar(
        'Berhasil',
        'Nama berhasil disimpan',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal menyimpan nama: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      if (mounted) setState(() => _isLoadingNama = false);
    }
  }

  Future<void> _changePassword() async {
    if (_passwordController.text.trim().length < 6) {
      Get.snackbar(
        'Peringatan',
        'Password minimal 6 karakter',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    setState(() => _isLoadingPassword = true);
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: _passwordController.text.trim()),
      );
      _passwordController.clear();
      Get.snackbar(
        'Berhasil',
        'Password berhasil diganti',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } on AuthException catch (e) {
      Get.snackbar(
        'Gagal',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal mengganti password: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      if (mounted) setState(() => _isLoadingPassword = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Informasi Pengguna',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── NAMA ──────────────────────────────────────────
              const Text(
                "Nama Lengkap",
                style: TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _namaController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Masukkan nama lengkap',
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.textSecondary, size: 20),
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _isLoadingNama ? null : _saveNama,
                  child: _isLoadingNama
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Simpan Nama', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 32),

              // ── EMAIL ─────────────────────────────────────────
              const Text(
                "Email",
                style: TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.email_outlined, color: AppColors.textSecondary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _email,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                    const Icon(Icons.lock_outline_rounded, color: Colors.white24, size: 16),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Email tidak dapat diubah langsung di sini",
                style: TextStyle(color: Colors.white24, fontSize: 11),
              ),

              const SizedBox(height: 32),

              // ── GANTI PASSWORD ────────────────────────────────
              const Text(
                "Ganti Password",
                style: TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Password baru (min. 6 karakter)',
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textSecondary, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _isLoadingPassword ? null : _changePassword,
                  child: _isLoadingPassword
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.blue, strokeWidth: 2),
                        )
                      : const Text('Ganti Password', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
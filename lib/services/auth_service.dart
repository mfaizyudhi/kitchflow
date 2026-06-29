import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: '821783986557-63lttsjks2kbniqob978q2thtlqbi4qm.apps.googleusercontent.com',
  );

  /// VERIFY OTP setelah register
  static Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final AuthResponse response = await _supabase.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.signup,
      );

      final user = response.user;
      if (user == null) throw Exception("Verifikasi gagal");
    } on AuthException catch (e) {
      throw Exception("OTP tidak valid: ${e.message}");
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }

  /// RESEND OTP jika tidak diterima
  static Future<void> resendOtp({required String email}) async {
    try {
      await _supabase.auth.resend(
        type: OtpType.signup,
        email: email,
      );
    } on AuthException catch (e) {
      throw Exception("Gagal kirim ulang OTP: ${e.message}");
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }

  /// REGISTER USER — kirim OTP 6 digit, bukan link
  static Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // ✅ PERBAIKAN: pakai shouldCreateUser + emailRedirectTo null
      // agar Supabase kirim kode OTP bukan link konfirmasi
      final AuthResponse response = await _supabase.auth.signUp(
        email: email.trim(),
        password: password,
        emailRedirectTo: null, // ✅ ini yang memaksa kirim OTP bukan link
      );

      final user = response.user;
      if (user == null) throw Exception("Gagal membuat akun");

      // Simpan username ke tabel profiles
      await _supabase.from('profiles').insert({
        'id': user.id,
        'nama_pemilik': username.trim(),
      });
    } on AuthException catch (e) {
      throw Exception("Register gagal: ${e.message}");
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }

  /// LOGIN USER
  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
    } on AuthException catch (e) {
      throw Exception("Login gagal: ${e.message}");
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }

  /// GOOGLE LOGIN
  static Future<void> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      if (idToken == null) throw Exception("Tidak mendapat ID token");

      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } on AuthException catch (e) {
      throw Exception("Login gagal: ${e.message}");
    } catch (e) {
      throw Exception("Google login gagal: $e");
    }
  }

  /// LOGOUT
  static Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception("Logout gagal: $e");
    }
  }

  /// GET CURRENT USER
  static User? get currentUser => _supabase.auth.currentUser;

  /// CHECK LOGIN STATUS
  static bool get isLoggedIn => currentUser != null;
}
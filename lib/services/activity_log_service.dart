import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ActivityLogService {
  static final _supabase = Supabase.instance.client;

  static Future<void> log({
    required String type,
    required String title,
    String? description,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase.from('activity_logs').insert({
        'user_id': user.id,
        'activity_type': type,
        'title': title,
        'description': description,
      });
    } catch (e) {
      debugPrint('Gagal mencatat aktivitas: $e');
    }
  }
}
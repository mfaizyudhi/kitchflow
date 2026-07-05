// lib/modules/sales/controllers/sales_controller.dart

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/widgets/sales_record.dart';
export '../../../../core/widgets/sales_record.dart';

class SalesController extends GetxController {
  static SalesController get to => Get.find();
 
  final _sb = Supabase.instance.client;
 
  final RxList<SalesRecord> records = <SalesRecord>[].obs;
  final RxBool isLoading = false.obs;
 
  @override
  void onInit() {
    super.onInit();
    _listenSales();
  }
 
  void _listenSales() {
    isLoading.value = true;
    _sb
        .from('sales')
        .stream(primaryKey: ['id'])
        .order('tanggal')
        .listen((rows) {
      records.value = rows.map(SalesRecord.fromJson).toList();
      isLoading.value = false;
    });
  }
 
  // ── INSERT ────────────────────────────────────────────────────────────
  Future<void> addSale({
    required String menuId,
    required String menuName,
    required int qty,
    required double hargaSatuan,
    DateTime? tanggal,
  }) async {
    await _sb.from('sales').insert({
      'menu_id': menuId,
      'menu_name': menuName,
      'qty': qty,
      'harga_satuan': hargaSatuan,
      'tanggal':
          (tanggal ?? DateTime.now()).toIso8601String().split('T').first,
    });
  }
 
  // ── AGREGAT HARIAN (7 hari terakhir) ────────────────────────────────
  Map<DateTime, double> dailyTotals({int days = 7}) {
    final now = DateTime.now();
    final start =
        DateTime(now.year, now.month, now.day).subtract(Duration(days: days - 1));
 
    final Map<DateTime, double> result = {
      for (int i = 0; i < days; i++) start.add(Duration(days: i)): 0.0,
    };
 
    for (final r in records) {
      final key = DateTime(r.tanggal.year, r.tanggal.month, r.tanggal.day);
      if (result.containsKey(key)) {
        result[key] = result[key]! + r.total;
      }
    }
    return result;
  }
 
  // ── AGREGAT MINGGUAN (n minggu terakhir, dikunci ke hari Senin) ─────
  Map<DateTime, double> weeklyTotals({int weeks = 8}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisMonday = today.subtract(Duration(days: today.weekday - 1));
    final startMonday = thisMonday.subtract(Duration(days: 7 * (weeks - 1)));
 
    final Map<DateTime, double> result = {
      for (int i = 0; i < weeks; i++)
        startMonday.add(Duration(days: 7 * i)): 0.0,
    };
 
    for (final r in records) {
      final day = DateTime(r.tanggal.year, r.tanggal.month, r.tanggal.day);
      final monday = day.subtract(Duration(days: day.weekday - 1));
      if (result.containsKey(monday)) {
        result[monday] = result[monday]! + r.total;
      }
    }
    return result;
  }
 
  // ── AGREGAT BULANAN (n bulan terakhir) ───────────────────────────────
  Map<DateTime, double> monthlyTotals({int months = 6}) {
    final now = DateTime.now();
    final startMonth = DateTime(now.year, now.month - (months - 1), 1);
 
    final Map<DateTime, double> result = {
      for (int i = 0; i < months; i++)
        DateTime(startMonth.year, startMonth.month + i, 1): 0.0,
    };
 
    for (final r in records) {
      final key = DateTime(r.tanggal.year, r.tanggal.month, 1);
      if (result.containsKey(key)) {
        result[key] = result[key]! + r.total;
      }
    }
    return result;
  }
 
  // ── STAT CARD (bulan berjalan) ───────────────────────────────────────
  double get totalBulanIni {
    final now = DateTime.now();
    return records
        .where((r) => r.tanggal.year == now.year && r.tanggal.month == now.month)
        .fold(0.0, (sum, r) => sum + r.total);
  }
 
  int get totalPorsiBulanIni {
    final now = DateTime.now();
    return records
        .where((r) => r.tanggal.year == now.year && r.tanggal.month == now.month)
        .fold(0, (sum, r) => sum + r.qty);
  }
 
  int get jumlahTransaksiBulanIni {
    final now = DateTime.now();
    return records
        .where((r) => r.tanggal.year == now.year && r.tanggal.month == now.month)
        .length;
  }
 
  /// Statistik yang mengikuti toggle periode (0 = Harian, 1 = Mingguan, 2 = Bulanan).
  /// Harian → sejak awal hari ini
  /// Mingguan → sejak Senin minggu ini
  /// Bulanan → sejak tanggal 1 bulan ini
  ({double total, int porsi, int transaksi}) statsForPeriod(int periodIndex) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
 
    late final DateTime start;
    switch (periodIndex) {
      case 1:
        start = today.subtract(Duration(days: today.weekday - 1)); // Senin ini
        break;
      case 2:
        start = DateTime(now.year, now.month, 1);
        break;
      default:
        start = today; // Harian
    }
 
    final filtered = records.where((r) {
      final d = DateTime(r.tanggal.year, r.tanggal.month, r.tanggal.day);
      return !d.isBefore(start);
    });
 
    final total = filtered.fold(0.0, (sum, r) => sum + r.total);
    final porsi = filtered.fold(0, (sum, r) => sum + r.qty);
    final transaksi = filtered.length;
 
    return (total: total, porsi: porsi, transaksi: transaksi);
  }
}
 
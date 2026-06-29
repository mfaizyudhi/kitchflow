// lib/controllers/models/production_session.dart

class ProductionSession {
  final String menuId;
  int    targetPorsi;
  final double totalModal;
  final double estimasiPenjualan;
  final double estimasiProfit;
  String status; // "draft" | "confirmed"
  final DateTime createdAt;

  ProductionSession({
    required this.menuId,
    required this.targetPorsi,
    required this.totalModal,
    required this.estimasiPenjualan,
    required this.estimasiProfit,
    this.status    = 'draft',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ProductionSession.fromJson(Map<String, dynamic> j) =>
      ProductionSession(
        menuId:            j['menu_id'] as String,
        targetPorsi:       (j['target_porsi'] as num).toInt(),
        totalModal:        (j['total_modal'] as num).toDouble(),
        estimasiPenjualan: (j['estimasi_penjualan'] as num).toDouble(),
        estimasiProfit:    (j['estimasi_profit'] as num).toDouble(),
        status:            j['status'] as String? ?? 'draft',
        createdAt:         DateTime.tryParse(j['created_at'] as String? ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'menu_id':             menuId,
        'target_porsi':        targetPorsi,
        'total_modal':         totalModal,
        'estimasi_penjualan':  estimasiPenjualan,
        'estimasi_profit':     estimasiProfit,
        'status':              status,
      };
}
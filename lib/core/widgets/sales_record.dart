class SalesRecord {
  final String id;
  final String menuId;
  final String menuName;
  final int qty;
  final double hargaSatuan;
  final double total;
  final DateTime tanggal;

  SalesRecord({
    required this.id,
    required this.menuId,
    required this.menuName,
    required this.qty,
    required this.hargaSatuan,
    required this.total,
    required this.tanggal,
  });

  factory SalesRecord.fromJson(Map<String, dynamic> j) => SalesRecord(
        id: j['id'] as String,
        menuId: j['menu_id'] as String,
        menuName: j['menu_name'] as String,
        qty: j['qty'] as int,
        hargaSatuan: (j['harga_satuan'] as num).toDouble(),
        total: (j['total'] as num).toDouble(),
        tanggal: DateTime.parse(j['tanggal'] as String),
      );
}
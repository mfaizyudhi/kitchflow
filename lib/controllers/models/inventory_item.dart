// lib/controllers/models/inventory_item.dart

class InventoryItem {
  final String id;
  final String name;
  double stockQty;
  final String unit;
  final double pricePerUnit;
  final String category;
  String status; // "Aman" | "Menipis" | "Habis"
  final String imagePath;

  InventoryItem({
    required this.id,
    required this.name,
    required this.stockQty,
    required this.unit,
    required this.pricePerUnit,
    required this.category,
    required this.status,
    this.imagePath = 'assets/images/food_ai.jpg',
  });

  factory InventoryItem.fromJson(Map<String, dynamic> j) => InventoryItem(
        id:           j['id'] as String,
        name:         j['name'] as String,
        stockQty:     (j['stock_qty'] as num).toDouble(),
        unit:         j['unit'] as String,
        pricePerUnit: (j['price_per_unit'] as num).toDouble(),
        category:     j['category'] as String,
        status:       j['status'] as String,
        imagePath:    j['image_path'] as String? ?? 'assets/images/food_ai.jpg',
      );

  Map<String, dynamic> toJson() => {
        'id':             id,
        'name':           name,
        'stock_qty':      stockQty,
        'unit':           unit,
        'price_per_unit': pricePerUnit,
        'category':       category,
        'status':         status,
        'image_path':     imagePath,
      };

  /// "24 Kg", "5 Liter", dll.
  String get stockLabel =>
      '${stockQty % 1 == 0 ? stockQty.toInt() : stockQty} $unit';

  String get priceLabel => 'Rp ${_fmt(pricePerUnit.toInt())} / $unit';

  static String _fmt(int v) {
    final s = v.toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return b.toString();
  }

  /// Status otomatis berdasarkan stok
  static String resolveStatus(double qty) {
    if (qty <= 0) return 'Habis';
    if (qty < 3)  return 'Menipis';
    return 'Aman';
  }
}
import 'menu_ingredient.dart';

class MenuItem {
  final String id;
  final String name;
  final String imagePath;
  final double hargaJual;
  final int targetPorsi; // Konsisten menggunakan int
  final String level;
  final int rank;

  // Menggunakan tipe data yang aman dari null saat parsing Supabase
  double hppPerPorsi;
  double rekomendasiHarga;
  double totalModal;

  List<MenuIngredient> ingredients;

  MenuItem({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.hargaJual,
    required this.targetPorsi,
    required this.level,
    required this.rank,
    this.hppPerPorsi = 0.0,
    this.rekomendasiHarga = 0.0,
    this.totalModal = 0.0,
    List<MenuIngredient>? ingredients,
  }) : ingredients = ingredients ?? [];

  factory MenuItem.fromJson(Map<String, dynamic> j) => MenuItem(
        id:          j['id'] as String? ?? '',
        name:        j['name'] as String? ?? '',
        imagePath:   j['image_path'] as String? ?? 'assets/images/food_ai.jpg',
        hargaJual:   (j['harga_jual'] as num? ?? 0).toDouble(),
        targetPorsi: (j['target_porsi'] as num? ?? 0).toInt(),
        level:       j['level'] as String? ?? 'Populer',
        rank:        (j['rank'] as num? ?? 0).toInt(),
      );

  Map<String, dynamic> toJson() => {
        'name':         name,
        'image_path':   imagePath,
        'harga_jual':   hargaJual,
        'target_porsi': targetPorsi,
        'level':        level,
        'rank':         rank,
      };

  double get estimasiProfit => (rekomendasiHarga - hppPerPorsi) * targetPorsi;

  bool get hppSudahDihitung => hppPerPorsi > 0 && rekomendasiHarga > 0;

  String get profitLabel => 'Rp ${_fmt(estimasiProfit.toInt())}';
  String get hargaLabel  => 'Rp ${_fmt(hargaJual.toInt())}';
  String get modalLabel  => 'Rp ${_fmt(totalModal.toInt())}';

  static String _fmt(int v) {
    final s = v.toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return b.toString();
  }
}
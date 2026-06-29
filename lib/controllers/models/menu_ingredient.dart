// lib/controllers/models/menu_ingredient.dart

class MenuIngredient {
  final String id;
  final String menuId;
  final String inventoryItemId;
  final double qtyNeeded;

  const MenuIngredient({
    required this.id,
    required this.menuId,
    required this.inventoryItemId,
    required this.qtyNeeded,
  });

  factory MenuIngredient.fromJson(Map<String, dynamic> j) => MenuIngredient(
        id:              j['id']                as String? ?? '',
        menuId:          j['menu_id']           as String? ?? '',
        inventoryItemId: j['inventory_item_id'] as String,
        qtyNeeded:       (j['qty_needed']       as num).toDouble(),
      );
}
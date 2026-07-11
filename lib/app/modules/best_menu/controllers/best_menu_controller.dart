// lib/controllers/best_menu_controller.dart

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kitchflow/controllers/models/menu_item.dart';
import 'package:kitchflow/controllers/models/menu_ingredient.dart';
import '../../../../services/activity_log_service.dart';

export 'package:kitchflow/controllers/models/menu_item.dart';
export 'package:kitchflow/controllers/models/menu_ingredient.dart';

class BestMenuController extends GetxController {
  static BestMenuController get to => Get.find();

  final _sb = Supabase.instance.client;

  // ── STATE ─────────────────────────────────────────────────────────────────
  final RxList<MenuItem> menus = <MenuItem>[].obs;
  final RxBool isLoading = false.obs;
  final Rxn<MenuItem> activeMenu = Rxn<MenuItem>();

  // ── COMPUTED ──────────────────────────────────────────────────────────────
  double get totalEstimasiProfit =>
      menus.fold(0.0, (sum, m) => sum + m.estimasiProfit);

  // ── LIFECYCLE ─────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _listenMenus();
  }

  // ── REALTIME STREAM ───────────────────────────────────────────────────────
  void _listenMenus() {
    isLoading.value = true;
    _sb
        .from('menus')
        .stream(primaryKey: ['id'])
        .order('rank')
        .listen((rows) async {
          final list = rows.map(MenuItem.fromJson).toList();
          await Future.wait(list.map(_loadMenuExtras));
          menus.value = list;
          isLoading.value = false;
        });
  }

  Future<void> _loadMenuExtras(MenuItem m) async {
    // --- ingredients ---
    final iRows = await _sb
        .from('menu_ingredients')
        .select()
        .eq('menu_id', m.id);
    m.ingredients = (iRows as List)
        .map((r) => MenuIngredient.fromJson(r as Map<String, dynamic>))
        .toList();

    // --- HPP result terbaru ---
    final hRows = await _sb
        .from('hpp_results')
        .select()
        .eq('menu_id', m.id)
        .order('created_at', ascending: false)
        .limit(1);
    if ((hRows as List).isNotEmpty) {
      final h = hRows.first as Map<String, dynamic>;
      m.hppPerPorsi = (h['hpp_per_porsi'] as num).toDouble();
      m.rekomendasiHarga = (h['rekomendasi_harga'] as num).toDouble();
      m.totalModal = (h['total_modal'] as num).toDouble();
    }
  }

  // ── SET ACTIVE MENU ───────────────────────────────────────────────────────
  void setActiveMenu(MenuItem menu) {
    activeMenu.value = menu;
  }

  Future<void> refreshMenuHpp({
    required String menuId,
    required double hpp,
    required double rekomendasi,
    required double modal,
  }) async {
    final idx = menus.indexWhere((m) => m.id == menuId);
    if (idx < 0) return;
    menus[idx].hppPerPorsi = hpp;
    menus[idx].rekomendasiHarga = rekomendasi;
    menus[idx].totalModal = modal;
    menus.refresh();
    if (activeMenu.value?.id == menuId) {
      activeMenu.value!.hppPerPorsi = hpp;
      activeMenu.value!.rekomendasiHarga = rekomendasi;
      activeMenu.value!.totalModal = modal;
      activeMenu.refresh();
    }
  }

  // ── CRUD ──────────────────────────────────────────────────────────────────

  /// TAMBAH MENU DENGAN QTY PER BAHAN
  Future<void> addMenu({
    required String name,
    required double hargaJual,
    required int targetPorsi,
    required List<String> inventoryItemIds,
    required List<double> qtyNeededList, // 🔥 PARAMETER BARU
    String imagePath = 'assets/images/food_ai.jpg',
    String level = 'Populer',
  }) async {
    final rank = menus.length + 1;

    // 1. Insert menu
    final res = await _sb.from('menus').insert({
      'name': name,
      'image_path': imagePath,
      'harga_jual': hargaJual,
      'target_porsi': targetPorsi,
      'level': level,
      'rank': rank,
    }).select().single();

    final menuId = res['id'] as String;

    // 2. Insert menu_ingredients dengan qty_needed yang benar
    if (inventoryItemIds.isNotEmpty) {
      final ingredients = <Map<String, dynamic>>[];
      for (int i = 0; i < inventoryItemIds.length; i++) {
        final qty = i < qtyNeededList.length ? qtyNeededList[i] : 0.1;
        ingredients.add({
          'menu_id': menuId,
          'inventory_item_id': inventoryItemIds[i],
          'qty_needed': qty,
        });
      }
      await _sb.from('menu_ingredients').insert(ingredients);
    }

    // ✅ 3. Catat log SETELAH semua insert sukses
    await ActivityLogService.log(
      type: 'tambah_menu',
      title: 'Menu baru ditambahkan',
      description: name,
    );
  }

  Future<void> deleteMenu(String menuId) async {
    // ✅ Ambil nama menu SEBELUM dihapus dari database & state
    final menuIndex = menus.indexWhere((m) => m.id == menuId);
    final menuName =
        menuIndex >= 0 ? menus[menuIndex].name : 'Menu tidak dikenal';

    await _sb.from('menu_ingredients').delete().eq('menu_id', menuId);
    await _sb.from('hpp_results').delete().eq('menu_id', menuId);
    await _sb.from('menus').delete().eq('id', menuId);
    if (activeMenu.value?.id == menuId) activeMenu.value = null;

    // ✅ Catat log SETELAH delete sukses
    await ActivityLogService.log(
      type: 'hapus_menu',
      title: 'Menu dihapus',
      description: menuName,
    );
  }
}
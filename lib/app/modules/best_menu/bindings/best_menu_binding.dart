import 'package:get/get.dart';

import '../controllers/best_menu_controller.dart';
import '../../inventory/controllers/inventory_controller.dart';

class BestMenuBinding extends Bindings {
  @override
  void dependencies() {
    // Pastikan InventoryController sudah ada
    // (karena BestMenuView butuh daftar bahan dari inventory)
    Get.put<InventoryController>(InventoryController(), permanent: true);
    Get.lazyPut<BestMenuController>(() => BestMenuController(), fenix: true);
  }
}

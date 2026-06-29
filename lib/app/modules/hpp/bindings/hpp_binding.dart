import 'package:get/get.dart';

import '../controllers/hpp_controller.dart';
import '../../best_menu/controllers/best_menu_controller.dart';
import '../../inventory/controllers/inventory_controller.dart';

class HppBinding extends Bindings {
  @override
  void dependencies() {
    // HppController butuh BestMenuController (activeMenu)
    // dan InventoryController (hargaNasional)
    Get.put<InventoryController>(InventoryController(), permanent: true);
    Get.put<BestMenuController>(BestMenuController(), permanent: true);
    Get.lazyPut<HppController>(() => HppController(), fenix: true);
  }
}

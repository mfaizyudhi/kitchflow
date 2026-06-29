import 'package:get/get.dart';

import '../controllers/production_controller.dart';
import '../../best_menu/controllers/best_menu_controller.dart';
import '../../hpp/controllers/hpp_controller.dart';
import '../../inventory/controllers/inventory_controller.dart';

class ProductionBinding extends Bindings {
  @override
  void dependencies() {
    // Production butuh semua controller di bawah ini
    Get.put<InventoryController>(InventoryController(), permanent: true);
    Get.put<BestMenuController>(BestMenuController(), permanent: true);
    Get.put<HppController>(HppController(), permanent: true);
    Get.lazyPut<ProductionController>(() => ProductionController(), fenix: true);
  }
}

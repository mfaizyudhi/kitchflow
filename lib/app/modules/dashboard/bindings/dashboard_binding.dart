import 'package:get/get.dart';
import 'package:kitchflow/app/modules/dashboard/controllers/dashboard_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../../best_menu/controllers/best_menu_controller.dart';
import '../../hpp/controllers/hpp_controller.dart';
import '../../inventory/controllers/inventory_controller.dart';
import '../../production/controllers/production_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<InventoryController>(InventoryController(), permanent: true);
    Get.put<BestMenuController>(BestMenuController(), permanent: true);
    Get.put<HppController>(HppController(), permanent: true);
    Get.put<ProductionController>(ProductionController(), permanent: true);
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}

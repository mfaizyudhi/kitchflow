import 'package:get/get.dart';

import '../controllers/analytics_controller.dart';
import '../../best_menu/controllers/best_menu_controller.dart';
import '../../../../controllers/models/sales_controller.dart';

class AnalyticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnalyticsController>(
      () => AnalyticsController(),
    );
    Get.lazyPut<BestMenuController>(
      () => BestMenuController(),
    );
    Get.lazyPut<SalesController>(
      () => SalesController(),
    );
  }
}
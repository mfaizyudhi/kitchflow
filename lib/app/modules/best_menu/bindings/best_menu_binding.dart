import 'package:get/get.dart';

import '../controllers/best_menu_controller.dart';

class BestMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BestMenuController>(
      () => BestMenuController(),
    );
  }
}

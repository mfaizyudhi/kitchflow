import 'package:get/get.dart';

import '../controllers/production_controller.dart';

class ProductionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductionController>(
      () => ProductionController(),
    );
  }
}

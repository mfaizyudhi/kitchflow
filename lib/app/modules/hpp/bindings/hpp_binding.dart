import 'package:get/get.dart';

import '../controllers/hpp_controller.dart';

class HppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HppController>(
      () => HppController(),
    );
  }
}

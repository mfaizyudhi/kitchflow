import 'package:get/get.dart';

import '../controllers/tambah_bahan_controller.dart';

class TambahBahanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahBahanController>(
      () => TambahBahanController(),
    );
  }
}

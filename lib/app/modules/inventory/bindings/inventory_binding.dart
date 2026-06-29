import 'package:get/get.dart';

import '../controllers/inventory_controller.dart';

class InventoryBinding extends Bindings {
  @override
  void dependencies() {
    // permanent: true supaya data stok tetap ada
    // saat navigasi ke HPP atau Production
    Get.lazyPut<InventoryController>(
      () => InventoryController(),
      fenix: true,  // ← restart otomatis kalau di-dispose
    );
  }
}

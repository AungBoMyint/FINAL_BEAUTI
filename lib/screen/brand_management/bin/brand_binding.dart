import 'package:get/get.dart';

import '../controller/brand_controller.dart';

class BrandBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BrandController());
  }
}

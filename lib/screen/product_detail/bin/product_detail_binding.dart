import 'package:get/get.dart';
import 'package:kozarni_ecome/screen/product_detail/controller/product_detail_controller.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductDetailController());
  }
}

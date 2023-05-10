import 'package:get/get.dart';
import 'package:kozarni_ecome/screen/division/controller/division_controller.dart';

class DivisionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DivisionController());
  }
}

import 'package:get/get.dart';
import '../../../controller/home_controller.dart';
import '../../../data/constant.dart';
import '../../../model/advertisement.dart';
import '../../../service/database.dart';
import '../../../widgets/show_loading/show_loading.dart';

class AdvertisementController2 extends GetxController {
  final Advertisement? advertisement;
  final _database = Database();
  AdvertisementController2(this.advertisement);
  HomeController _homeController = Get.find();
  RxMap<String, String> advertisementProductMap = <String, String>{}.obs;
  var currentCategory = "All".obs;

  @override
  void onInit() {
    if (!(advertisement == null)) {
      //If advertisement is not null,we need to
      //search and add the products which include in this advertisement
      _homeController.items.forEach((element) {
        if (element.id == advertisement?.id) {
          advertisementProductMap.putIfAbsent(element.id, () => element.id);
        }
      });
    }
    super.onInit();
  }

  void changeCategory(String value) {
    currentCategory.value = value;
  }

  void addOrRemove(String productID) {
    if (advertisementProductMap.containsKey(productID)) {
      advertisementProductMap.remove(productID);
    } else {
      advertisementProductMap.putIfAbsent(productID, () => productID);
    }
  }

  Future<void> deleteAdvertisement(String id) async {
    showLoading();
    await _database.delete(advertisementCollection2, path: id);
    hideLoading();
    Get.back();
  }

  Future<void> saveAdvertisement(Advertisement advertisement) async {
    showLoading();
    await _database.write(advertisementCollection2,
        data: advertisement.toJson(), path: advertisement.id);
    hideLoading();
    Get.back();
  }
}

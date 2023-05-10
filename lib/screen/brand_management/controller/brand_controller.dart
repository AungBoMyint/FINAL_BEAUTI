import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kozarni_ecome/data/constant.dart';
import 'package:uuid/uuid.dart';
import '../../../model/brand.dart';
import '../../../model/product.dart';
import '../../../service/database.dart';
import '../../../widgets/show_loading/show_loading.dart';

class BrandController extends GetxController {
  final _database = Database();
  RxList<Brand> brandList = <Brand>[].obs;
  RxList<Product> productList = <Product>[].obs;
  RxMap<String, Product> selectedProductsMap = <String, Product>{}.obs;
  RxMap<String, Product> removedProductsMap = <String, Product>{}.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController subNameController = TextEditingController();

  final TextEditingController statusController = TextEditingController();
  var isFirstTimePressed = false.obs;
  //Error
  var pickImageError = "".obs;
  var selectedShopIdError = "".obs;
  //
  var pickedImage = "".obs;

  //Loading for bottomsheet
  var removeProductLoading = false.obs;
  var addProductLoading = false.obs;

  //*********For Andding , Subtracting Products */
  void addIntoRemoveMap(Product p) {
    removedProductsMap.putIfAbsent(p.id, () => p);
  }

  void selectProductOrNot(Product product) {
    log("******selected product or not");
    if (!selectedProductsMap.containsKey(product.id)) {
      selectedProductsMap.putIfAbsent(product.id, () => product);
    }
  }

  String? validate(String? value, String label) {
    if (!(value == null) && value.isNotEmpty) {
      return null;
    } else {
      return "$label is required";
    }
  }

  void clearAll() {
    nameController.clear();
    subNameController.clear();
    statusController.clear();
    pickedImage.value = "";
  }

  Future<void> delete(String id) async {
    await _database.delete(
      brandCollection,
      path: id,
    );
  }

  Future<void> save() async {
    isFirstTimePressed.value = true;
    if (pickedImage.isEmpty) {
      pickImageError.value = "Image is required.";
    }

    if (formKey.currentState?.validate() == true && pickedImage.isNotEmpty) {
      showLoading();
      try {
        await FirebaseStorage.instance
            .ref()
            .child("brands/${Uuid().v1()}")
            .putFile(File(pickedImage.value))
            .then((snapshot) async {
          await snapshot.ref.getDownloadURL().then((value) async {
            final ad = Brand(
              id: Uuid().v1(),
              image: value,
              name: nameController.text,
              dateTime: DateTime.now(),
            );
            await _database.write(
              brandCollection,
              path: ad.id,
              data: ad.toJson(),
            );
            isFirstTimePressed.value = false;
            clearAll();
          });
        });
      } catch (e) {
        Get.snackbar("Failed!", "Try Again");
        debugPrint("****$e");
      }
      hideLoading();
    }
  }

  pickImage() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      pickedImage.value = image?.path ?? "";
      pickImageError.value = "";
    } catch (e) {
      debugPrint("Error Bank Slip Image Picking");
    }
  }

  @override
  void onInit() {
    super.onInit();
    FirebaseFirestore.instance
        .collection(brandCollection)
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        brandList.value =
            event.docs.map((e) => Brand.fromJson(e.data())).toList();
      }
    });
  }
}

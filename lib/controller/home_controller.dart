import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:kozarni_ecome/model/advertisement.dart';
import 'package:kozarni_ecome/model/category.dart' as Cate;
import 'package:image_picker/image_picker.dart';
import 'package:kozarni_ecome/data/constant.dart';
import 'package:kozarni_ecome/data/enum.dart';
import 'package:kozarni_ecome/model/division.dart';
import 'package:kozarni_ecome/model/hive_item.dart';
import 'package:kozarni_ecome/model/product.dart';
import 'package:kozarni_ecome/model/tag.dart';
import 'package:kozarni_ecome/model/user.dart';
import 'package:kozarni_ecome/model/view_all_model.dart';
import 'package:kozarni_ecome/service/api.dart';
import 'package:kozarni_ecome/service/auth.dart';
import 'package:kozarni_ecome/service/database.dart';
import 'package:kozarni_ecome/widgets/show_dialog/show_dialog.dart';
import 'package:kozarni_ecome/widgets/show_loading/show_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../model/brand.dart';
import '../model/hive_purchase.dart';
import '../model/hive_purchase_item.dart';
import '../model/promotion.dart';
import '../model/promotion_type.dart';
import '../model/purchase_item.dart';
import '../model/real_purchase.dart';
import '../model/status.dart';
import '../routes/routes.dart';

class HomeController extends GetxController {
  final Auth _auth = Auth();
  final Database _database = Database();
  final Api _api = Api();
  final ImagePicker _imagePicker = ImagePicker();
  Rxn<AuthUser?> currentUser = Rxn<AuthUser?>(null);
///////////////////////////For View All Screen////////////////////////////////
  ViewAllModel viewAllModel = ViewAllModel.empty();
  RxMap<String, dynamic> myCartMap = <String, dynamic>{}.obs;
  void setViewAllProducts(ViewAllModel value) {
    viewAllModel = value;
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
  final RxBool authorized = false.obs;
  var slideLoading2 = true.obs;
  final RxBool phoneState = false.obs;
  final codeSentOnWeb = false.obs; //codeSentOnWeb on Web
  final TextEditingController _phoneCodeController =
      TextEditingController(); //On Web
  late SharedPreferences
      sharedPref; //Share Preference to Store User's Order Data
  String? townshipName; //Township Name
  var paymentOptions = PaymentOptions.None.obs; //Payment Option Initial Value
  var checkOutStep = 0.obs; //Check Out Step
  var bankSlipImage = "".obs;
  Map<String, dynamic> townShipNameAndFee = {}; //Township Name and Fee

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController verificationController = TextEditingController();

  final RxString _codeSentId = ''.obs;
  final RxInt _codeSentToken = 0.obs;
  Box<HivePurchase> purchaseHiveBox = Hive.box(purchaseBox);
  final RxList<PurchaseItem> myCart = <PurchaseItem>[].obs;

  bool isOwnBrand = false;
  int mouseIndex = -1; //Mouse Region

  final RxList<Cate.Category> categories = <Cate.Category>[].obs;
  final RxList<Status> statusList = <Status>[].obs;
  final RxList<Brand> brandList = <Brand>[].obs;
  final RxList<Advertisement> advertisementList = <Advertisement>[].obs;
  final RxList<Advertisement> advertisementList2 = <Advertisement>[].obs;

  final RxList<Tag> tagsList = <Tag>[].obs;
  final RxList<Division> divisionList = <Division>[].obs;
  var firstTimePressedCart = false.obs;

  var purchaseId = "".obs;
  void setPurchaseId(String id) {
    if (purchaseId.value == id) {
      purchaseId.value = "";
    } else {
      purchaseId.value = id;
    }
  }

  bool checkToAcceptOrder() {
    if (myCart.isEmpty) {
      Get.snackbar('Error', "Cart is empty");
      return false;
    } else if (townShipNameAndFee.isEmpty) {
      Get.snackbar('Error', "Need to choose a township");
      firstTimePressedCart.value = true;
      return false;
    } else {
      return true;
    }
  }

  List<Cate.Category> getSubcategoryByMainId(String value) {
    return categories.where((e) => e.mainId == value).toList();
  }

  final RxList<Promotion> promotionList = <Promotion>[].obs;

  List<Product> getAdvertisementsProductList(Map<String, String> productMap) {
    List<Product> resultList = [];
    for (var item in items) {
      if (productMap.containsKey(item.id)) {
        resultList.add(item);
      }
    }
    return resultList;
  }

  Future<void> addPromotion(Promotion promotion) async {
    showLoading();
    await _database.write(promotionCollection,
        data: promotion.toJson(), path: promotion.id);
    hideLoading();
    Get.back();
  }

  Future<void> deletePromotion(String promotionID) async {
    showLoading();
    await _database.delete(promotionCollection, path: promotionID);
    hideLoading();
    Get.back();
  }

  Future<void> addCategory(Cate.Category cate) async {
    showLoading();
    await _database.write(categoryCollection,
        data: cate.toJson(), path: cate.id);
    hideLoading();
    Get.back();
  }

  Future<void> deleteCategory(String cateID) async {
    showLoading();
    await _database.delete(categoryCollection, path: cateID);
    hideLoading();
    Get.back();
  }

  Future<void> addStatus(Status status) async {
    showLoading();
    await _database.write(statusCollection,
        data: status.toJson(), path: status.id);
    hideLoading();
    Get.back();
  }

  Future<void> deleteStatus(String statusID) async {
    showLoading();
    await _database.delete(statusCollection, path: statusID);
    hideLoading();
    Get.back();
  }

  Future<void> addAdvertisement(Advertisement advertisement) async {
    showLoading();
    await _database.write(advertisementCollection,
        data: advertisement.toJson(), path: advertisement.id);
    hideLoading();
    Get.back();
  }

  Future<void> deleteAdvertisement(String adID) async {
    showLoading();
    await _database.delete(advertisementCollection, path: adID);
    hideLoading();
    Get.back();
  }

  Future<void> addTag(Tag tag) async {
    showLoading();
    await _database.write(tagsCollection, data: tag.toJson(), path: tag.id);
    hideLoading();
    Get.back();
  }

  Future<void> deleteTag(String tagID) async {
    showLoading();
    await _database.delete(tagsCollection, path: tagID);
    hideLoading();
    Get.back();
  }

  void changeMouseIndex(int i) {
    // Change Mouse Region
    mouseIndex = i;
    log("On Mouse Exist************");
    update();
  }

  //Chage OwnBand
  void changeOwnBrandOrNot(bool value, bool isUpdate) {
    isOwnBrand = value;
    if (isUpdate) {
      update();
    }
  }

  //Set Shipping Fee
  void setTownshipName(String? val) {
    townshipName = val!;
    update();
  }

  //Set Township Name
  void setTownShipNameAndShip({required String name, required String fee}) {
    townShipNameAndFee = {
      "townName": name,
      "fee": int.parse(fee),
    };
    update();
  }

  //Change Payment Option
  void changePaymentOptions(PaymentOptions option) {
    paymentOptions.value = option;
  }

  //Change Step Index
  void changeStepIndex(int value) {
    checkOutStep.value = value;
  }

  //Set Bank Slip Image
  void setBankSlipImage(String image) {
    bankSlipImage.value = image;
  }

  void addToCart(Product product,
      {String? color, List<String>? size, required int price}) {
    log("********current user point inside addToCart: $price*******");
    if (product.requirePoint! > 0 && isCanAdd(product.requirePoint!)) {
      currentUserPoint = currentUserPoint - (product.requirePoint! * 1);
    } else if (product.requirePoint! > 0 && !isCanAdd(product.requirePoint!)) {
      showNotEnoughPoint();
      return;
    }
    try {
      final PurchaseItem _item = myCart.firstWhere(
        //--if already exist--//
        (item) =>
            item.id == product.id &&
            item.color == color &&
            item.size == size?[0],
      );
      myCart.value = myCart.map((element) {
        if (_item.id == element.id &&
            _item.color == element.color &&
            _item.size == element.size) {
          return element.copyWith(
            count: element.count + 1,
          );
        }
        return element;
      }).toList();
    } catch (e) {
      log("NEW PRICE: ${price}");
      myCartMap.putIfAbsent(product.id, () => 1);
      myCart.add(//-----For new product that doesn't already exist before----//
          PurchaseItem(
        id: product.id,
        itemName: product.name,
        count: 1,
        size: size?[0],
        color: color,
        price: price,
        discountPrice: product.discountPrice,
        requirePoint: product.requirePoint,
        remainQuantity: product.remainQuantity,
      ));
    }
  }

  final RxList<Product> items = <Product>[].obs;
  // final RxList<Product> brandItems = <Product>[].obs; //Brand Item
  // final RxList<Product> exportAndBrandItems = <Product>[].obs;
  final RxList<Product> searchitems = <Product>[].obs;

  //set export and brand items when edit page start
  /*void setExportAndBrandItems() {
    exportAndBrandItems.value = [];
    items.forEach((element) {
      exportAndBrandItems.add(element);
    });
    brandItems.forEach((element) {
      exportAndBrandItems.add(element);
    });
  }*/

  final Rxn<Product?> selectedItem = Rxn<Product?>(null);

  void setSelectedItem(Product item) {
    selectedItem.value = item;
  }

  final Rxn<Product?> editItem = Rxn<Product?>(null);
  void setEditItem(Product? product) {
    editItem.value = product;
  }

  Product? getItem(String id) {
    try {
      return items.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Product> getItems() => category.value == 'All'
      ? items
      : items.where((e) => e.category == category.value).toList();

  List<String> categoryList() {
    final List<String> _data = [
      'All',
    ];

    for (var i = 0; i < items.length; i++) {
      if (!_data.contains(items[i].category)) {
        _data.add(items[i].category);
      }
    }

    if (items.isEmpty) {
      _data.clear();
    }
    return _data;
  }

  //Brand Category List
  List<String> brandCategoryList() {
    final List<String> _data = [
      'All',
    ];

    return _data;
  }

  // List<ItemModel> pickUp() =>
  //     items.where((e) => e.category == 'New Products').toList();

  List<Product> hot() => items.where((e) => e.category == hotSale).toList();

  void removeItem(String id) => items.removeWhere((item) => item.id == id);

  //int shipping() => myCart.isEmpty ? 0 : shippingFee;

  void addCount(PurchaseItem p) {
    if (!(p.remainQuantity == null) && (p.count >= (p.remainQuantity ?? 0))) {
      Get.snackbar("Fail!", "Out of stock.");
      return;
    }

    myCart.value = myCart.map((element) {
      if (element.id == p.id &&
          element.color == p.color &&
          element.size == p.size) {
        if (element.requirePoint! > 0) {
          currentUserPoint = currentUserPoint - (element.requirePoint! * 1);
        }
        return element.copyWith(count: element.count + 1);
      }
      return element;
    }).toList();
    update([myCart]);
    updateSubTotal(true);
  }

  void remove(PurchaseItem p) {
    bool needToRemove = false;
    myCart.value = myCart.map((element) {
      if (element.id == p.id &&
          element.color == p.color &&
          element.size == p.size) {
        if (element.count > 1) {
          if (element.requirePoint! > 0) {
            currentUserPoint = currentUserPoint + (element.requirePoint! * 1);
          }
          return element.copyWith(count: element.count - 1);
        }
        needToRemove = true;
        return element;
      }
      return element;
    }).toList();
    if (needToRemove) {
      myCartMap.remove(p.id);
      myCart.removeWhere((element) =>
          element.id == p.id &&
          element.color == p.color &&
          element.size == p.size);
    }
    updateSubTotal(true);
  }

  int subTotal = 0;
  Rxn<Either<None, PromotionType>> promotionType =
      Rxn<Either<None, PromotionType>>(right(PromotionType.nothing()));
  var promotionObxValue = 0.obs;
  void updateSubTotal(bool isUpdate, {String? promotionValue = ""}) {
    log("*********PromotionCode: $promotionValue");
    try {
      final pro = promotionList
          .where((e) => e.code == promotionValue)
          .first
          .promotionValue;
      //we check this is percentage or money
      if (pro.contains("%")) {
        //this is percentage
        promotionObxValue.value = int.tryParse(pro.split("%").first) ?? 0;
        promotionType.value = right(PromotionType.percentage());
      } else {
        promotionObxValue.value = int.tryParse(pro.split("ks").first) ?? 0;
        promotionType.value = right(PromotionType.money());
      }
    } catch (e) {
      promotionObxValue.value = 0;
      promotionType.value = right(PromotionType.nothing());
    }
    // promotionObxValue.value = promotionValue!.isEmpty ? 0 :
    // promotionList.where((e) => e.id == promotionValue).first.promotionValue;
    if (subTotal != 0) {
      subTotal = 0;
    }
    int price = 0;
    for (var i = 0; i < myCart.length; i++) {
      if (myCart[i].discountPrice! > 0) {
        //-----for discount products----//
        price += myCart[i].discountPrice! * myCart[i].count;
      } else if (!(myCart[i].requirePoint! > 0)) {
        //---for normal products----//
        price += myCart[i].price * myCart[i].count;
      }
    }
    subTotal = price;
    log("*************$subTotal");
    if (isUpdate) {
      update();
    }
  }

  //Get HiveItem
  HiveItem changeHiveItem(Product model) {
    return HiveItem(
      id: model.id,
      photo1: model.photo1,
      photo2: model.photo2,
      photo3: model.photo3,
      name: model.name,
      description: model.description,
      price: model.price,
      size: "",
      color: model.color,
      status: model.status,
      category: model.category,
      tags: model.tags,
      dateTime: model.dateTime,
      discountPrice: model.discountPrice ?? 0,
      love: model.love ?? 0,
      comment: model.comment ?? [],
      deliveryTime: model.deliveryTime,
      requirePoint: model.requirePoint ?? 0,
      advertisementID: model.advertisementID,
      brandName: model.brandName ?? "",
    );
  }

  //Get ItemModel
  Product changeItemModel(HiveItem model) {
    return Product(
      id: model.id,
      photo1: model.photo1,
      photo2: model.photo2,
      photo3: model.photo3,
      name: model.name,
      description: model.description,
      price: model.price,
      size: items.where((p) => p.id == model.id).first.size,
      color: model.color,
      status: model.status,
      category: model.category,
      tags: model.tags,
      dateTime: model.dateTime,
      discountPrice: model.discountPrice,
      love: model.love,
      comment: model.comment,
      deliveryTime: model.deliveryTime,
      requirePoint: model.requirePoint,
      advertisementID: model.advertisementID,
      brandName: model.brandName,
    );
  }

  final RxList<PurchaseModel> _purchcases = <PurchaseModel>[].obs; ////

  List<PurchaseModel> purchcasesCashOn() {
    return _purchcases.where((item) => item.bankSlipImage == null).toList();
  }

  List<PurchaseModel> purchcasesPrePay() {
    return _purchcases.where((item) => item.bankSlipImage != null).toList();
  } //////////////////

  final RxBool isLoading = false.obs;

  Future<void> proceedToPay() async {
    showLoading();
    final total = subTotal + townShipNameAndFee["fee"] as int;
    try {
      final list = getUserOrderData();
      final _purchase = PurchaseModel(
        total: total,
        promotionValue: promotionType.value!.fold(
          (r) => "0",
          (l) => l.map(
            nothing: (_) => "0",
            money: (_) => "${promotionObxValue.value}",
            percentage: (_) => "${promotionObxValue.value}%",
          ),
        ),
        dateTime: DateTime.now().toString(),
        id: Uuid().v1(),
        items: myCart.map((cart) => cart).toList(),
        name: list[0],
        email: list[1],
        phone: list[2],
        address: list[3],
        bankSlipImage: bankSlipImage.value.isEmpty ? null : bankSlipImage.value,
        deliveryTownshipInfo: [
          townShipNameAndFee["townName"],
          townShipNameAndFee["fee"]
        ],
      );
      final hivePurchase = HivePurchase(
        id: Uuid().v1(),
        items: _purchase.items
            .map((e) => HivePurchaseItem(
                  itemName: e.itemName,
                  count: e.count,
                  size: e.size,
                  color: e.color,
                  price: e.price,
                  discountPrice: e.discountPrice,
                  requirePoint: e.requirePoint,
                ))
            .toList(),
        totalPrice: (subTotal - promotionObxValue.value) +
            townShipNameAndFee["fee"] as int,
        deliveryTownshipInfo: _purchase.deliveryTownshipInfo,
        dateTime: DateTime.now(),
      );
      await _database.writePurchaseData(_purchase).then((value) {
        hideLoading();
        Get.back();
        Get.snackbar("လူကြီးမင်း Order တင်ခြင်း", 'အောင်မြင်ပါသည်');
        purchaseHiveBox.put(hivePurchase.id, hivePurchase);
      }); //submit success
      myCart.clear();
      navIndex.value = 0;
      update([myCart, navIndex]);
      myCart.clear();
    } catch (e) {
      Get.snackbar("လူကြီးမင်း Order တင်ခြင်း", 'မအောင်မြင်ပါ');
      print("proceed to pay error $e");
    }
    //Get.back();
    isLoading.value = false;
  }

  /* Future<void> login() async {
    try {
      if (_codeSentId.value.isNotEmpty || phoneState.value) {
        await confirm();
        return;
      }
      //Change method base on Platform Conditionally
      if (kIsWeb) {
        log("Web Sign In"); //Debug Print
        //web login
        await _auth.loginInWeb(
          phoneNumber: phoneController.text,
          enterCode: (callBack) => showDialogToEnterPhoneCode(
            (phoneCode) => callBack(phoneCode),
          ),
        ); //FOR WEB SIGNIN WITH PHONE
      } else {
        await _auth.login(
          phoneNumber: phoneController.text,
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
          codeAutoRetrievalTimeout: (String verificationId) {},
          codeSent: (String verificationId, int? forceResendingToken) {
            _codeSentId.value = verificationId;
            _codeSentToken.value = forceResendingToken ?? 0;
            update([_codeSentId, _codeSentToken]);
          },
          verificationFailed: (FirebaseAuthException error) {},
        );
        phoneState.value = true;
      }
    } catch (e) {
      print("login error $e");
    }
  }
 */
  Future<void> confirm() async {
    try {
      await _auth.loginWithCerdential(PhoneAuthProvider.credential(
        verificationId: _codeSentId.value,
        smsCode: verificationController.text,
      ));
      _codeSentId.value = '';
      phoneState.value = false;
      phoneController.clear();
      verificationController.clear();
    } catch (e) {
      _codeSentId.value = '';
      Get.snackbar('', '',
          backgroundColor: Colors.red,
          messageText: Text("Try Again!",
              style: TextStyle(
                color: Colors.white,
              )));
      print("******confirm error is $e");
    }
  }

  Future<void> logout() async {
    try {
      await _auth.logout();
    } catch (e) {
      print("logout error is $e");
    }
  }

  // Future<void> uploadProfile() async {
  //   try {
  //     final XFile? _file =
  //         await _imagePicker.pickImage(source: ImageSource.gallery);

  //     if (_file != null) {
  //       await _api.uploadFile(
  //         _file.path,
  //         fileName: user.value.user?.uid,
  //         folder: profileUrl,
  //       );
  //       await _database.write(
  //         profileCollection,
  //         data: {
  //           'link': user.value.user?.uid,
  //         },
  //         path: user.value.user?.uid,
  //       );
  //       user.value.update(
  //         newProfileImage: '$baseUrl$profileUrl${user.value.user?.uid}',
  //       );
  //       update([user]);
  //     }
  //   } catch (e) {
  //     print("profile upload error $e");
  //   }
  // }

  //Get User's Order Data
  List<String> getUserOrderData() {
    return sharedPref.getStringList("userOrder") ?? [];
  }

  //Set User's Order Data or Not
  Future<void> setUserOrderData({
    required String name,
    required String email,
    required String phone,
    required String address,
  }) async {
    //Making Purchase Model
    try {} catch (e) {}
    final list = getUserOrderData();
    //Check data already contain with the same data inside SharedPreference
    if (list.isEmpty) {
      await sharedPref
          .setStringList("userOrder", [name, email, phone, address]);
    } else if ( //Something is changed by User,then we restore
        (name != list[0]) ||
            (email != list[1]) ||
            (phone != list[2]) ||
            (address != list[3])) {
      await sharedPref
          .setStringList("userOrder", [name, email, phone, address]);
    }
  }

  //Loading Font to not take time when user in App to this font
  late ByteData oleoBold;
  late ByteData cherryUnicode;
  var isSubscribeToTopic = false.obs;
  @override
  void onInit() async {
    super.onInit();
    oleoBold = await rootBundle.load("fonts/OleoScriptSwashCaps-Bold.ttf");
    cherryUnicode = await rootBundle.load("fonts/Cherry_Unicode.ttf");
    sharedPref = await SharedPreferences.getInstance();
    if (getUserOrderData().isNotEmpty) {
      checkOutStep.value = 1;
    } // SharedPreference to Stroe
    _database.watch(itemCollection).listen((event) {
      items.value = event.docs.map((e) => Product.fromJson(e.data())).toList();
      refreshTotalProductAndRemainProduct();
    });
    //Listening Division List
    _database.watch(divisionCollection).listen((event) {
      log("Division List: ${event.docs.length} ****");
      divisionList.value =
          event.docs.map((e) => Division.fromJson(e.data())).toList();
    });

    _database.watchOrder(purchaseCollection).listen((event) {
      if (event.docs.isEmpty) {
        _purchcases.clear();
      } else {
        _purchcases.value =
            event.docs.map((e) => PurchaseModel.fromJson(e.data())).toList();
      }
    });
    _database.watch(advertisementCollection).listen((event) {
      if (event.docs.isEmpty) {
        advertisementList.clear();
      } else {
        advertisementList.value =
            event.docs.map((e) => Advertisement.fromJson(e.data())).toList();
      }
    });
    _database.watch(advertisementCollection2).listen((event) {
      slideLoading2.value = false;
      if (event.docs.isEmpty) {
        advertisementList2.clear();
      } else {
        advertisementList2.value =
            event.docs.map((e) => Advertisement.fromJson(e.data())).toList();
      }
    });
    _database.watch(statusCollection).listen((event) {
      if (event.docs.isEmpty) {
        statusList.clear();
      } else {
        statusList.value =
            event.docs.map((e) => Status.fromJson(e.data())).toList();
      }
    });
    //brand
    _database.watch(brandCollection).listen((event) {
      if (event.docs.isEmpty) {
        brandList.clear();
      } else {
        brandList.value =
            event.docs.map((e) => Brand.fromJson(e.data())).toList();
      }
    });
    //
    _database.watch(categoryCollection).listen((event) {
      if (event.docs.isEmpty) {
        categories.clear();
      } else {
        categories.value =
            event.docs.map((e) => Cate.Category.fromJson(e.data())).toList();
      }
    });
    _database.watch(tagsCollection).listen((event) {
      if (event.docs.isEmpty) {
        tagsList.clear();
      } else {
        tagsList.value = event.docs.map((e) => Tag.fromJson(e.data())).toList();
      }
    });
    _database.watch(promotionCollection).listen((event) {
      if (event.docs.isEmpty) {
        promotionList.clear();
      } else {
        promotionList.value =
            event.docs.map((e) => Promotion.fromJson(e.data())).toList();
      }
    });

    //-----------------------On Auth Change-------------------------------//
    _auth.onAuthChange().listen((user) async {
      if (user == null) {
        currentUser.value = null;
      } else {
        log("*******user is not null****");
        //we need to check document reference is already defined
        final snapshot = await FirebaseFirestore.instance
            .collection(adminUserCollection)
            .doc(user.uid)
            .get();
        if (!snapshot.exists) {
          //If not define before
          log("******Document is not exist so,we write to firebase"
              "because this user is completely new user.");
          currentUser.value = AuthUser(
            id: user.uid,
            emailAddress: user.email ?? "",
            userName: user.displayName ?? "",
            image: user.photoURL ?? "",
            points: 0,
          );
          await _database.write(
            adminUserCollection,
            path: currentUser.value!.id,
            data: currentUser.value!.toJson(),
          );
        }

        //-----------we watch this current user's document-----------//
        FirebaseFirestore.instance
            .collection(adminUserCollection)
            .doc(user.uid)
            .snapshots()
            .listen((event) async {
          log("****UserEvent: ${event.data()}");
          currentUser.value = AuthUser.fromJson(event.data()!);
          currentUserPoint = currentUser.value!.points;
          log("************current user points: $currentUserPoint*********");
          if (!(currentUser.value == null) &&
              (currentUser.value!.status! > 0) &&
              !isSubscribeToTopic.value) {
            //This is Admin,so we need to do admin related functions
            //SubscribeToTopic,UnsubscribeToTopic is required becuase
            //Firebase has rate-limited per project. If you send too many
            //subscription requests in a short period of time,
            //FCM servers will respond with a 429 RESOURCE_EXHAUSTED ("quota exceeded") response,
            //So we should check and shouldn't change user's status many time
            //to prevent happening undesire "quota-exceeded" response.
            await FirebaseMessaging.instance.subscribeToTopic('order');
            isSubscribeToTopic.value = true;
            log("SubscribeToTopic: $isSubscribeToTopic ...");
          } else if (currentUser.value!.status! == 0 &&
              isSubscribeToTopic.value) {
            isSubscribeToTopic.value = false;
            await FirebaseMessaging.instance.unsubscribeFromTopic('order');
            log("SubscribeToTopic: $isSubscribeToTopic ...");
          } else {
            log("Nothing do sbscribe to topic..");
          }
        });

        // final DocumentSnapshot<Map<String, dynamic>> _data =
        //     await _database.read(userCollection, path: _.uid);
        // user.value = user.value.update(
        //   newIsAdmin: _data.exists,
        // );
        // final DocumentSnapshot<Map<String, dynamic>> _profile =
        //     await _database.read(profileCollection, path: _.uid);
        // user.value = user.value.update(
        //   newProfileImage: _profile.data()?['link'],
        // );
        // if (user.value.isAdmin) {
      }
      //}
    });

    //Listen BlueTooth State
    /*blueToothPrint.state.listen((event) {
      switch (event) {
        case BluetoothPrint.CONNECTED:
          Get.showSnackbar(GetBar(message: "Connected"));
          break;
        case BluetoothPrint.DISCONNECTED:
          Get.showSnackbar(GetBar(message: "Disconnected"));
          break;
        default:
          break;
      }
    });*/
  }

  final RxInt navIndex = 0.obs;

  void changeNav(int i) {
    navIndex.value = i;
  }

  final RxString category = 'All'.obs;
  final RxString brandCategory = 'All'.obs; //BrandCategory

  void changeCat(String name) {
    category.value = name;
  }

  //Change Brand Cat
  void changeBrandCat(String name) {
    brandCategory.value = name;
  }

  final RxBool isSearch = false.obs;

  void search() => isSearch.value = !isSearch.value;

  void onSearch(String name) {
    isSearch.value = true;
    searchitems.value = items
        .where((p0) => p0.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  void clear() => isSearch.value = false;

  void searchItem(String name) {
    isSearch.value = !isSearch.value;
  }

  //Check weather show dialog or not
  showDialogToEnterPhoneCode(void Function(String code) callBack) {
    final size = MediaQuery.of(Get.context!).size;
    Get.defaultDialog(
      title: "Phone Verification",
      content: SizedBox(
        height: size.height * 0.2,
        width: size.width * 0.2,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Text FIELD
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: TextFormField(
                  controller: _phoneCodeController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your code',
                  ),
                ),
              ),
              //Space
              const SizedBox(height: 10),
              //CONFIRM
              TextButton(
                onPressed: () {
                  //CALL BACK TO ORIGINAL SIGNINWITHPHONENUMBER
                  callBack(_phoneCodeController.text);
                  Get.back();
                },
                child: Text("Confirm"),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //-------------For Reward----------------------//

  Future<void> signInWithGoogle(/*String redirectRouteUrl*/) async {
    showLoading();
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      hideLoading();
      //Get.offNamed(redirectRouteUrl);
    } catch (e) {
      log("Sign in with google error: $e");
      hideLoading();
    }
  }

  int currentUserPoint = 0;

  bool isCanAdd(int rewardPoint) {
    return currentUserPoint > (rewardPoint * 1);
  }

  bool isContainRewardProductInCart(Product p) {
    bool result = false;
    myCart.map((element) {
      if (element.id == p.id) {
        result = true;
      }
    });
    return result;
  }

  //---------------------------------------------//
  var pieTouchIndex = -1.obs;
  var totalProduct = 0.obs;
  var remainProduct = 0.obs;
  int totalPrice() {
    var result = 0;
    for (var item in items) {
      result += item.price;
    }
    return result;
  }

  int totalPriceAndRemain() {
    var result = 0;
    for (var item in items) {
      result += item.price * (item.remainQuantity ?? 0);
    }
    return result;
  }

  int totalCost() {
    var result = 0;
    for (var item in items) {
      result += (item.originalPrice ?? 0);
    }
    return result;
  }

  int totalCostAndRemain() {
    var result = 0;
    for (var item in items) {
      result += (item.originalPrice ?? 0) * (item.remainQuantity ?? 0);
    }
    return result;
  }

  void refreshTotalProductAndRemainProduct() {
    totalProduct.value = 0;
    remainProduct.value = 0;
    if (items.isNotEmpty) {
      items.forEach((element) {
        totalProduct.value += element.originalQuantity ?? 0;
        remainProduct.value += element.remainQuantity ?? 0;
      });
    }
  }

  //---------------------------------------------//

  Future<void> logOut() async {
    showLoading();
    await FirebaseAuth.instance.signOut();
    hideLoading();
    currentUser.value = null;
    Get.offNamed(introScreen);
  }

  Future<void> deleteAccount() async {
    showLoading();
    await _database
        .delete(userCollection, path: currentUser.value!.id)
        .then((value) async {
      try {
        await FirebaseAuth.instance.currentUser?.delete();
      } on FirebaseAuthException catch (e) {
        if (e.code == "requires-recent-login") {
          //TODO: WE NEED TO PROMPT TO REAUTHENTICATE,then delete() again
          log("**********${e.code}");
          return;
        }
        log("**********${e.code}");
      }
    });
    hideLoading();
    currentUser.value = null;
    Get.offNamed(introScreen);
  }
}

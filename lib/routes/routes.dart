import 'package:get/route_manager.dart';
import 'package:kozarni_ecome/binding/upload_binding.dart';
import 'package:kozarni_ecome/screen/advertisement/view/advertisement_screen.dart';
import 'package:kozarni_ecome/screen/advertisement2/view/advertisement_screen.dart';
import 'package:kozarni_ecome/screen/blue_tooth_screen.dart';
import 'package:kozarni_ecome/screen/brand_management/bin/brand_binding.dart';
import 'package:kozarni_ecome/screen/brand_management/view/brand_view.dart';
import 'package:kozarni_ecome/screen/cart.dart';
import 'package:kozarni_ecome/screen/check_out_screen.dart';
import 'package:kozarni_ecome/screen/product_detail/bin/product_detail_binding.dart';
import 'package:kozarni_ecome/screen/product_detail/view/detail_screen.dart';
import 'package:kozarni_ecome/screen/division/bin/division_binding.dart';
import 'package:kozarni_ecome/screen/division/view/manage_division_screen.dart';
import 'package:kozarni_ecome/screen/home_screen.dart';
import 'package:kozarni_ecome/screen/item_upload_screen.dart';
import 'package:kozarni_ecome/screen/manage_item.dart';
import 'package:kozarni_ecome/screen/product_category/view/product_category_view.dart';
import 'package:kozarni_ecome/screen/search_screen.dart';
import 'package:kozarni_ecome/screen/status/status_screen.dart';
import 'package:kozarni_ecome/screen/tags/tags_screen.dart';
import 'package:kozarni_ecome/screen/user_order_view.dart';
import 'package:kozarni_ecome/screen/view/favourite.dart';
import 'package:kozarni_ecome/screen/view_all/view/view_all.dart';

import '../intro_screen.dart';
import '../screen/pos_inventory/inventory_management.dart';
import '../screen/promotion/view/promotion_view.dart';

const String introScreen = '/intro-screen';
const String homeScreen = '/home';
const String checkOutScreen = '/checkout';
const String detailScreen = '/detail';
const String uploadItemScreen = '/uploadItemScreen';
const String mangeItemScreen = '/manage-item';
const String purchaseScreen = '/purchase-screen';
const String blueToothScreen = '/bluetooth-screen';
const String searchScreen = '/searchScreen';
const String advertisementUrl = '/advertisement';
const String advertisementUrl2 = '/advertisement2';
const String categoriesUrl = '/categories';
const String statusUrl = '/status';
const String tagsUrl = '/tags';
const String viewAllUrl = '/view_all';
const String cartUrl = '/cart_url';
const String favouriteUrl = '/favourite';
const String promotionUrl = '/promotions';
const String divisionUrl = "/divisions";
const inventoryUrl = "/inventory_url";
const brandManagementUrl = "/brand_managment";

List<GetPage> routes = [
  // GetPage(
  //   name: introScreen,
  //   page: () => OnBoardingPage(),
  // ),
  GetPage(
    name: homeScreen,
    page: () => HomeScreen(),
  ),
  GetPage(
    name: checkOutScreen,
    page: () => CheckOutScreen(),
  ),
  GetPage(
    name: detailScreen,
    page: () => DetailScreen(),
    binding: ProductDetailBinding(),
  ),
  GetPage(
    name: uploadItemScreen,
    page: () => UploadItem(),
    binding: UploadBinding(),
  ),
  GetPage(
    name: brandManagementUrl,
    page: () => BrandView(),
    binding: BrandBinding(),
  ),
  GetPage(
    name: purchaseScreen,
    page: () => UserOrderView(),
  ),
  GetPage(
    name: blueToothScreen,
    page: () => BlueToothPrintScreen(),
  ),
  GetPage(
    name: searchScreen,
    page: () => SearchScreen(),
  ),
  GetPage(
    name: advertisementUrl,
    page: () => AdvertisementScreen(),
  ),
  GetPage(
    name: advertisementUrl2,
    page: () => AdvertisementScreen2(),
  ),
  GetPage(
    name: statusUrl,
    page: () => StatusScreen(),
  ),
  GetPage(
    name: categoriesUrl,
    page: () => ProductCategoryView(),
  ),
  GetPage(
    name: promotionUrl,
    page: () => PromotionView(),
  ),
  GetPage(
    name: tagsUrl,
    page: () => TagsScreen(),
  ),
  GetPage(
    name: viewAllUrl,
    page: () => ViewAllScreen(),
  ),
  GetPage(
    name: cartUrl,
    page: () => CartView(),
  ),
  GetPage(
    name: mangeItemScreen,
    page: () => ManageItem(),
  ),
  GetPage(
    name: favouriteUrl,
    page: () => FavouriteView(),
  ),
  GetPage(
    name: divisionUrl,
    binding: DivisionBinding(),
    page: () => ManageDivisionScreen(),
  ),
  GetPage(
    name: inventoryUrl,
    page: () => const InventoryManagement(),
  ),
];

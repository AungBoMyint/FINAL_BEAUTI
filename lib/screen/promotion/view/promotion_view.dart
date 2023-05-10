import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kozarni_ecome/data/constant.dart';
import 'package:kozarni_ecome/screen/product_category/view/product_category_manage.dart';
import 'package:kozarni_ecome/screen/promotion/view/promotion_manage.dart';
import 'package:kozarni_ecome/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../controller/home_controller.dart';

class PromotionView extends StatefulWidget {
  const PromotionView({Key? key}) : super(key: key);

  @override
  State<PromotionView> createState() => _PromotionViewState();
}

class _PromotionViewState extends State<PromotionView> {
  @override
  Widget build(BuildContext context) {
    final HomeController _homeController = Get.find();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: const Center(
            child: Text("Promotion View", style: appBarTitleStyle)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
        ),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () {
                  if (_homeController.categories.isEmpty) {
                    return const Center(
                        child: Text(
                      "No promotion yet....",
                    ));
                  }

                  return ListView.builder(
                    itemCount: _homeController.promotionList.length,
                    itemBuilder: (context, index) {
                      var promotion = _homeController.promotionList[index];

                      return ListTile(
                        onTap: () => Get.to(() => PromotionManager(promotion)),
                        title: Text(promotion.code,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        trailing: Text("${promotion.promotionValue}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            )),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () => Get.to(() => PromotionManager(null)),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: homeIndicatorColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kozarni_ecome/controller/home_controller.dart';
import 'package:kozarni_ecome/data/constant.dart';
import 'package:kozarni_ecome/data/mock.dart';
import 'package:kozarni_ecome/model/view_all_model.dart';
import 'package:kozarni_ecome/routes/routes.dart';
import 'package:kozarni_ecome/screen/brand_view_all_screen.dart';
import 'package:kozarni_ecome/utils/get_accurate_widget.dart';
import 'package:kozarni_ecome/widgets/home_category.dart';
import 'package:kozarni_ecome/widgets/home_category_main.dart';
import 'package:kozarni_ecome/widgets/home_pickup.dart';
import 'package:kozarni_ecome/widgets/home_pickup_two.dart';
import 'package:kozarni_ecome/widgets/normal_product_widget.dart';
import 'package:kozarni_ecome/widgets/reward_product_widget.dart';
import 'package:shimmer/shimmer.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.height > 1000;
    final HomeController controller = Get.find();
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          //Category
          HomeCategoryMain(),
          const SizedBox(
            height: 10,
          ),
          //Advertisement
          HomePickUp(),
          // Obx(
          //   () {
          //     return controller.advertisementList.length > 0 ? AspectRatio(
          //       aspectRatio: 16/10,
          //       child: ListView.builder(
          //         scrollDirection: Axis.horizontal,
          //         shrinkWrap: true,
          //         itemCount: controller.advertisementList.length,
          //         itemBuilder: (context,index){
          //           final advertisement = controller.advertisementList[index];
          //           return AspectRatio(
          //             aspectRatio: 16/10,
          //             child:  CachedNetworkImage(
          //                     progressIndicatorBuilder: (context, url, status) {
          //       return Shimmer.fromColors(
          //         baseColor: Colors.red,
          //         highlightColor: Colors.yellow,
          //         child: Container(color: Colors.white,),
          //       );
          //                     },
          //                     errorWidget: (context, url, whatever) {
          //       return const Text("Image not available");
          //                     },
          //                     imageUrl:
          //         advertisement.image,
          //                     fit: BoxFit.cover,
          //                   ),
          //             );
          //         },
          //         ),
          //     ) : const SizedBox();
          //   }
          // ),
          //Brand List
          Obx(() {
            if (controller.brandList.isEmpty) {
              return const SizedBox();
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: Text(
                    "Brands",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => BrandViewAllScreen());
                  },
                  child: Row(
                    children: [
                      const Text(
                        "View all  ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 10),
          Obx(() {
            if (controller.brandList.isEmpty) {
              return const SizedBox();
            }
            return Container(
              height: 150,
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.brandList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final brand = controller.brandList[index];
                    return InkWell(
                      onTap: () {
                        controller.setViewAllProducts(ViewAllModel(
                          status: brand.name,
                          products: controller.items
                              .where((e) => e.brandID == brand.id)
                              .toList(),
                        ));
                        Get.toNamed(viewAllUrl);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Container(
                          height: 150,
                          width: 145,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 105,
                                  width: 105,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: CustomCacheNetworkImage(
                                    imageUrl: brand.image,
                                    boxFit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  brand.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }),
          //
          Obx(() {
            return controller.statusList.length > 1
                ? ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: controller.statusList.length,
                    itemBuilder: (context, index) {
                      if (index == 1) {
                        return ListView(
                          primary: false,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            //Advertisement 2
                            Obx(() {
                              return controller.slideLoading2.value
                                  ? const LoadingWidget()
                                  : HomePickUpTwo(
                                      aspectRatio: 16 / 9,
                                      advertisementList:
                                          controller.advertisementList2,
                                      showShopButton: false,
                                    );
                            }),
                            getAccurateWidget(
                                controller: controller, index: index),
                          ],
                        );
                      } else {
                        return getAccurateWidget(
                            controller: controller, index: index);
                      }
                    },
                  )
                : const SizedBox();
          }),
          //const SizedBox(height: 100,),
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class CustomCacheNetworkImage extends StatelessWidget {
  const CustomCacheNetworkImage({
    Key? key,
    required this.imageUrl,
    required this.boxFit,
  }) : super(key: key);
  final String imageUrl;
  final BoxFit boxFit;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      progressIndicatorBuilder: (context, url, status) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.white,
          child: Container(
            color: Colors.white,
          ),
        );
      },
      errorWidget: (context, url, whatever) {
        return const Text("Image not available");
      },
      imageUrl: imageUrl,
      fit: boxFit,
    );
  }
}

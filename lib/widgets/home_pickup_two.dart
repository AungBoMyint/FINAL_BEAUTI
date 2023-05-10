import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../controller/home_controller.dart';
import 'package:getwidget/getwidget.dart';

import '../model/advertisement.dart';

class HomePickUpTwo extends StatelessWidget {
  final List<Advertisement> advertisementList;
  final bool showShopButton;
  final double aspectRatio;
  const HomePickUpTwo({
    Key? key,
    required this.advertisementList,
    required this.showShopButton,
    required this.aspectRatio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.height > 1000;
    final width = MediaQuery.of(context).size.width;
    final HomeController controller = Get.find();
    return advertisementList.isEmpty
        ? const SizedBox()
        : Padding(
            padding: EdgeInsets.zero,
            child: GFCarousel(
              scrollPhysics: const BouncingScrollPhysics(),
              aspectRatio: aspectRatio,
              autoPlay: true,
              viewportFraction: 1.0,
              hasPagination: true,
              activeIndicator: Colors.black,
              passiveIndicator: Colors.grey,
              autoPlayInterval: const Duration(seconds: 6),
              items: advertisementList.map((advertisement) {
                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CachedNetworkImage(
                        progressIndicatorBuilder: (context, url, status) {
                          return Shimmer.fromColors(
                            child: Container(
                              color: Colors.white,
                            ),
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.white,
                          );
                        },
                        errorWidget: (context, url, whatever) {
                          return const Text("Image not available");
                        },
                        imageUrl: advertisement.image,
                        fit: BoxFit.contain,
                        height: isTablet ? 400:200,
                        width: width,
                      ),
                    ),
                    //Shop Button
                    showShopButton
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              color: Colors.black.withOpacity(0.3),
                              height: 50,
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Description
                                  Text(
                                    advertisement.description,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  //Shop text button
                                  // TextButton(
                                  //   onPressed: () {
                                  //     /* controller.setViewAllProducts(ViewAllModel(
                                  //             status: advertisement.description,
                                  //             products:
                                  //                 controller.getAdvertisementsProductList(
                                  //                     advertisement.products),
                                  //           ));
                                  //           Get.toNamed(viewAllUrl); */
                                  //   },
                                  //   child: Text(
                                  //     "Show Now",
                                  //     style: TextStyle(
                                  //       color: Colors.white,
                                  //       fontSize: 18,
                                  //       fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                );
              }).toList(),
            ),
          );
  }
}

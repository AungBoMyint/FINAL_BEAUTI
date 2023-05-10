import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kozarni_ecome/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../controller/home_controller.dart';
import '../../../data/constant.dart';
import 'manage_advertisement.dart';

class AdvertisementScreen2 extends StatefulWidget {
  const AdvertisementScreen2({Key? key}) : super(key: key);

  @override
  State<AdvertisementScreen2> createState() => _AdvertisementScreen2State();
}

class _AdvertisementScreen2State extends State<AdvertisementScreen2> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
            child: Text("ကြော်ငြာ အုပ်စုများ", style: appBarTitleStyle)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
        ),
        child: Column(
          children: [
            // Form(
            //   key: formKey,
            //   child: Container(
            //     child: Row(
            //       children: [
            //         Expanded(
            //           child: SizedBox(
            //             height: 50,
            //             child: TextFormField(
            //               onChanged: (value) => input.input['advertisement'] = value,
            //   validator: input.validateInput,
            //   decoration: InputDecoration(
            //     //hintText: ,
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            //           ),
            //         ),
            //         const SizedBox(
            //           width: 10.0,
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.only(top: 22.0),
            //           child: ExButton(
            //             color: homeIndicatorColor,
            //             borderRadius: BorderRadius.all(Radius.circular(10)),
            //             label: "Add",
            //             height: 36.0,
            //             onPressed: () {
            //               if(formKey.currentState!.validate()){
            //                 _homeController.addCategory(
            //                 Category(name: input.input.values.first,
            //                 id: Uuid().v1(),
            //                 dateTime: DateTime.now(),
            //                 ),
            //               );
            //               }
            //             },
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Expanded(
              child: Obx(
                () {
                  if (_homeController.advertisementList2.isEmpty) {
                    return const Center(
                        child: Text(
                      "No advertisement yet....",
                    ));
                  }

                  return ListView.builder(
                    itemCount: _homeController.advertisementList2.length,
                    itemBuilder: (context, index) {
                      var advertisement =
                          _homeController.advertisementList2[index];

                      return InkWell(
                        onTap: () =>
                            Get.to(ManageAdvertisementScreen2(advertisement)),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 150,
                            maxHeight: 200,
                          ),
                          child: Card(
                            child: Row(
                              children: [
                                //Advertisement IMAGE
                                Expanded(
                                  child: CachedNetworkImage(
                                    progressIndicatorBuilder:
                                        (context, url, status) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey,
                                        highlightColor: Colors.white,
                                        child: Container(
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, whatever) {
                                      return const Text("Image not available");
                                    },
                                    imageUrl: advertisement.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                //Type
                                Expanded(
                                  child: Text(
                                    advertisement.description,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
        onTap: () => Get.to(ManageAdvertisementScreen2(null)),
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

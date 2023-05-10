import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../widgets/form/empty_widgt.dart';
import '../../../widgets/form/image_pick_form.dart';
import '../../../widgets/form/selectable_bottom_sheet.dart';
import '../../../widgets/form/selected_bottom_sheet.dart';
import '../../../widgets/form/text_form.dart';
import '../../view/home.dart';
import '../controller/brand_controller.dart';

class BrandView extends StatelessWidget {
  const BrandView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BrandController brandController = Get.find();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: const Center(
            child: Text(
          "အမှတ်တံဆိပ်များ",
          style: TextStyle(
            color: Colors.black,
          ),
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              right: 10,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orangeAccent,
              ),
              onPressed: () => brandController.save(),
              child: const Text("Save"),
            ),
          )
        ],
      ),
      body: Obx(() {
        return Form(
          key: brandController.formKey,
          autovalidateMode: brandController.isFirstTimePressed.value
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /**Form*/
                  CustomTextForm(
                    padding: 0,
                    rightPadding: 0,
                    height: 85,
                    maxLines: 1,
                    textFieldPaddingLeft: 10,
                    controller: brandController.nameController,
                    isUnderlineBorder: false,
                    validator: (value) =>
                        brandController.validate(value, "Name"),
                    labelText: "Brand Name",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() {
                    final pickedImage = brandController.pickedImage.value;
                    final isEmpty = pickedImage.isEmpty;
                    return ImagePickForm(
                      labelText: isEmpty ? "pick an image" : pickedImage,
                      pickImage: () => brandController.pickImage(),
                    );
                  }),
                  Obx(() {
                    return SizedBox(
                      height: 25,
                      child: Text(brandController.pickImageError.value,
                          style: const TextStyle(
                            color: Colors.red,
                          )),
                    );
                  }),

                  /**Advertisement List*/
                  Obx(
                    () {
                      if (brandController.brandList.isEmpty) {
                        return const Center(
                            child: Text(
                          "No brands yet....",
                        ));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: brandController.brandList.length,
                        itemBuilder: (context, index) {
                          var advertisement = brandController.brandList[index];

                          return SwipeActionCell(
                            key: ValueKey(advertisement.id),
                            trailingActions: [
                              SwipeAction(
                                onTap: (CompletionHandler _) async {
                                  await _(true);
                                  await brandController
                                      .delete(advertisement.id);
                                },
                                content: Container(
                                  color: Colors.red,
                                  height: 35,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "DELETE",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                color: Colors.white,
                              ),
                            ],
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minHeight: 50,
                                maxHeight: 100,
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
                                          return const Text(
                                              "Image not available");
                                        },
                                        imageUrl: advertisement.image,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    //Type
                                    Expanded(
                                      child: Text(
                                        advertisement.name,
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
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

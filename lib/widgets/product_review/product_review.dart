import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:kozarni_ecome/controller/home_controller.dart';
import 'package:kozarni_ecome/data/constant.dart';
import 'package:kozarni_ecome/model/product.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kozarni_ecome/model/review.dart';
import 'package:kozarni_ecome/screen/product_detail/controller/product_detail_controller.dart';

import 'user_review_widget.dart';

class ProductReviewWidget extends StatelessWidget {
  final Product product;
  const ProductReviewWidget({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final reviewsQuery = FirebaseFirestore.instance
        .collection(reviewCollection)
        .orderBy('dateTime')
        .where("productId", isEqualTo: product.id)
        .withConverter<Review>(
          fromFirestore: (snapshot, _) => Review.fromJson(snapshot.data()!),
          toFirestore: (review, _) => review.toJson(),
        );
    final HomeController homeController = Get.find();
    final ProductDetailController detailController = Get.find();
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Review Product",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 4),
          /* Row(
            children: [
              /*   Obx(() {
                return  */
              RatingBar(
                itemSize: 20,
                maxRating: 5,
                initialRating: product.reviewCount ?? 0.0,
                itemCount: 5,
                direction: Axis.horizontal,
                ratingWidget: RatingWidget(
                  full: const Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  empty: const Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                  half: const Icon(Icons.star),
                ),
                onRatingUpdate: (rating) {},
              ) /* ;
              }) */
              ,
              SizedBox(width: 8),
              /* Obx(() {
                return */
              Text(
                "${product.reviewCount ?? 0.0}",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 12),
              ) /* ;
              }) */
              , */
          Text(
            "(${product.reviewCount} Reviews)",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
            textAlign: TextAlign.right,
          ),
          /*  ],
          ), */
          //ReviewList
          FirestoreListView<Review>(
            shrinkWrap: true,
            query: reviewsQuery,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, snapshot) {
              Review review = snapshot.data();

              return UserReviewWidget(review: review, size: size);
            },
            loadingBuilder: (context) => const SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
            errorBuilder: (context, error, stackTrace) => const SizedBox(
              height: 50,
              width: 50,
              child: Text("Something was wrong."),
            ),
          ),

          const SizedBox(height: 20),

          const SizedBox(height: 10),
          //Rating Bar
          Obx(() {
            final rating = detailController.rating.value;
            final isError = detailController.rateError.value &&
                detailController.firstTimePressed.value;
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: isError ? Colors.red : Colors.transparent),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      detailController.changeRating(rating);
                    },
                  ),
                  const SizedBox(width: 15),
                  //TextField
                  Expanded(
                      child: TextField(
                    keyboardType: TextInputType.number,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        detailController.changeRating(
                          value.length > 1
                              ? double.parse(value)
                              : int.parse(value) + 0.0,
                        );
                      }
                    },
                    controller: detailController.ratingController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "0.0",
                    ),
                  )),
                ],
              ),
            );
          }),
          SizedBox(height: 5),
          //Write review form
          Obx(() {
            final isError = detailController.reviewError.value &&
                detailController.firstTimePressed.value;
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: isError ? Colors.red : Colors.grey),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: detailController.reviewController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: "Write review..",
                      border: InputBorder.none,
                    ),
                  ),
                  //Submit
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.orangeAccent,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        )),
                    onPressed: () {
                      if (homeController.currentUser.value!.status! == 0) {
                        Get.snackbar("", "Login to review product.");
                        return;
                      }
                      detailController.writeReiew(
                          product.id, homeController.currentUser.value!);
                    },
                    child: Obx(() {
                      return detailController.isWritingReviewLoading.value
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(),
                            )
                          : const Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            );
                    }),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}

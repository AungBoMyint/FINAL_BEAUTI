import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kozarni_ecome/controller/home_controller.dart';
import 'package:uuid/uuid.dart';

import '../../../data/constant.dart';
import '../../../model/review.dart';
import '../../../model/user.dart';
import '../../../service/database.dart';

class ProductDetailController extends GetxController {
  final Database _database = Database();
  final HomeController homeController = Get.find();
  //**For Review */
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();
/*   RxList<Review> reviewsList = <Review>[].obs; */
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var isWritingReviewLoading = false.obs;
  var rating = 0.0.obs;
  var rateError = false.obs;
  var reviewError = false.obs;
  var firstTimePressed = false.obs;

  void changeRating(double value) {
    rating.value = value;
    ratingController.text = value.toString();
  }

  Future<void> writeReiew(String productId, AuthUser currentUser) async {
    firstTimePressed.value = true;
    if (isWritingReviewLoading.value) {
      return;
    }
    if (checkValidate()) {
      isWritingReviewLoading.value = true;
      final review = Review(
        id: Uuid().v1(),
        productId: productId,
        user: currentUser,
        rating: rating.value,
        reviewMessage: reviewController.text,
        dateTime: DateTime.now(),
      );
      try {
        await _database.write(
          reviewCollection,
          path: review.id,
          data: review.toJson(),
        );
        await updateRating(productId);
        isWritingReviewLoading.value = false;
        clearAll();
        /* reviewsList.add(review);
        reviewsList
            .sort((v1, v2) => v1.dateTime.millisecondsSinceEpoch.compareTo(
                  v2.dateTime.millisecondsSinceEpoch,
                ));
        reviewsList.value = reviewsList.reversed.toList();
        log("******Review List: ${reviewsList.length}"); */
      } catch (e) {
        log("*****Review Write Failed!: $e..");
        isWritingReviewLoading.value = false;
      }
    }
  }

  void clearAll() {
    rating.value = 0.0;
    ratingController.clear();
    reviewController.clear();
  }

  Future<void> updateRating(String productId) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final secureSnapshot = await transaction.get(
          FirebaseFirestore.instance.collection(itemCollection).doc(productId));
      double previousRating = 0.0;
      try {
        previousRating = secureSnapshot.get("reviewCount");
      } catch (e) {
        previousRating = 0.0;
      }
      try {
        transaction.set(
          secureSnapshot.reference,
          {
            "reviewCount": previousRating + 1,
          },
          SetOptions(merge: true),
        );
      } catch (e) {
        log("****Update Review Error: $e");
      }
    });
  }

  bool checkValidate() {
    if (validateReview() && validateRating()) {
      return true;
    } else {
      return false;
    }
  }

  bool validateReview() {
    if (reviewController.text.isEmpty) {
      reviewError.value = true;
      return false;
    } else {
      reviewError.value = false;
      return true;
    }
  }

  bool validateRating() {
    if (rating.value < 0 || rating.value == 0) {
      rateError.value = true;
      return false;
    } else {
      rateError.value = false;
      return true;
    }
  }
  //**End */

  /*  @override
  Future<void> onInit() async {
    FirebaseFirestore.instance
        .collection(reviewCollection)
        .where("productId", isEqualTo: dataController.selectedProduct.value!.id)
        .get()
        .then((value) {
      reviewsList.value = value.docs.map((e) {
        return Review.fromJson(e.data());
      }).toList();
    });
    super.onInit();
  }
 */
}

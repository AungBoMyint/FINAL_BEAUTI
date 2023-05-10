import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/review.dart';
import 'immutable_ratingbar.dart';

class UserReviewWidget extends StatelessWidget {
  const UserReviewWidget({
    Key? key,
    required this.review,
    required this.size,
  }) : super(key: key);

  final Review review;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Top
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Profile
                CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, status) {
                    return Shimmer.fromColors(
                      baseColor: Colors.red,
                      highlightColor: Colors.yellow,
                      child: Container(
                        color: Colors.white,
                      ),
                    );
                  },
                  errorWidget: (context, url, whatever) {
                    return const Text("Image not available");
                  },
                  imageUrl: review.user.image,
                  imageBuilder: (context, provider) {
                    return CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey.shade300,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: provider,
                      ),
                    );
                  },
                  fit: BoxFit.cover,
                ),
                Text(
                  review.user.userName,
                ),
              ],
            ),
            //Rating Bar
            ImmutableRatingBar(
              rating: review.rating,
            ),
          ],
        ),
        //Message
        SizedBox(
          width: size.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              review.reviewMessage,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        //Date
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "${review.dateTime.year}-${review.dateTime.month}-${review.dateTime.day}",
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kozarni_ecome/model/user.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
class Review with _$Review {
  @JsonSerializable(explicitToJson: true)
  factory Review({
    required String id,
    required String productId,
    required AuthUser user,
    required double rating,
    required String reviewMessage,
    required DateTime dateTime,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}

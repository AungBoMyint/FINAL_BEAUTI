import 'package:freezed_annotation/freezed_annotation.dart';

part 'promotion_type.freezed.dart';

@freezed
class PromotionType with _$PromotionType {
  const factory PromotionType.nothing() = _Nothing;
  const factory PromotionType.money() = _Money;
  const factory PromotionType.percentage() = _Percentage;
}

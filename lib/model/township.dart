import 'package:freezed_annotation/freezed_annotation.dart';

part 'township.freezed.dart';
part 'township.g.dart';

@freezed
class Township with _$Township {
  factory Township({
    required int fee,
    required String name,
  }) = _Township;

  factory Township.fromJson(Map<String, dynamic> json) =>
      _$TownshipFromJson(json);
}

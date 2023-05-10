import 'package:freezed_annotation/freezed_annotation.dart';

import 'township.dart';

part 'division.freezed.dart';
part 'division.g.dart';

@freezed
class Division with _$Division {
  @JsonSerializable(explicitToJson: true)
  factory Division({
    required String id,
    required String name,
    required List<Township> townships,
    required DateTime dateTime,
  }) = _Division;

  factory Division.fromJson(Map<String, dynamic> json) =>
      _$DivisionFromJson(json);
}

/* class Division {
  final String name;
  final Map<String, List<String>> townShipMap;
  Division({required this.name, required this.townShipMap});
} */

// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_reservation_request_entity.freezed.dart';
part 'create_reservation_request_entity.g.dart';

@freezed

/// Order Data Models to Entity
class CreateReservationRequestEntity with _$CreateReservationRequestEntity {
  @JsonSerializable(fieldRename: FieldRename.none)

  /// fields
  const factory CreateReservationRequestEntity({
    required String reserveBy,
    required String community,
    required String phoneNumber,
    required String note,
    required String start,
    required String end,
    required List<Map<String, dynamic>> menus,
    required List<String> tables,
    required String paymentMethod,
    required bool halfPayment,
  }) = _CreateReservationRequestEntity;

  /// from json mapper
  factory CreateReservationRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$CreateReservationRequestEntityFromJson(json);
}

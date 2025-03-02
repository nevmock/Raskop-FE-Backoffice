// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raskop_fe_backoffice/src/common/serializer/datetime_serializer.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/order_entity.dart';
import 'package:raskop_fe_backoffice/src/reservation/domain/entities/reservation_detail_entity.dart';

part 'reservation_entity.freezed.dart';
part 'reservation_entity.g.dart';

@freezed

/// Reservation Data Models to Entity
class ReservationEntity with _$ReservationEntity {
  @JsonSerializable(fieldRename: FieldRename.none)

  /// fields
  const factory ReservationEntity({
    required String id,
    required String reserveBy,
    required String phoneNumber,
    @DateTimeSerializer() required DateTime start,
    @DateTimeSerializer() required DateTime end,
    required bool halfPayment,
    @JsonKey(includeIfNull: true) String? community,
    @JsonKey(includeIfNull: true) String? note,
    @JsonKey(includeFromJson: true, includeToJson: false)
    List<ReservationDetailEntity>? detailReservasis,
    @JsonKey(includeFromJson: true, includeToJson: false)
    List<OrderEntity>? orders,
    @JsonKey(includeFromJson: true, includeToJson: false) String? deletedAt,
  }) = _ReservationEntity;

  /// from json mapper
  factory ReservationEntity.fromJson(Map<String, dynamic> json) =>
      _$ReservationEntityFromJson(json);
}

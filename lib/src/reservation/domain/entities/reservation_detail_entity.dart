// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raskop_fe_backoffice/src/table/domain/entities/table_entity.dart';

part 'reservation_detail_entity.freezed.dart';
part 'reservation_detail_entity.g.dart';

@freezed

/// Reservation Detail Data Models to Entity
class ReservationDetailEntity with _$ReservationDetailEntity {
  @JsonSerializable(fieldRename: FieldRename.none)

  /// fields
  const factory ReservationDetailEntity({
    required String id,
    required String reservasiId,
    required String tableId,
    required TableEntity table,
    @JsonKey(includeFromJson: true, includeToJson: false) String? deletedAt,
  }) = _ReservationDetailEntity;

  /// from json mapper
  factory ReservationDetailEntity.fromJson(Map<String, dynamic> json) =>
      _$ReservationDetailEntityFromJson(json);
}

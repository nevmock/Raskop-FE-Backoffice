// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_status_order_request_entity.freezed.dart';
part 'update_status_order_request_entity.g.dart';

@freezed

/// Order Data Models to Entity
class UpdateStatusOrderRequestEntity with _$UpdateStatusOrderRequestEntity {
  @JsonSerializable(fieldRename: FieldRename.none)

  /// fields
  const factory UpdateStatusOrderRequestEntity({
    required String id,
    required String status,
  }) = _UpdateStatusOrderRequestEntity;

  /// from json mapper
  factory UpdateStatusOrderRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$UpdateStatusOrderRequestEntityFromJson(json);
}

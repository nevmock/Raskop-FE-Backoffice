// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_order_response_entity.freezed.dart';
part 'create_order_response_entity.g.dart';

@freezed

/// Order Data Models to Entity
class CreateOrderResponseEntity with _$CreateOrderResponseEntity {
  @JsonSerializable(fieldRename: FieldRename.none)

  /// fields
  const factory CreateOrderResponseEntity({
    required String token,
    required String redirectUrl,
  }) = _CreateOrderResponseEntity;

  /// from json mapper
  factory CreateOrderResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderResponseEntityFromJson(json);
}

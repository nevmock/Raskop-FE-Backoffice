// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_order_request_entity.freezed.dart';
part 'create_order_request_entity.g.dart';

@freezed

/// Order Data Models to Entity
class CreateOrderRequestEntity with _$CreateOrderRequestEntity {
  @JsonSerializable(fieldRename: FieldRename.none)

  /// fields
  const factory CreateOrderRequestEntity({
    required String orderBy,
    required String phoneNumber,
    required List<Map<String, dynamic>> menus,
    required String paymentMethod,
  }) = _CreateOrderRequestEntity;

  /// from json mapper
  factory CreateOrderRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestEntityFromJson(json);
}

// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raskop_fe_backoffice/src/menu/domain/entities/menu_entity.dart';

part 'order_detail_entity.freezed.dart';
part 'order_detail_entity.g.dart';

@freezed

/// Order Detail Data Models to Entity
class OrderDetailEntity with _$OrderDetailEntity {
  @JsonSerializable(fieldRename: FieldRename.none)

  /// fields
  const factory OrderDetailEntity({
    required String id,
    required String orderId,
    required String menuId,
    required int qty,
    required double price,
    required MenuEntity menu,
    @JsonKey(includeIfNull: true) String? note,
    @JsonKey(includeFromJson: true, includeToJson: false) String? deletedAt,
  }) = _OrderDetailEntity;

  /// from json mapper
  factory OrderDetailEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailEntityFromJson(json);
}

// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier_entity.freezed.dart';
part 'supplier_entity.g.dart';

@freezed

/// Supplier Data Models to Entity
class SupplierEntity with _$SupplierEntity {
  @JsonSerializable(fieldRename: FieldRename.none)

  /// fields
  const factory SupplierEntity({
    required String name,
    required String contact,
    required String type,
    required double price,
    required String unit,
    required double shippingFee,
    required String address,
    required String productName,
    bool? isActive,
    @JsonKey(includeIfNull: false) String? id,
    @JsonKey(includeFromJson: true, includeToJson: false) String? deletedAt,
  }) = _SupplierEntity;

  /// from json mapper
  factory SupplierEntity.fromJson(Map<String, dynamic> json) =>
      _$SupplierEntityFromJson(json);
}

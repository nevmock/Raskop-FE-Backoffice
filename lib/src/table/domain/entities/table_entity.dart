// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'table_entity.freezed.dart';
part 'table_entity.g.dart';

@freezed

/// Table Data Models to Entity
class TableEntity with _$TableEntity {
  @JsonSerializable(fieldRename: FieldRename.none)

  /// fields
  const factory TableEntity({
    required String name,
    required String noTable,
    required int minCapacity,
    required int maxCapacity,
    required String description,
    required String barcode,
    required bool isOutdoor,
    required bool isActive,
    @JsonKey(includeIfNull: false) String? imageUri,
    @JsonKey(includeIfNull: false) String? id,
    @JsonKey(includeIfNull: false) List<String>? mergedAvailable,
    @JsonKey(includeFromJson: true, includeToJson: false) String? deletedAt,
  }) = _TableEntity;

  /// from json mapper
  factory TableEntity.fromJson(Map<String, dynamic> json) =>
      _$TableEntityFromJson(json);
}

// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_entity.freezed.dart';
part 'menu_entity.g.dart';

@freezed

/// Menu Data Models to Entity
class MenuEntity with _$MenuEntity {
  @JsonSerializable(fieldRename: FieldRename.none)

  /// fields
  const factory MenuEntity({
    required String name,
    required double price,
    required String description,
    required String category,
    required int qty,
    bool? isActive,
    @JsonKey(includeIfNull: false) String? imageUri,
    @JsonKey(includeIfNull: false) String? id,
    @JsonKey(includeFromJson: true, includeToJson: false) String? deletedAt,
  }) = _MenuEntity;

  /// from json mapper
  factory MenuEntity.fromJson(Map<String, dynamic> json) =>
      _$MenuEntityFromJson(json);
}

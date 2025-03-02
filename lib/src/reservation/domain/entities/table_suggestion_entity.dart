// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'table_suggestion_entity.freezed.dart';
part 'table_suggestion_entity.g.dart';

@freezed

/// Table Data Models to Entity
class TableSuggestionEntity with _$TableSuggestionEntity {
  @JsonSerializable(fieldRename: FieldRename.snake)

  /// fields
  const factory TableSuggestionEntity({
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
  }) = _TableSuggestionEntity;

  /// from json mapper
  factory TableSuggestionEntity.fromJson(Map<String, dynamic> json) =>
      _$TableSuggestionEntityFromJson(json);
}

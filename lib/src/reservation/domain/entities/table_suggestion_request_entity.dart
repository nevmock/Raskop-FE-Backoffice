// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'table_suggestion_request_entity.freezed.dart';
part 'table_suggestion_request_entity.g.dart';

@freezed

/// Reservation Data Models to Entity
class TableSuggestionRequestEntity with _$TableSuggestionRequestEntity {
  @JsonSerializable(fieldRename: FieldRename.none)

  /// fields
  const factory TableSuggestionRequestEntity({
    required int capacity,
    required bool isOutdoor,
    required String date,
    required String startTime,
    required String endTime,
  }) = _TableSuggestionRequestEntity;

  /// from json mapper
  factory TableSuggestionRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$TableSuggestionRequestEntityFromJson(json);
}

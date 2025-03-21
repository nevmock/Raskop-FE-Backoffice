// ignore_for_file: invalid_annotation_target, non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'fav_menu_entity.freezed.dart';
part 'fav_menu_entity.g.dart';

@freezed

/// Fav Menu Data Models to Entity
class FavMenuEntity with _$FavMenuEntity {
  @JsonSerializable(fieldRename: FieldRename.none)

  /// fields
  const factory FavMenuEntity({
    required String menu_name,
    required double qty,
    @JsonKey(includeIfNull: true) String? image_uri,
  }) = _FavMenuEntity;

  /// from json mapper
  factory FavMenuEntity.fromJson(Map<String, dynamic> json) =>
      _$FavMenuEntityFromJson(json);
}

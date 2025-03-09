// ignore_for_file: invalid_annotation_target, non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_performance_entity.freezed.dart';
part 'sales_performance_entity.g.dart';

@freezed

/// Fav Menu Data Models to Entity
class SalesPerformanceEntity with _$SalesPerformanceEntity {
  @JsonSerializable(fieldRename: FieldRename.none)

  /// fields
  const factory SalesPerformanceEntity({
    required String sales_date,
    required int total_sales,
    required int total_orders,
    required int total_items_sold,
  }) = _SalesPerformanceEntity;

  /// from json mapper
  factory SalesPerformanceEntity.fromJson(Map<String, dynamic> json) =>
      _$SalesPerformanceEntityFromJson(json);
}

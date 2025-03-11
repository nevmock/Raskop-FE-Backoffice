// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_entity.freezed.dart';
part 'transaction_entity.g.dart';

@freezed

/// Order Data Models to Entity
class TransactionEntity with _$TransactionEntity {
  @JsonSerializable(fieldRename: FieldRename.none)

  /// fields
  const factory TransactionEntity({
    @JsonKey(includeIfNull: true) String? id,
    @JsonKey(includeIfNull: true) String? trxId,
    @JsonKey(includeIfNull: true) String? orderId,
    @JsonKey(includeIfNull: true) double? grossAmount,
    @JsonKey(includeIfNull: true) String? paymentMethod,
    @JsonKey(includeIfNull: true) double? adminFee,
    @JsonKey(includeIfNull: true) String? status,
    @JsonKey(includeFromJson: true, includeToJson: false) String? deletedAt,
  }) = _TransactionEntity;

  /// from json mapper
  factory TransactionEntity.fromJson(Map<String, dynamic> json) =>
      _$TransactionEntityFromJson(json);
}

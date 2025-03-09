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
    required String id,
    required String trxId,
    required String orderId,
    required double grossAmount,
    required String paymentMethod,
    required double adminFee,
    required String status,
    @JsonKey(includeFromJson: true, includeToJson: false) String? deletedAt,
  }) = _TransactionEntity;

  /// from json mapper
  factory TransactionEntity.fromJson(Map<String, dynamic> json) =>
      _$TransactionEntityFromJson(json);
}

// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raskop_fe_backoffice/src/common/transaction/transaction_entity.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/order_detail_entity.dart';

part 'order_entity.freezed.dart';
part 'order_entity.g.dart';

@freezed

/// Order Data Models to Entity
class OrderEntity with _$OrderEntity {
  @JsonSerializable(fieldRename: FieldRename.none)

  /// fields
  const factory OrderEntity({
    required String id,
    required String orderBy,
    required String phoneNumber,
    required String status,
    required List<OrderDetailEntity> orderDetail,
    required List<TransactionEntity> transaction,
    @JsonKey(includeIfNull: true) String? reservasiId,
    @JsonKey(includeFromJson: true, includeToJson: false) String? deletedAt,
  }) = _OrderEntity;

  /// from json mapper
  factory OrderEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderEntityFromJson(json);
}

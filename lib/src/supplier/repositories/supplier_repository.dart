import 'dart:convert';

import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/res/endpoints.dart';
import 'package:raskop_fe_backoffice/src/common/success/response_success.dart';
import 'package:raskop_fe_backoffice/src/supplier/domain/abstracts/supplier_repository_interface.dart';
import 'package:raskop_fe_backoffice/src/supplier/domain/entities/supplier_entity.dart';

///
class SupplierRepository implements SupplierRepositoryInterface {
  /// Supplier Repository Constructor
  SupplierRepository({required this.client});

  ///
  final ApiClient client;

  /// Supplier Endpoint
  final endpoint = Endpoints.supplier;

  @override
  FutureEither<List<SupplierEntity>> getAllSupplierData({
    int? length,
    String? search,
    Map<String, dynamic>? advSearch,
    List<Map<String, dynamic>>? order,
  }) async {
    return client.request<List<SupplierEntity>>(
      action: 'fetch',
      endpoint: endpoint,
      fromJson: (json) => (json['data'] as List<dynamic>)
          .map((e) => SupplierEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      queryParameters: {
        if (length != null) 'length': length.toString(),
        if (search != null) 'search': search,
        if (advSearch != null)
          'advSearch': jsonEncode(advSearch)
        else
          'advSearch': jsonEncode({'withDeleted': false}),
        if (order != null) 'order': jsonEncode(order),
      },
    );
  }

  @override
  FutureEither<SupplierEntity> getSupplierDataByID({required String id}) async {
    return client.request<SupplierEntity>(
      action: 'fetch',
      endpoint: '$endpoint/$id',
      fromJson: SupplierEntity.fromJson,
    );
  }

  @override
  FutureEitherVoid createNewSupplier({required SupplierEntity request}) async {
    return client.request<ResponseSuccess>(
      action: 'create',
      method: 'POST',
      endpoint: endpoint,
      headers: {'Content-Type': 'application/json'},
      body: request.copyWith(id: null).toJson(),
    );
  }

  @override
  FutureEitherVoid updateCurrentSupplier({
    required SupplierEntity request,
    required String id,
  }) async {
    return client.request<ResponseSuccess>(
      endpoint: endpoint,
      action: 'edit',
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: request.copyWith(id: id).toJson(),
    );
  }

  @override
  FutureEitherVoid deleteSupplier({
    required String id,
    required bool deletePermanent,
  }) async {
    return client.request<ResponseSuccess>(
      endpoint: endpoint,
      action: 'delete',
      method: 'DELETE',
      queryParameters: {
        'id': id,
        'permanent': deletePermanent.toString(),
      },
    );
  }

  @override
  FutureEitherVoid updateSupplierStatus({
    required SupplierEntity request,
    required String id,
    required bool status,
  }) async {
    return client.request<ResponseSuccess>(
      endpoint: endpoint,
      action: 'edit',
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: request.copyWith(id: id, isActive: status).toJson(),
    );
  }
}

import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/res/endpoints.dart';
import 'package:raskop_fe_backoffice/res/paths.dart';
import 'package:raskop_fe_backoffice/src/common/failure/response_failure.dart';
import 'package:raskop_fe_backoffice/src/common/success/response_success.dart';
import 'package:raskop_fe_backoffice/src/supplier/domain/abstracts/supplier_repository_interface.dart';
import 'package:raskop_fe_backoffice/src/supplier/domain/entities/supplier_entity.dart';

///
class SupplierRepository implements SupplierRepositoryInterface {
  /// Supplier Repository Constructor
  SupplierRepository({required this.client});

  ///
  final http.Client client;

  /// Base API URL
  final url = BasePaths.baseAPIURL;

  /// Supplier Endpoint
  final endpoints = Endpoints.supplier;

  @override
  FutureEither<List<SupplierEntity>> getAllSupplierData({
    int? length,
    String? search,
    Map<String, dynamic>? advSearch,
    List<Map<String, dynamic>>? order,
  }) async {
    try {
      final response = await http.get(
        Uri.https(
          url,
          endpoints,
          {
            if (length != null) 'length': length.toString(),
            if (search != null) 'search': search,
            if (advSearch != null) 'advSearch': jsonEncode(advSearch),
            if (order != null) 'order': jsonEncode(order),
          },
        ),
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (json['code'] == 200 || json['status'] == 'OK') {
        return right(
          (json['data'] as List<dynamic>)
              .map((e) => SupplierEntity.fromJson(e as Map<String, dynamic>))
              .where(
                (el) => el.deletedAt == null,
              )
              .toList(),
        );
      }
      print(json);
      return left(const ResponseFailure.internalServerError());
    } catch (e) {
      return left(ResponseFailure.unprocessableEntity(message: e.toString()));
    } finally {
      client.close();
    }
  }

  @override
  FutureEither<SupplierEntity> getSupplierDataByID({required String id}) async {
    try {
      final response = await client.get(
        Uri.https(
          url,
          '$endpoints/$id',
        ),
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (json['code'] == 200 || json['status'] == 'OK') {
        return right(
          SupplierEntity.fromJson(json['data'] as Map<String, dynamic>),
        );
      }
      return left(const ResponseFailure.internalServerError());
    } catch (e) {
      return left(ResponseFailure.unprocessableEntity(message: e.toString()));
    } finally {
      client.close();
    }
  }

  @override
  FutureEitherVoid createNewSupplier({required SupplierEntity request}) async {
    try {
      final response = await client.post(
        Uri.https(url, endpoints),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.copyWith(id: null).toJson()),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (json['code'] == 201 ||
          json['status'] == 'CREATED' ||
          json['code'] == 200 ||
          json['status'] == 'OK') {
        return right(const ResponseSuccess.created());
      }
      return left(const ResponseFailure.internalServerError());
    } catch (e) {
      return left(ResponseFailure.unprocessableEntity(message: e.toString()));
    } finally {
      client.close();
    }
  }

  @override
  FutureEitherVoid updateCurrentSupplier({
    required SupplierEntity request,
    required String id,
  }) async {
    try {
      final response = await client.post(
        Uri.https(url, endpoints),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.copyWith(id: id).toJson()),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['code'] == 201 ||
          json['status'] == 'CREATED' ||
          json['code'] == 200 ||
          json['status'] == 'OK') {
        return right(const ResponseSuccess.edited());
      }
      return left(const ResponseFailure.internalServerError());
    } catch (e) {
      return left(ResponseFailure.unprocessableEntity(message: e.toString()));
    } finally {
      client.close();
    }
  }

  @override
  FutureEitherVoid deleteSupplier({
    required String id,
    required bool deletePermanent,
  }) async {
    try {
      final response = await client.delete(
        Uri.https(
          url,
          endpoints,
          {
            'id': id,
            'permanent': deletePermanent.toString(),
          },
        ),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['code'] == 200 || json['status'] == 'OK') {
        return right(const ResponseSuccess.created());
      } else if (json['code'] == 404) {
        return left(const ResponseFailure.notFound());
      }
      return left(const ResponseFailure.internalServerError());
    } catch (e) {
      return left(ResponseFailure.unprocessableEntity(message: e.toString()));
    } finally {
      client.close();
    }
  }

  @override
  FutureEitherVoid updateSupplierStatus({
    required SupplierEntity request,
    required String id,
    required bool status,
  }) async {
    try {
      final response = await client.post(
        Uri.https(url, endpoints),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.copyWith(id: id, isActive: status).toJson()),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['code'] == 201 ||
          json['status'] == 'CREATED' ||
          json['code'] == 200 ||
          json['status'] == 'OK') {
        return right(const ResponseSuccess.edited());
      }
      return left(const ResponseFailure.internalServerError());
    } catch (e) {
      return left(ResponseFailure.unprocessableEntity(message: e.toString()));
    } finally {
      client.close();
    }
  }
}

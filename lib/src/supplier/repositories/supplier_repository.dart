import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/res/endpoints.dart';
import 'package:raskop_fe_backoffice/res/paths.dart';
import 'package:raskop_fe_backoffice/src/common/failure/response_failure.dart';
import 'package:raskop_fe_backoffice/src/supplier/domain/abstracts/supplier_repository_interface.dart';
import 'package:raskop_fe_backoffice/src/supplier/domain/entities/supplier_entity.dart';

///
class SupplierRepository implements SupplierRepositoryInterface {
  /// Supplier Repository Constructor
  SupplierRepository({required this.client});

  ///
  final http.Client client;

  ///
  final url = BasePaths.baseAPIURL;

  /// Supplier Endpoint
  final endpoints = Endpoints.supplier;

  @override
  FutureEither<List<SupplierEntity>> getAllSupplierData() async {
    try {
      final response = await client.get(Uri.https(url, endpoints));

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (json['code'] == 200 || json['status'] == 'OK') {
        return right(
          (json['data'] as List<dynamic>)
              .map((e) => SupplierEntity.fromJson(e as Map<String, dynamic>))
              .toList(),
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
  FutureEitherVoid createNewSupplier() {
    // TODO: implement createNewSupplier
    throw UnimplementedError();
  }

  @override
  FutureEitherVoid deleteSupplier() {
    // TODO: implement deleteSupplier
    throw UnimplementedError();
  }

  @override
  FutureEitherVoid updateCurrentSupplier() {
    // TODO: implement updateCurrentSupplier
    throw UnimplementedError();
  }
}

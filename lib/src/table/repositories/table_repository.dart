import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/res/endpoints.dart';
import 'package:raskop_fe_backoffice/res/paths.dart';
import 'package:raskop_fe_backoffice/src/common/failure/response_failure.dart';
import 'package:raskop_fe_backoffice/src/common/success/response_success.dart';
import 'package:raskop_fe_backoffice/src/table/domain/abstracts/table_repository_interface.dart';
import 'package:raskop_fe_backoffice/src/table/domain/entities/table_entity.dart';

///
class TableRepository implements TableRepositoryInterface {
  /// Table Repository Constructor
  TableRepository({required this.client, required this.baseClient});

  ///
  final http.Client client;
  final ApiClient baseClient;

  /// Base API URL
  final url = BasePaths.baseAPIURL;

  /// Table Endpoint
  final endpoint = Endpoints.table;

  @override
  FutureEither<List<TableEntity>> getAllTableData() async {
    return baseClient.request<List<TableEntity>>(
      action: 'fetch',
      endpoint: endpoint,
      fromJson: (json) => (json['data'] as List<dynamic>)
          .map((e) => TableEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  FutureEither<TableEntity> getTableDataByID({required String id}) async {
    return baseClient.request<TableEntity>(
      action: 'fetch',
      endpoint: '$endpoint/$id',
      fromJson: TableEntity.fromJson,
    );
  }

  @override
  FutureEitherVoid updateTableStatus({
    required TableEntity request,
    required String id,
    required bool isActive,
  }) async {
    try {
      final uri = Uri.https(url, endpoint);

      final requestMultipart = http.MultipartRequest('POST', uri);

      requestMultipart.fields['id'] = id;
      requestMultipart.fields['minCapacity'] = request.minCapacity.toString();
      requestMultipart.fields['maxCapacity'] = request.maxCapacity.toString();
      requestMultipart.fields['noTable'] = request.noTable;
      requestMultipart.fields['isActive'] = isActive.toString();
      requestMultipart.fields['isOutdoor'] = request.isOutdoor.toString();

      final response = await requestMultipart.send();

      final responseBody = await http.Response.fromStream(response);
      final json = jsonDecode(responseBody.body) as Map<String, dynamic>;

      if (json['code'] == 200 || json['status'] == 'OK') {
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
  FutureEitherVoid updateTableLocation({
    required TableEntity request,
    required String id,
    required bool isOutdoor,
  }) async {
    try {
      final uri = Uri.https(url, endpoint);

      final requestMultipart = http.MultipartRequest('POST', uri);

      requestMultipart.fields['id'] = id;
      requestMultipart.fields['minCapacity'] = request.minCapacity.toString();
      requestMultipart.fields['maxCapacity'] = request.maxCapacity.toString();
      requestMultipart.fields['noTable'] = request.noTable;
      requestMultipart.fields['isActive'] = request.isActive.toString();
      requestMultipart.fields['isOutdoor'] = isOutdoor.toString();

      final response = await requestMultipart.send();

      final responseBody = await http.Response.fromStream(response);
      final json = jsonDecode(responseBody.body) as Map<String, dynamic>;

      if (json['code'] == 200 || json['status'] == 'OK') {
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
  FutureEitherVoid updateTableDescription({
    required TableEntity request,
    required String id,
    required String description,
  }) async {
    try {
      final uri = Uri.https(url, endpoint);

      final requestMultipart = http.MultipartRequest('POST', uri);

      requestMultipart.fields['id'] = id;
      requestMultipart.fields['minCapacity'] = request.minCapacity.toString();
      requestMultipart.fields['maxCapacity'] = request.maxCapacity.toString();
      requestMultipart.fields['noTable'] = request.noTable;
      requestMultipart.fields['isActive'] = request.isActive.toString();
      requestMultipart.fields['isOutdoor'] = request.isOutdoor.toString();
      requestMultipart.fields['description'] = description;

      final response = await requestMultipart.send();

      final responseBody = await http.Response.fromStream(response);
      final json = jsonDecode(responseBody.body) as Map<String, dynamic>;

      if (json['code'] == 200 || json['status'] == 'OK') {
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
  FutureEitherVoid deleteTable({
    required String id,
    required bool deletePermanent,
  }) async {
    return baseClient.request<ResponseSuccess>(
      endpoint: endpoint,
      action: 'delete',
      method: 'DELETE',
      queryParameters: {
        'id': id,
        'permanent': deletePermanent.toString(),
      },
    );
  }
}

import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/res/endpoints.dart';
import 'package:raskop_fe_backoffice/res/paths.dart';
import 'package:raskop_fe_backoffice/src/common/failure/response_failure.dart';
import 'package:raskop_fe_backoffice/src/common/success/response_success.dart';
import 'package:raskop_fe_backoffice/src/menu/domain/abstracts/menu_repository_interface.dart';
import 'package:raskop_fe_backoffice/src/menu/domain/entities/menu_entity.dart';

///
class MenuRepository implements MenuRepositoryInterface {
  /// Menu Repository Constructor
  MenuRepository({required this.client});

  ///
  final http.Client client;

  /// Base API URL
  final url = BasePaths.baseAPIURL;

  /// Menu Endpoint
  final endpoints = Endpoints.menu;

  @override
  FutureEither<List<MenuEntity>> getAllMenuData({
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
              .map((e) => MenuEntity.fromJson(e as Map<String, dynamic>))
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
  FutureEither<MenuEntity> getMenuDataByID({required String id}) async {
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
          MenuEntity.fromJson(json['data'] as Map<String, dynamic>),
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
  FutureEitherVoid createNewMenu({required MenuEntity request}) async {
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
  FutureEitherVoid updateCurrentMenu({
    required MenuEntity request,
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
  FutureEitherVoid deleteMenu({
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
  FutureEitherVoid updateMenuStatus({
    required MenuEntity request,
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

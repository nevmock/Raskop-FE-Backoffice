import 'dart:convert';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
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
  FutureEitherVoid createNewMenu(
      {required MenuEntity request, String? imageFile}) async {
    try {
      final formData = http.MultipartRequest('POST', Uri.https(url, endpoints))
        ..headers.addAll({'Content-Type': 'multipart/form-data'});

      formData.fields.addAll({
        'name': request.name,
        'price': request.price.toString(),
        'description': request.description,
        'category': request.category,
        'qty': request.qty.toString(),
        'isActive': request.isActive?.toString() ?? 'false',
      });

      if (imageFile != null) {
        final mimeType = lookupMimeType(imageFile!);
        final file = File(imageFile);
        if (!await file.exists()) {
          return left(ResponseFailure.unprocessableEntity(
              message: 'File does not exist!'));
        } else {
          final stream = http.ByteStream(file.openRead());
          final length = await file.length();

          final imageFilePart = http.MultipartFile(
            'image',
            stream,
            length,
            filename: file.uri.pathSegments.last,
            contentType: MediaType.parse(mimeType!),
          );

          formData.files.add(imageFilePart);
        }
      }

      final response =
          await client.send(formData).timeout(Duration(seconds: 60));
      final jsonResponse = await http.Response.fromStream(response);
      final json = jsonDecode(jsonResponse.body) as Map<String, dynamic>;

      if (json['code'] == 201 ||
          json['status'] == 'CREATED' ||
          json['code'] == 200 ||
          json['status'] == 'OK') {
        return right(const ResponseSuccess.created());
      }
      return left(const ResponseFailure.internalServerError());
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');
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
      print(jsonEncode(request.copyWith(id: id, isActive: status).toJson()));
      print(json);
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

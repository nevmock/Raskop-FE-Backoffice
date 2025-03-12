import 'dart:convert';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
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
  MenuRepository({required this.client, required this.baseClient});

  ///
  final http.Client client;

  ///
  final ApiClient baseClient;

  /// Base API URL
  final url = BasePaths.baseAPIURL;

  /// Menu Endpoint
  final endpoint = Endpoints.menu;

  @override
  FutureEither<List<MenuEntity>> getAllMenuData({
    int? start,
    int? length,
    String? search,
    Map<String, dynamic>? advSearch,
    List<Map<String, dynamic>>? order,
  }) async {
    return baseClient.request<List<MenuEntity>>(
      action: 'fetch',
      endpoint: endpoint,
      fromJson: (json) => (json['data'] as List<dynamic>)
          .map((e) => MenuEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      queryParameters: {
        if (start != null) 'start': start.toString(),
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
  FutureEither<MenuEntity> getMenuDataByID({required String id}) async {
    return baseClient.request<MenuEntity>(
      action: 'fetch',
      endpoint: '$endpoint/$id',
      fromJson: MenuEntity.fromJson,
    );
  }

  @override
  FutureEitherVoid createNewMenu({
    required MenuEntity request,
    String? imageFile,
  }) async {
    try {
      final formData = http.MultipartRequest('POST', Uri.https(url, endpoint))
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
        final mimeType = lookupMimeType(imageFile);
        final file = File(imageFile);
        if (!await file.exists()) {
          return left(
            const ResponseFailure.unprocessableEntity(
              message: 'File does not exist!',
            ),
          );
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
          await client.send(formData).timeout(const Duration(seconds: 60));
      final jsonResponse = await http.Response.fromStream(response);
      final json = jsonDecode(jsonResponse.body) as Map<String, dynamic>;

      if (json['code'] == 201 ||
          json['status'] == 'CREATED' ||
          json['code'] == 200 ||
          json['status'] == 'OK') {
        return right(const ResponseSuccess.created());
      }
      return left(
        ResponseFailure.internalServerError(
          message: json['errors'].toString(),
        ),
      );
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
    String? imageFile,
  }) async {
    try {
      final formData = http.MultipartRequest('POST', Uri.https(url, endpoint))
        ..headers.addAll({'Content-Type': 'multipart/form-data'});

      formData.fields.addAll({
        'name': request.name,
        'price': request.price.toString(),
        'description': request.description,
        'category': request.category,
        'qty': request.qty.toString(),
        'isActive': request.isActive?.toString() ?? 'false',
        'id': id,
      });

      if (imageFile != null) {
        final mimeType = lookupMimeType(imageFile);
        final file = File(imageFile);
        if (!await file.exists()) {
          return left(
            const ResponseFailure.unprocessableEntity(
              message: 'File does not exist!',
            ),
          );
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
          await client.send(formData).timeout(const Duration(seconds: 60));
      final jsonResponse = await http.Response.fromStream(response);
      final json = jsonDecode(jsonResponse.body) as Map<String, dynamic>;
      if (json['code'] == 201 ||
          json['status'] == 'CREATED' ||
          json['code'] == 200 ||
          json['status'] == 'OK') {
        return right(const ResponseSuccess.edited());
      }
      return left(
        ResponseFailure.internalServerError(
          message: json['errors'].toString(),
        ),
      );
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

  @override
  FutureEitherVoid updateMenuStatus({
    required MenuEntity request,
    required String id,
    required bool status,
  }) async {
    try {
      final uri = Uri.https(url, endpoint);

      final requestMultipart = http.MultipartRequest('POST', uri);

      requestMultipart.fields['id'] = id;
      requestMultipart.fields['name'] = request.name;
      requestMultipart.fields['price'] = request.price.toString();
      requestMultipart.fields['description'] = request.description;
      requestMultipart.fields['category'] = request.category;
      requestMultipart.fields['qty'] = request.qty.toString();
      requestMultipart.fields['isActive'] = status.toString();

      final response = await requestMultipart.send();

      final responseBody = await http.Response.fromStream(response);
      final json = jsonDecode(responseBody.body) as Map<String, dynamic>;

      if (json['code'] == 200 || json['status'] == 'OK') {
        return right(const ResponseSuccess.edited());
      }
      return left(
        ResponseFailure.internalServerError(
          message: json['errors'].toString(),
        ),
      );
    } catch (e) {
      return left(ResponseFailure.unprocessableEntity(message: e.toString()));
    } finally {
      client.close();
    }
  }
}

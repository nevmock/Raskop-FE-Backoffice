// ignore_for_file: unnecessary_breaks

import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:raskop_fe_backoffice/src/common/failure/response_failure.dart';
import 'package:raskop_fe_backoffice/src/common/success/response_success.dart';

/// API Client Class To Make Request
class ApiClient {
  /// Constructor
  ApiClient({required this.client, required this.baseUrl});

  /// Client
  final http.Client client;

  /// baseURL
  final String baseUrl;

  /// generic http request method | Untuk action argument : Isi antara dengan fetch, create, edit, atau delete
  Future<Either<ResponseFailure, T>> request<T>({
    required String endpoint,

    /// Isi antara dengan fetch, created, edited, atau deleted
    required String action,
    T Function(Map<String, dynamic>)? fromJson,
    String method = 'GET',
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Encoding? encoding,
  }) async {
    try {
      final url = Uri.https(baseUrl, endpoint, queryParameters);

      late http.Response response;

      switch (method) {
        case 'POST':
          response = await client.post(
            url,
            headers: headers,
            body: jsonEncode(body),
            encoding: encoding,
          );
          break;
        case 'PUT':
          response = await client.put(
            url,
            headers: headers,
            body: jsonEncode(body),
            encoding: encoding,
          );
          break;
        case 'DELETE':
          response =
              await client.delete(url, headers: headers, encoding: encoding);
          break;
        default: // GET
          response = await client.get(url, headers: headers);
      }

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonResponse);
      if (jsonResponse['code'] == 200 ||
          jsonResponse['status'].toString().toLowerCase() == 'ok' ||
          jsonResponse['code'] == 201 ||
          jsonResponse['status'].toString().toLowerCase() == 'created') {
        if (T == ResponseSuccess) {
          if (action.toLowerCase() == 'create') {
            return right(const ResponseSuccess.created() as T);
          } else if (action.toLowerCase() == 'edit') {
            return right(const ResponseSuccess.edited() as T);
          } else if (action.toLowerCase() == 'delete') {
            return right(const ResponseSuccess.deleted() as T);
          } else {
            return right(ResponseSuccess as T);
          }
        }
        final result =
            fromJson != null ? fromJson(jsonResponse) : jsonResponse as T;
        return right(result);
      }
      if (jsonResponse['code'] == 404) {
        return left(
          ResponseFailure.notFound(
            message: jsonResponse['errors'] as Map<String, dynamic>,
          ),
        );
      }
      if (jsonResponse['code'] == 400) {
        return left(
          ResponseFailure.badRequest(
            message: jsonResponse['errors'] as Map<String, dynamic>,
          ),
        );
      }
      return left(
        ResponseFailure.internalServerError(
          message: jsonResponse['errors'] as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      return left(ResponseFailure.unprocessableEntity(message: e.toString()));
    }
  }
}

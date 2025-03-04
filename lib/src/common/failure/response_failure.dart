import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_failure.freezed.dart';

@freezed

///
class ResponseFailure implements Exception {
  const ResponseFailure._();

  /// Unexpected error
  const factory ResponseFailure.unprocessableEntity({required String message}) =
      _UnprocessableEntityResponseFailure;

  /// Expected value is null or empty
  const factory ResponseFailure.empty() = _EmptyResponseFailure;

  /// 400 Error Response Code
  const factory ResponseFailure.badRequest({required String message}) =
      _BadRequestResponseFailure;

  /// 500 Error Response Code
  const factory ResponseFailure.internalServerError({required String message}) =
      _InternalServerErrorResponseFailure;

  /// 404 Error Response Code
  const factory ResponseFailure.notFound({required String message}) =
      _NotFoundResponseFailure;

  /// Get the error message for specified failure
  String get unknownError => this is _UnprocessableEntityResponseFailure
      ? (this as _UnprocessableEntityResponseFailure).message
      : '$this';

  /// Get the error message for specified failure
  String get badRequestError => this is _BadRequestResponseFailure
      ? (this as _BadRequestResponseFailure).message
      : '$this';

  /// Get the error message for specified failure
  String get internalServerError => this is _InternalServerErrorResponseFailure
      ? (this as _InternalServerErrorResponseFailure).message
      : '$this';

  /// Get the error message for specified failure
  String get notFoundError => this is _NotFoundResponseFailure
      ? (this as _NotFoundResponseFailure).message
      : '$this';

  /// Get all of the error message
  String get allError => this is _UnprocessableEntityResponseFailure
      ? (this as _UnprocessableEntityResponseFailure).message
      : this is _BadRequestResponseFailure
          ? (this as _BadRequestResponseFailure).message
          : this is _InternalServerErrorResponseFailure
              ? (this as _InternalServerErrorResponseFailure).message
              : this is _NotFoundResponseFailure
                  ? (this as _NotFoundResponseFailure).message
                  : '$this';
}

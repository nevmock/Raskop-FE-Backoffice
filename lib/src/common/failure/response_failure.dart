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
  const factory ResponseFailure.badRequest() = _BadRequestResponseFailure;

  /// 500 Error Response Code
  const factory ResponseFailure.internalServerError() =
      _InternalServerErrorResponseFailure;

  /// Get the error message for specified failure
  String get error => this is _UnprocessableEntityResponseFailure
      ? (this as _UnprocessableEntityResponseFailure).message
      : '$this';
}

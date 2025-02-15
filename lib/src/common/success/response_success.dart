import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_success.freezed.dart';

@freezed

///
class ResponseSuccess {
  const ResponseSuccess._();

  /// Create Post Request Success
  const factory ResponseSuccess.created() = _CreatedResponseSuccess;

  /// Edit Post Request Success
  const factory ResponseSuccess.edited() = _EditedResponseSuccess;

  /// Delete Request Success
  const factory ResponseSuccess.deleted() = _DeletedResponseSuccess;
}

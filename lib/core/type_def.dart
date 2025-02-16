import 'package:fpdart/fpdart.dart';
import 'package:raskop_fe_backoffice/src/common/failure/response_failure.dart';
import 'package:raskop_fe_backoffice/src/common/success/response_success.dart';

/// Future Either which return either value or failure message
typedef FutureEither<Value> = Future<Either<ResponseFailure, Value>>;

/// Future Either Void which return success or failure message
typedef FutureEitherVoid = Future<Either<ResponseFailure, ResponseSuccess>>;

/// Void Future
typedef FutureVoid = Future<void>;

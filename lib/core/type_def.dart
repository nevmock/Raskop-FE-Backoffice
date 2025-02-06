import 'package:fpdart/fpdart.dart';
import 'package:raskop_fe_backoffice/src/common/failure/response_failure.dart';

/// Future Either which return either value or failure message
typedef FutureEither<Value> = Future<Either<ResponseFailure, Value>>;

/// Future Either Void which return void or failure message
typedef FutureEitherVoid = Future<Either<ResponseFailure, void>>;

/// Void Future
typedef FutureVoid = Future<void>;

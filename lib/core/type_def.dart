import 'package:fpdart/fpdart.dart';
import 'package:raskop_fe_backoffice/core/core.dart';

/// Future Either which return either value or failure message
typedef FutureEither<Value> = Future<Either<Failure, Value>>;

/// Future Either Void which return void or failure message
typedef FutureEitherVoid = Future<Either<Failure, void>>;

/// Void Future
typedef FutureVoid = Future<void>;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

/// One class per action, single [call]. `Type` is the success payload,
/// `Params` is the input (use [NoParams] when the use case takes nothing).
abstract class UseCase<Type, Params> {
  ResultFuture<Type> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

import 'package:equatable/equatable.dart';

/// Domain/presentation-facing error type. Never carries a stack trace or a
/// raw exception — only what the UI needs to show the user.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final Map<String, List<String>>? errors;
  final int? statusCode;
  const ServerFailure(super.message, {this.errors, this.statusCode});

  @override
  List<Object?> get props => [message, errors, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Nothing cached']);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Please log in to continue']);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Something went wrong']);
}

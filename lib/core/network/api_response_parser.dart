import 'package:dio/dio.dart';

import '../error/exceptions.dart';

/// Unwraps the backend's `{status, message, data, pagination?, errors?}`
/// envelope. Every remote data source funnels its dio calls through this so
/// no raw [Response] or envelope map ever leaks past the data layer.
class ApiResponseParser {
  ApiResponseParser._();

  /// Returns the `data` payload when `status` is true, otherwise throws a
  /// [ServerException] carrying the API's `message` (and `errors`, if any).
  static dynamic unwrap(Response response) {
    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const ServerException(message: 'Unexpected response from server');
    }

    final status = body['status'] == true;
    final message = body['message']?.toString() ?? 'Something went wrong';

    if (!status) {
      final rawErrors = body['errors'];
      Map<String, List<String>>? errors;
      if (rawErrors is Map) {
        errors = rawErrors.map(
          (key, value) => MapEntry(
            key.toString(),
            (value as List).map((e) => e.toString()).toList(),
          ),
        );
      }
      throw ServerException(
        message: message,
        statusCode: response.statusCode,
        errors: errors,
      );
    }

    return body['data'];
  }

  static Map<String, dynamic> pagination(Response response) {
    final body = response.data as Map<String, dynamic>;
    final raw = body['pagination'] as Map<String, dynamic>?;
    return raw ?? const {};
  }

  /// Converts a [DioException] (network hiccup, timeout, non-2xx without a
  /// parsable envelope) into our own exception types.
  static Never handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      throw const NetworkException();
    }

    final response = e.response;
    if (response != null) {
      final body = response.data;
      if (body is Map<String, dynamic>) {
        unwrap(response);
      }
      throw ServerException(
        message: 'Server error (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }

    throw ServerException(message: e.message ?? 'Unexpected network error');
  }
}

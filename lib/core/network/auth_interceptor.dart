import 'package:dio/dio.dart';

import '../session/auth_session.dart';

/// Attaches the bearer token to every request and clears the session the
/// moment the backend says it's no longer valid (401), so the router guard
/// can bounce the user to the guest/login flow on the very next rebuild.
class AuthInterceptor extends Interceptor {
  final AuthSession _authSession;

  AuthInterceptor(this._authSession);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _authSession.token;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    // Multipart requests (file uploads) must keep the
    // "multipart/form-data; boundary=..." content type dio derives from
    // the FormData body — forcing json here would break the upload.
    if (options.data is! FormData) {
      options.headers['Content-Type'] = 'application/json';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _authSession.clear();
    }
    handler.next(err);
  }
}

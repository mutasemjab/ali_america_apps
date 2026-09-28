/// Build-time configuration for this single-store white-label app.
///
/// Override at build/run time with:
///   flutter run --dart-define=APP_URL=http://localhost/ali_market --dart-define=STORE_ID=1
/// or pass a `--dart-define-from-file=env/dev.json` style file.
class AppConfig {
  AppConfig._();

  static const String appUrl = String.fromEnvironment(
    'APP_URL',
    defaultValue: 'https://flyerall.net',
  );

  static const String storeId = String.fromEnvironment(
    'STORE_ID',
    defaultValue: '1',
  );

  static String get apiBaseUrl => '$appUrl/api/v1';

  static String storePath(String suffix) => '/stores/$storeId$suffix';
}

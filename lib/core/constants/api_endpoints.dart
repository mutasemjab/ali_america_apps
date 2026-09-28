import '../config/app_config.dart';

/// All backend routes, relative to [AppConfig.apiBaseUrl]. Paths and field
/// names here are final and must match the deployed Laravel API exactly.
class ApiEndpoints {
  ApiEndpoints._();

  static String get register => AppConfig.storePath('/auth/register');
  static String get login => AppConfig.storePath('/auth/login');
  static String get resendOtp => AppConfig.storePath('/auth/resend-otp');
  static String get verifyOtp => AppConfig.storePath('/auth/verify-otp');
  static const String logout = '/auth/logout';

  static String get home => AppConfig.storePath('/home');
  static String get categories => AppConfig.storePath('/categories');
  static String get products => AppConfig.storePath('/products');
  static String get socials => AppConfig.storePath('/socials');
  static String get qrs => AppConfig.storePath('/qrs');
  static String get weeklyAds => AppConfig.storePath('/weekly-ads');
  static String get locations => AppConfig.storePath('/locations');
  static String get coupons => AppConfig.storePath('/coupons');

  /// Shared endpoint for legal documents other than the client app's own
  /// privacy policy — which one comes back is selected by the `type` query
  /// param (see LegalDocumentType). This also backs the tablet kiosk's
  /// privacy policy (`type=privacy_policy`) — leave that usage alone.
  static String get legalDocument => AppConfig.storePath('/legal-document');

  /// The client mobile app's OWN privacy policy — separate content, its
  /// own admin page, and its own endpoint. Not the same document as
  /// `legalDocument(type: privacy_policy)`, which is the tablet kiosk's.
  static String get clientPrivacyPolicy => AppConfig.storePath('/privacy-policy');

  static String clipCoupon(int couponId) =>
      AppConfig.storePath('/coupons/$couponId/clip');

  static String get careers => AppConfig.storePath('/careers');
  static String applyToCareer(int careerId) => AppConfig.storePath('/careers/$careerId/apply');

  static String get rewards => AppConfig.storePath('/rewards');
  static String redeemReward(int rewardId) => AppConfig.storePath('/rewards/$rewardId/redeem');

  static const String me = '/me';
}

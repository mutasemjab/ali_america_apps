/// Which legal document to load. For [termsOfService] and [antiSpamPolicy]
/// this doubles as the `type` query param on the shared /legal-document
/// endpoint. [privacyPolicy] is special-cased in the data source to hit
/// its own dedicated endpoint instead — the client app's privacy policy is
/// separate content from the tablet kiosk's (which still uses
/// /legal-document?type=privacy_policy).
class LegalDocumentType {
  LegalDocumentType._();

  static const String privacyPolicy = 'privacy_policy';
  static const String termsOfService = 'terms_of_service';
  static const String antiSpamPolicy = 'anti_spam_policy';
}

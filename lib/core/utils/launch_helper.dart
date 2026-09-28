import 'package:url_launcher/url_launcher.dart';

/// Wraps url_launcher for the few external-intent actions this app needs:
/// opening a website/social link, dialing a phone number, and handing lat/lng
/// off to the device's native maps app.
class LaunchHelper {
  LaunchHelper._();

  static Future<bool> openUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return Future.value(false);
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<bool> callPhone(String phone) {
    final uri = Uri(scheme: 'tel', path: phone);
    return launchUrl(uri);
  }

  static Future<bool> openDirections({
    required double lat,
    required double lng,
    String? label,
  }) async {
    final query = Uri.encodeComponent(label ?? '$lat,$lng');
    // geo: uri gives the OS a chance to offer its native maps app first;
    // fall back to the Google Maps web URL if that fails.
    final geoUri = Uri.parse('geo:$lat,$lng?q=$lat,$lng($query)');
    if (await canLaunchUrl(geoUri)) {
      return launchUrl(geoUri, mode: LaunchMode.externalApplication);
    }
    final webUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    return launchUrl(webUri, mode: LaunchMode.externalApplication);
  }
}

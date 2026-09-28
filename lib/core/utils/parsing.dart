/// Parses a price/amount field that may arrive as a number, a plain numeric
/// string, or a string with a currency symbol attached (seen from the API
/// as both "10" and "10$") — strips anything that isn't a digit, '.', or
/// '-' before parsing, so a stray symbol never silently collapses a real
/// price to 0.
double parseFlexibleDouble(dynamic value, {double fallback = 0}) {
  if (value == null) return fallback;
  if (value is num) return value.toDouble();
  final cleaned = value.toString().replaceAll(RegExp(r'[^0-9.\-]'), '');
  return double.tryParse(cleaned) ?? fallback;
}

final _cleanPricePattern = RegExp(r'^\$?\s*(\d+(?:\.\d+)?)\s*\$?$');

/// Formats a price field for display. Some backends send a plain amount
/// ("22.95", "10$") — that gets normalized to "$X.XX". Others send a
/// promotional string that isn't reducible to one number at all
/// ("2/95¢" = 2 for 95 cents, "89¢ea" = 89 cents each) — stripping symbols
/// from those and reparsing as a decimal silently produces nonsense
/// ("2/95¢" -> "295" -> "$295.00"), so anything that doesn't look like a
/// single clean number is returned exactly as the backend sent it.
String formatPriceLabel(dynamic value) {
  if (value == null) return '';
  final raw = value.toString().trim();
  if (raw.isEmpty) return '';

  final match = _cleanPricePattern.firstMatch(raw);
  if (match != null) {
    final amount = double.tryParse(match.group(1)!);
    if (amount != null) return '\$${amount.toStringAsFixed(2)}';
  }
  return raw;
}

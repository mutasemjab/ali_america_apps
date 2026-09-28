import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Distinctive type scale: Fraunces for display/headings (a bit of
/// character, feels like a store's signage) + Inter for everything
/// functional (labels, body, numbers).
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _display => GoogleFonts.fraunces();
  static TextStyle get _body => GoogleFonts.inter();

  static TextStyle get displayLarge => _display.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.15,
      );

  static TextStyle get displayMedium => _display.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get headline => _display.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleLarge => _body.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMedium => _body.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLarge => _body.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => _body.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get label => _body.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.3,
      );

  static TextStyle get button => _body.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnPrimary,
      );

  static TextStyle get price => _body.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: AppColors.success,
      );

  static TextStyle get priceStrike => _body.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        decoration: TextDecoration.lineThrough,
      );

  /// Bigger, richer pairing used only for coupon prices — the coupons
  /// list/detail is meant to make the deal price pop more than a regular
  /// product price does.
  static TextStyle get couponPrice => _body.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: AppColors.success,
      );

  static TextStyle get couponPriceStrike => _body.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        decoration: TextDecoration.lineThrough,
      );
}

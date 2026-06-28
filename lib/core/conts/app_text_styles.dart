import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized typography system.
/// All sizes use ScreenUtil (.sp) for responsive scaling.
/// Use semantic style getters in widgets; use size tokens for custom overrides.
class AppTextStyles {
  AppTextStyles._();

  // ─── SIZE TOKENS ──────────────────────────────────────────────────────────
  static double get display    => 32.sp;
  static double get h1         => 28.sp;
  static double get h2         => 24.sp;
  static double get h3         => 20.sp;   // AppBar / dialog title
  static double get h4         => 18.sp;   // Section / card title
  static double get subtitle1  => 16.sp;   // Input, tab active, card subtitle
  static double get subtitle2  => 15.sp;   // Body text, button
  static double get bodySm     => 14.sp;   // Secondary text, tab inactive, label
  static double get caption    => 12.sp;   // Captions, bottom nav
  static double get chip       => 13.sp;   // Chip labels
  static double get tiny       => 10.sp;   // Smallest text

  // ─── COMPONENT STYLES ─────────────────────────────────────────────────────

  /// AppBar and screen-level title (20sp, bold)
  static TextStyle get appBarTitle => TextStyle(
    fontSize: h3,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: 0,
  );

  /// Large page hero title (24sp, bold)
  static TextStyle get pageTitle => TextStyle(
    fontSize: h2,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: 0,
  );

  /// Section header within a screen (20sp, semiBold)
  static TextStyle get sectionTitle => TextStyle(
    fontSize: h3,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Card or list item primary label (18sp, semiBold)
  static TextStyle get cardTitle => TextStyle(
    fontSize: h4,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Card secondary text (15sp, regular)
  static TextStyle get cardSubtitle => TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
  );

  /// List item primary text (16sp, medium)
  static TextStyle get listTitle => TextStyle(
    fontSize: subtitle1,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
  );

  /// List item secondary text (14sp, regular)
  static TextStyle get listSubtitle => TextStyle(
    fontSize: bodySm,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Main body text (15sp, regular)
  static TextStyle get bodyText => TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0,
  );

  /// Bold body text (15sp, bold) — for label:value pairs, emphasis
  static TextStyle get bodyBold => TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: 0,
  );

  /// Secondary body (14sp, regular)
  static TextStyle get secondary => TextStyle(
    fontSize: bodySm,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
  );

  /// Secondary bold (14sp, bold)
  static TextStyle get secondaryBold => TextStyle(
    fontSize: bodySm,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: 0,
  );

  /// Caption / fine print (12sp, regular)
  static TextStyle get captionText => TextStyle(
    fontSize: caption,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Tiny label (10sp, regular)
  static TextStyle get tinyText => TextStyle(
    fontSize: tiny,
    fontWeight: FontWeight.w400,
    height: 1.3,
    letterSpacing: 0,
  );

  /// Button label (15sp, bold)
  static TextStyle get buttonText => TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: 0.3,
  );

  /// Form input text (16sp, regular)
  static TextStyle get inputText => TextStyle(
    fontSize: subtitle1,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
  );

  /// Form label (14sp, regular)
  static TextStyle get labelText => TextStyle(
    fontSize: bodySm,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
  );

  /// Form hint text (14sp, regular)
  static TextStyle get hintText => TextStyle(
    fontSize: bodySm,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
  );

  /// Active tab label (16sp, bold)
  static TextStyle get tabActive => TextStyle(
    fontSize: subtitle1,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: 0,
  );

  /// Inactive tab label (14sp, regular)
  static TextStyle get tabInactive => TextStyle(
    fontSize: bodySm,
    fontWeight: FontWeight.w400,
    height: 1.3,
    letterSpacing: 0,
  );

  /// Bottom navigation label (12sp, medium)
  static TextStyle get navLabel => TextStyle(
    fontSize: caption,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0,
  );

  /// Dialog / bottom sheet title (20sp, bold)
  static TextStyle get dialogTitle => TextStyle(
    fontSize: h3,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Dialog body content (15sp, regular)
  static TextStyle get dialogContent => TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0,
  );

  /// Chip label (13sp, medium)
  static TextStyle get chipText => TextStyle(
    fontSize: chip,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0,
  );

  /// Profile / account name (18sp, bold)
  static TextStyle get profileName => TextStyle(
    fontSize: h4,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Profile secondary info / username (16sp, regular)
  static TextStyle get profileInfo => TextStyle(
    fontSize: subtitle1,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Settings / profile menu item label (15sp, medium)
  static TextStyle get menuItem => TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
  );

  // ─── WEIGHT-ONLY VARIANTS ─────────────────────────────────────────────────
  // These match the old AbhayaLibre* / AlMaraia* naming convention.
  // They carry the correct base size so .copyWith() overrides still work.

  static TextStyle get regular   => TextStyle(fontSize: subtitle2, fontWeight: FontWeight.w400, height: 1.5);
  static TextStyle get medium    => TextStyle(fontSize: subtitle2, fontWeight: FontWeight.w500, height: 1.5);
  static TextStyle get semiBold  => TextStyle(fontSize: subtitle2, fontWeight: FontWeight.w600, height: 1.5);
  static TextStyle get bold      => TextStyle(fontSize: subtitle2, fontWeight: FontWeight.w700, height: 1.5);
  static TextStyle get extraBold => TextStyle(fontSize: subtitle2, fontWeight: FontWeight.w900, height: 1.5);
}

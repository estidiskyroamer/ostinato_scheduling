import 'package:flutter/material.dart';

@immutable
class OstinatoThemeExtension extends ThemeExtension<OstinatoThemeExtension> {
  final Color headerBackgroundColor;
  final Color headerForegroundColor;
  final Color rowIconColor;
  final Color inputHintColor;
  final Color textColor;
  final Color borderColor;

  const OstinatoThemeExtension({required this.headerBackgroundColor, required this.headerForegroundColor, required this.rowIconColor, required this.inputHintColor, required this.textColor, required this.borderColor});

  @override
  OstinatoThemeExtension copyWith({Color? headerBackgroundColor, Color? headerForegroundColor, Color? rowIconColor, Color? inputHintColor, Color? textColor, Color? borderColor}) {
    return OstinatoThemeExtension(
      headerBackgroundColor: headerBackgroundColor ?? this.headerBackgroundColor, 
      headerForegroundColor: headerForegroundColor ?? this.headerForegroundColor,
      rowIconColor: rowIconColor ?? this.rowIconColor,
      inputHintColor: inputHintColor ?? this.inputHintColor,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
    );
  }

  @override
  OstinatoThemeExtension lerp(ThemeExtension<OstinatoThemeExtension>? other, double t) {
    if (other is! OstinatoThemeExtension) {
      return this;
    }
    return OstinatoThemeExtension(
      headerBackgroundColor: Color.lerp(headerBackgroundColor, other.headerBackgroundColor, t)!,
      headerForegroundColor: Color.lerp(headerForegroundColor, other.headerForegroundColor, t)!,
      rowIconColor: Color.lerp(rowIconColor, other.rowIconColor, t)!,
      inputHintColor: Color.lerp(inputHintColor, other.inputHintColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
    );
  }
}

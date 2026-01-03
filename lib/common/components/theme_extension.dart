import 'package:flutter/material.dart';

@immutable
class OstinatoThemeExtension extends ThemeExtension<OstinatoThemeExtension> {
  final Color headerBackgroundColor;
  final Color headerForegroundColor;
  final Color rowIconColor;
  final Color inputHintColor;
  final Color textColor;
  final Color borderColor;
  final Color buttonBackgroundColor;
  final Color buttonForegroundColor;
  final Color separatorColor;
  final Color scheduleHighlightColor;
  final Color navBarColor;
  final Color navBarSelectedItemColor;
  final Color navBarUnselectedItemColor;
  final Color dangerColor;

  const OstinatoThemeExtension({
    required this.headerBackgroundColor,
    required this.headerForegroundColor,
    required this.rowIconColor,
    required this.inputHintColor,
    required this.textColor,
    required this.borderColor,
    required this.buttonBackgroundColor,
    required this.buttonForegroundColor,
    required this.separatorColor,
    required this.scheduleHighlightColor,
    required this.navBarColor,
    required this.navBarSelectedItemColor,
    required this.navBarUnselectedItemColor,
    required this.dangerColor,
  });

  @override
  OstinatoThemeExtension copyWith({
    Color? headerBackgroundColor,
    Color? headerForegroundColor,
    Color? rowIconColor,
    Color? inputHintColor,
    Color? textColor,
    Color? borderColor,
    Color? buttonBackgroundColor,
    Color? buttonForegroundColor,
    Color? separatorColor,
    Color? scheduleHighlightColor,
    Color? navBarColor,
    Color? navBarSelectedItemColor,
    Color? navBarUnselectedItemColor,
    Color? dangerColor,
  }) =>
      OstinatoThemeExtension(
        headerBackgroundColor: headerBackgroundColor ?? this.headerBackgroundColor,
        headerForegroundColor: headerForegroundColor ?? this.headerForegroundColor,
        rowIconColor: rowIconColor ?? this.rowIconColor,
        inputHintColor: inputHintColor ?? this.inputHintColor,
        textColor: textColor ?? this.textColor,
        borderColor: borderColor ?? this.borderColor,
        buttonBackgroundColor: buttonBackgroundColor ?? this.buttonBackgroundColor,
        buttonForegroundColor: buttonForegroundColor ?? this.buttonForegroundColor,
        separatorColor: separatorColor ?? this.separatorColor,
        scheduleHighlightColor: scheduleHighlightColor ?? this.scheduleHighlightColor,
        navBarColor: navBarColor ?? this.navBarColor,
        navBarSelectedItemColor: navBarSelectedItemColor ?? this.navBarSelectedItemColor,
        navBarUnselectedItemColor: navBarUnselectedItemColor ?? this.navBarUnselectedItemColor,
        dangerColor: dangerColor ?? this.dangerColor,
      );

  @override
  OstinatoThemeExtension lerp(ThemeExtension<OstinatoThemeExtension>? other, double t) => other is! OstinatoThemeExtension
      ? this
      : OstinatoThemeExtension(
          headerBackgroundColor: Color.lerp(headerBackgroundColor, other.headerBackgroundColor, t)!,
          headerForegroundColor: Color.lerp(headerForegroundColor, other.headerForegroundColor, t)!,
          rowIconColor: Color.lerp(rowIconColor, other.rowIconColor, t)!,
          inputHintColor: Color.lerp(inputHintColor, other.inputHintColor, t)!,
          textColor: Color.lerp(textColor, other.textColor, t)!,
          borderColor: Color.lerp(borderColor, other.borderColor, t)!,
          buttonBackgroundColor: Color.lerp(buttonBackgroundColor, other.buttonBackgroundColor, t)!,
          buttonForegroundColor: Color.lerp(buttonForegroundColor, other.buttonForegroundColor, t)!,
          separatorColor: Color.lerp(separatorColor, other.separatorColor, t)!,
          scheduleHighlightColor: Color.lerp(scheduleHighlightColor, other.scheduleHighlightColor, t)!,
          navBarColor: Color.lerp(navBarColor, other.navBarColor, t)!,
          navBarSelectedItemColor: Color.lerp(navBarSelectedItemColor, other.navBarSelectedItemColor, t)!,
          navBarUnselectedItemColor: Color.lerp(navBarUnselectedItemColor, other.navBarUnselectedItemColor, t)!,
          dangerColor: Color.lerp(dangerColor, other.dangerColor, t)!,
        );
}
